//Space heater: On/off, mode, target temperature
/obj/machinery/space_heater/can_blueprint_to()
	return ..() + /obj/machinery/space_heater

/obj/machinery/space_heater/blueprint_to(obj/machinery/space_heater/other)
	. = ..()
	if(!istype(other))
		return
	other.on = on
	other.setMode = setMode
	other.targetTemperature = clamp(target, max(other.settableTemperatureMedian - other.settableTemperatureRange, TCMB), other.settableTemperatureMedian + other.settableTemperatureRange) //This is exactly what the space heater code uses, and I don't want to mess with it