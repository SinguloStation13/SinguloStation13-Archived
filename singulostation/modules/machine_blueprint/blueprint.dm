/obj/item/blueprint
	name = "machine blueprint"
	desc = "A blueprint used to remotely copy settings between machines."
	icon = 'singulostation/modules/machine_blueprint/blueprint.dmi' //Needs sprite
	icon_state = "blueprint_empty"

	var/obj/machinery/stored_machine = null

/obj/item/blueprint/pre_attack(obj/machinery/target, mob/user, params)
	if(!istype(target))
		return ..()

	. = TRUE

	if(stored_machine)
		if(!stored_machine.can_blueprint_to_check(target))
			to_chat(user, "<span class='warning'>The machine fails to load the data from the [name]</span>")
		else
			stored_machine.blueprint_to(target)
			to_chat("<span class='notice'>You copy the [name] data to the machine</span>")
	else
		if(length(target.can_blueprint_to()) == 0)
			to_chat(user, "<span class='warning'>The machine has no data that can be processed by the [name]</span>")
		else
			stored_machine = target
			to_chat("<span class='notice'>You store the [target] on the [name]</span>")

/obj/item/blueprint/examine(mob/user)
	. = ..()
	if(stored_machine)
		. += "<span class='notice'>It has [stored_machine] stored.</span>"

/obj/item/blueprint/AltClick(mob/user)
	..()

	if(stored_machine)
		stored_machine = null
		to_chat(user, "<span class='notice'>You clear the data from the [name]</span>")
