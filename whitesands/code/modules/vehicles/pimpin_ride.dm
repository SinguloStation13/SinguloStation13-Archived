//Boomer-mobile Lawnmower

/obj/vehicle/ridden/lawnmower
	name = "lawn mower"
	desc = "Equipped with reliable safeties to prevent <i>accidents</i> in the workplace."
	icon = 'whitesands/icons/obj/vehicles.dmi'
	icon_state = "lawnmower"
	var/emagged = FALSE
	var/list/drive_sounds = list('whitesands/sound/effects/mowermove1.ogg', 'whitesands/sound/effects/mowermove2.ogg')
	var/list/gib_sounds = list('whitesands/sound/effects/mowermovesquish.ogg')
	var/driver

/obj/vehicle/ridden/lawnmower/Initialize()
	.= ..()
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.vehicle_move_delay = 2
	D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 4), TEXT_SOUTH = list(0, 7), TEXT_EAST = list(-5, 2), TEXT_WEST = list(5, 2)))

/obj/vehicle/ridden/lawnmower/emagged
	emagged = TRUE

/obj/vehicle/ridden/lawnmower/emag_act(mob/user)
	if(emagged)
		to_chat(user, "<span class='warning'>The safety mechanisms on \the [src] are already disabled!</span>")
		return
	to_chat(user, "<span class='warning'>You disable the safety mechanisms on \the [src].</span>")
	emagged = TRUE

/obj/vehicle/ridden/lawnmower/Bump(atom/A)
	. = ..()
	if(emagged)
		if(isliving(A))
			var/mob/living/M = A
			M.adjustBruteLoss(25)
			var/atom/newLoc = get_edge_target_turf(M, get_dir(src, get_step_away(M, src)))
			M.throw_at(newLoc, 4, 1)

/obj/vehicle/ridden/lawnmower/Move()
	. = ..()
	var/gibbed = FALSE
	var/gib_scream = FALSE
	var/mob/living/carbon/H

	if(has_buckled_mobs())
		H = buckled_mobs[1]
	else
		return .

	if(emagged)
		for(var/mob/living/carbon/human/M in loc)
			if(M == H)
				continue
			if(M.body_position == LYING_DOWN)
				visible_message("<span class='danger'>\the [src] grinds [M.name] into a fine paste!</span>")
				if (M.stat != DEAD)
					gib_scream = TRUE
				M.gib()
				shake_camera(M, 20, 1)
				gibbed = TRUE

	if(gibbed)
		shake_camera(H, 10, 1)
		if (gib_scream)
			playsound(loc, 'sound/voice/gib_scream.ogg', 100, 1, frequency = rand(11025*0.75, 11025*1.25))
		else
			playsound(loc, pick(gib_sounds), 75, 1)

	mow_lawn()

/obj/vehicle/ridden/lawnmower/proc/mow_lawn()
	//Nearly copypasted from goats
	var/mowed = FALSE
	var/obj/structure/spacevine/SV = locate(/obj/structure/spacevine) in loc
	if(SV)
		SV.eat(src)
		mowed = TRUE

	var/obj/structure/glowshroom/GS = locate(/obj/structure/glowshroom) in loc
	if(GS)
		qdel(GS)
		mowed = TRUE

	var/obj/structure/alien/weeds/AW = locate(/obj/structure/alien/weeds) in loc
	if(AW)
		qdel(AW)
		mowed = TRUE

	if(mowed)
		playsound(loc, pick(drive_sounds), 50, 1)
