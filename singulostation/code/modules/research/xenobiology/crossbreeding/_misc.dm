/obj/item/cerulean_slime_crystal
	name = "Cerulean slime poly-crystal"
	desc = "Translucent and irregular, it can duplicate matter on a whim"
	icon = 'singulostation/icons/obj/slimecrossing.dmi'
	icon_state = "cerulean_item_crystal"
	var/amt = 0

/obj/item/cerulean_slime_crystal/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!istype(target,/obj/item/stack) || !istype(user,/mob/living/carbon) || !proximity_flag)
		return
	var/obj/item/stack/stack_item = target

	if(istype(stack_item,/obj/item/stack/telecrystal))
		var/mob/living/carbon/carbie = user
		to_chat(user,"<span class='big red'>You will pay for your hubris!</span>")
		carbie.gain_trauma(/datum/brain_trauma/special/beepsky,TRAUMA_RESILIENCE_ABSOLUTE)
		qdel(src)
		return
	
	var/amt_to_add = min(stack_item.max_amount - stack_item.get_amount(), amt)
	stack_item.add(amt_to_add)
	amt -= amt_to_add
	
	if(amt > 0)
		new target.type(get_turf(target), amt)
	
	qdel(src)
