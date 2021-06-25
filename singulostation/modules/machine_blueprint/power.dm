//SMES: Charging rate, discharging rate, charging on/off, discharging on/off
/obj/machinery/power/smes/can_blueprint_to()
	return ..() + /obj/machinery/power/smes

/obj/machinery/power/smes/blueprint_to(obj/machinery/power/smes/other)
	. = ..()
	if(!istype(other))
		return
	other.input_level = clamp(input_level, 0, other.input_level_max)
	other.output_level = clamp(output_level, 0, other.output_level_max)
	other.input_attempt = input_attempt
	other.output_attempt = output_attempt

//Radiation collector: Power/science mode
/obj/machinery/power/rad_collector/can_blueprint_to()
	return ..() + /obj/machinery/power/rad_collector

/obj/machinery/power/rad_collector/blueprint_to(obj/machinery/power/rad_collector/other)
	. = ..()
	if(!istype(other))
		return
	other.bitcoinmining = bitcoinmining
