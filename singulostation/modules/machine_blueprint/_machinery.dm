//Contains procs that are used to copy settings from machine to machine using a blueprint

//Returns a list of types that can be copied to
/obj/machinery/proc/can_blueprint_to()
	return list()

//Checks if the blueprint can be applied to other machine
/obj/machinery/proc/can_blueprint_to_check(obj/machinery/other)
	for(var/type in can_blueprint_to())
		if(istype(other, type))
			return TRUE
	return FALSE

//Copies settings to other machine
/obj/machinery/proc/blueprint_to(obj/machinery/other)
	return
