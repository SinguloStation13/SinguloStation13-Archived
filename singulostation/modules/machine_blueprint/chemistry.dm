//Chem dispenser: Saved recipes
/obj/machinery/chem_dispenser/can_blueprint_to()
	return ..() + /obj/machinery/chem_dispenser

/obj/machinery/chem_dispenser/blueprint_to(obj/machinery/chem_dispenser/other)
	. = ..()
	if(!istype(other))
		return
	if(other.type != type) //No copying recipes between chem dispenser and soda dispenser
		return
	other.saved_recipes = saved_recipes.Copy()

//Smoke machine: On/off, range
/obj/machinery/smoke_machine/can_blueprint_to()
	return ..() + /obj/machinery/smoke_machine

/obj/machinery/smoke_machine/blueprint_to(obj/machinery/smoke_machine/other)
	. = ..()
	if(!istype(other))
		return
	other.on = on
	other.setting = min(setting, other.max_range)