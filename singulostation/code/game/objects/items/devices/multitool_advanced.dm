/obj/item/multitool/advanced
	name = "advanced multitool"
	desc = "Used for pulsing wires to test which to cut. This one can be switched between 6 buffers for device linkage."
	icon_state = "multitool" // Needs spriting
	custom_materials = list(/datum/material/iron=50, /datum/material/glass=30, /datum/material/gold=20, /datum/material/silver=20)
	usesound = 'sound/weapons/empty.ogg'
	var/list/buffer_list = list(null, null, null, null, null, null) // list of buffers that can be switched between
	var/buffer_index = 1

/obj/item/multitool/advanced/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The memory dial is turned to [buffer_index]</span>"

/obj/item/multitool/advanced/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/multitool/advanced/attack_self(mob/user)
	buffer_list[buffer_index] = buffer
	var/list/choices = list()
	var/list/choice_index_lookup = list()
	for(var/i = 1, i<=buffer_list.len, i++)
		var/obj/machinery/buffer_entry = buffer_list[i]
		var/name = null
		var/image = null

		if(istype(buffer_entry, /datum/dcm_net))
			var/datum/dcm_net/network = buffer_entry
			var/obj/machinery/machine = network.netHub
			name = "Deepcore Mining Network ([length(network.connected)] machines)"
			image = image(icon = machine.icon, icon_state = machine.icon_state)

		if(istype(buffer_entry))
			name = buffer_entry.name
			image = image(icon = buffer_entry.icon, icon_state = buffer_entry.icon_state)

		if(name == null)
			if(buffer_entry)
				name = buffer_entry
			else
				name = "Empty"

		var/label = "[num2text(i)]: [name]"
		choices[label] = image
		choice_index_lookup[label] = i

	var/choice = show_radial_menu(user, src, choices, custom_check = CALLBACK(src, .proc/check_menu, user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user))
		return
	
	var/index = choice_index_lookup[choice]
	if(index)
		buffer_index = index
		buffer = buffer_list[index]