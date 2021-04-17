//Generic: On/Off
/obj/machinery/atmospherics/can_blueprint_to()
	return ..() + /obj/machinery/atmospherics

/obj/machinery/atmospherics/blueprint_to(obj/machinery/atmospherics/other)
	. = ..()
	if(!istype(other))
		return
	other.on = on

//Passive gate: Target pressure
/obj/machinery/atmospherics/components/binary/passive_gate/can_blueprint_to()
	return ..() + /obj/machinery/atmospherics/components/binary/passive_gate

/obj/machinery/atmospherics/components/binary/passive_gate/blueprint_to(obj/machinery/atmospherics/components/binary/passive_gate/other)
	. = ..()
	if(!istype(other))
		return
	other.target_pressure = target_pressure

//Gas pump: Target pressure
/obj/machinery/atmospherics/components/binary/pump/can_blueprint_to()
	return ..() + /obj/machinery/atmospherics/components/binary/pump

/obj/machinery/atmospherics/components/binary/pump/blueprint_to(obj/machinery/atmospherics/components/binary/pump/other)
	. = ..()
	if(!istype(other))
		return
	other.target_pressure = target_pressure

//Volume pump: Transfer rate, overclocked
/obj/machinery/atmospherics/components/binary/volume_pump/can_blueprint_to()
	return ..() + /obj/machinery/atmospherics/components/binary/volume_pump

/obj/machinery/atmospherics/components/binary/volume_pump/blueprint_to(obj/machinery/atmospherics/components/binary/volume_pump/other)
	. = ..()
	if(!istype(other))
		return
	other.transfer_rate = transfer_rate
	other.overclocked = overclocked

//Gas filter: Transfer rate, filtered gas
/obj/machinery/atmospherics/components/trinary/filter/can_blueprint_to()
	return ..() + /obj/machinery/atmospherics/components/trinary/filter

/obj/machinery/atmospherics/components/trinary/filter/blueprint_to(obj/machinery/atmospherics/components/trinary/filter/other)
	. = ..()
	if(!istype(other))
		return
	other.transfer_rate = transfer_rate
	other.filter_type = filter_type

//Gas mixer: Target pressure, Gas mix
/obj/machinery/atmospherics/components/trinary/mixer/can_blueprint_to()
	return ..() + /obj/machinery/atmospherics/components/trinary/mixer

/obj/machinery/atmospherics/components/trinary/mixer/blueprint_to(obj/machinery/atmospherics/components/trinary/mixer/other)
	. = ..()
	if(!istype(other))
		return
	other.target_pressure = target_pressure
	other.node1_concentration = node1_concentration
	other.node2_concentration = node2_concentration

//Injector: Transfer rate
/obj/machinery/atmospherics/components/unary/outlet_injector/can_blueprint_to()
	return ..() + /obj/machinery/atmospherics/components/unary/outlet_injector

/obj/machinery/atmospherics/components/unary/outlet_injector/blueprint_to(obj/machinery/atmospherics/components/unary/outlet_injector/other)
	. = ..()
	if(!istype(other))
		return
	other.volume_rate = volume_rate

//Freezer/heater: Temperature
/obj/machinery/atmospherics/components/unary/thermomachine/can_blueprint_to()
	return ..() + /obj/machinery/atmospherics/components/unary/thermomachine

/obj/machinery/atmospherics/components/unary/thermomachine/blueprint_to(obj/machinery/atmospherics/components/unary/thermomachine/other)
	. = ..()
	if(!istype(other))
		return
	other.target_temperature = clamp(target_temperature, other.min_temperature, other.max_temperature)

//Portable pump: On/off, direction, internal gas pump
/obj/machinery/portable_atmospherics/pump/can_blueprint_to()
	return ..() + /obj/machinery/portable_atmospherics/pump

/obj/machinery/portable_atmospherics/pump/blueprint_to(obj/machinery/portable_atmospherics/pump/other)
	. = ..()
	if(!istype(other))
		return
	other.on = on
	other.direction = direction
	pump.blueprint_to(other.pump)

//Portable scrubber: On/off, gas list
/obj/machinery/portable_atmospherics/scrubber/can_blueprint_to()
	return ..() + /obj/machinery/portable_atmospherics/scrubber

/obj/machinery/portable_atmospherics/scrubber/blueprint_to(obj/machinery/portable_atmospherics/scrubber/other)
	. = ..()
	if(!istype(other))
		return
	other.on = on
	other.scrubbing = scrubbing.Copy()

//Canister: Open valve, release pressure, name/desc/look (relabel)
/obj/machinery/portable_atmospherics/canister/can_blueprint_to()
	return ..() + /obj/machinery/portable_atmospherics/canister

/obj/machinery/portable_atmospherics/canister/blueprint_to(obj/machinery/portable_atmospherics/canister/other)
	. = ..()
	if(!istype(other))
		return
	other.valve_open = valve_open
	other.release_pressure = clamp(release_pressure, other.can_min_release_pressure, other.can_max_release_pressure)

	if(other.prototype == prototype)
		other.name = name
		other.desc = desc
		other.icon_state = icon_state
