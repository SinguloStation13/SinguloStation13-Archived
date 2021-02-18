/*
 * Cryogenic refrigeration unit.
 * Stealing a lot of concepts/code from sleepers due to massive laziness.
 * The despawn tick will only fire if it's been more than time_till_storage ticks
 * since time_entered, which is world.time when the occupant moves in.
 * ~ Zuhayr
 */

 //ORIGINAL FILE belonging to the WaspStation codebase. waspstation/code/game/machinery/cryopod.dm
 //Major alterations in cryopod.dm by SinguloStation13 prompting relocation

GLOBAL_LIST_EMPTY(cryopod_computers)

//Main cryopod console.

/obj/machinery/computer/cryopod
	name = "cryogenic oversight console"
	desc = "An interface for the cryogenic storage oversight systems."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole_1"
	circuit = /obj/item/circuitboard/cryopodcontrol
	density = FALSE
	interaction_flags_machine = INTERACT_MACHINE_OFFLINE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/mode = null

	//Used for logging people entering cryosleep.
	var/list/frozen_crew = list()
	//All cryopods linked to the oversight console
	var/list/cryopods = list()

	var/storage_type = "crewmembers"
	var/storage_name = "Cryogenic Oversight Control"
	var/allow_items = TRUE

/obj/machinery/computer/cryopod/Initialize()
	. = ..()
	GLOB.cryopod_computers += src
	//TODO: make this cleaner
	if(dir == NORTH)
		pixel_y = 32
	if(dir == SOUTH)
		pixel_y = -32
	if(dir == EAST)
		pixel_x = -32
	if(dir == WEST)
		pixel_x = 32

/obj/machinery/computer/cryopod/Destroy()
	GLOB.cryopod_computers -= src
	..()

/obj/machinery/computer/cryopod/process()
	if(machine_stat & (NOPOWER|BROKEN)) //Update icon_state to show no power because i don't know a better way to do it right now
		icon_state = "cellconsole"
	else
		icon_state = "cellconsole_1"

	//There will only be a few of these consoles so i think i can get away with checking the contents in process()
	for(var/mob/living/M in frozen_crew)
		if(M.loc != src) //Inhabitant somehow escaped the cryogenic freezer.
			M.forceMove(src) //Slap em back into the console pronto

	if (frozen_crew.len != 0) //Don't deconstruct terminals with people inside. Empty them to be able to deconstruct them.
		flags_1 |= NODECONSTRUCT_1
	else
		flags_1 &= ~NODECONSTRUCT_1

/obj/machinery/computer/cryopod/attack_ai()
	attack_hand()

/obj/machinery/computer/cryopod/attack_hand(mob/user = usr)
	if(machine_stat & (NOPOWER|BROKEN))
		return

	user.set_machine(src)
	add_fingerprint(user)

	var/dat

	dat += "<hr/><br/><b>[storage_name]</b><br/>"
	dat += "<i>Welcome, [user.real_name].</i><br/><br/><hr/>"
	dat += "<a href='?src=[REF(src)];view=1'>View cryogenic frozen lifeforms</a>.<br>"
	dat += "<a href='?src=[REF(src)];dispense=1'>Dispense cryogenic frozen lifeform</a>.<br>"

	user << browse(dat, "window=cryopod_console")
	onclose(user, "cryopod_console")

/obj/machinery/computer/cryopod/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr

	add_fingerprint(user)

	if(href_list["view"])

		var/dat = "<b>Currently stored lifeforms</b><br/><hr/><br/>"
		for(var/mob/living/L in frozen_crew)
			dat += "[L.name]<br/>"
		dat += "<hr/>"

		user << browse(dat, "window=cryocrew")

	else if(href_list["dispense"])
		if(frozen_crew.len == 0)
			to_chat(user, "<span class='notice'>There is noone to recover from storage.</span>")
			return

		var/mob/living/L = input(user, "Please choose which lifeform to retrieve.","Lifeform recovery",null) as null|anything in frozen_crew

		if(!L)
			return

		if(!(L in frozen_crew))
			to_chat(user, "<span class='notice'>\The [L] is no longer in storage.</span>")
			return

		visible_message("<span class='notice'>The console beeps happily as it routes \the [L] into a nearby cryopod.</span>")

		eject_from_storage(L)

	updateUsrDialog()
	return

/*Ejects the Mob specified in the parameter from the cryogenic console
 *First tries to find an available cryopod to insert the Mob into
 *If that fails, picks a random cryopod and awkwardly just teleports it onto it's turf
 *As a last resort, if no cryopods exist, eject onto the same turf as the cryopod console itself
 *Return is TRUE if successfully ejects, FALSE otherwise
 */
/obj/machinery/computer/cryopod/proc/eject_from_storage(mob/living/M)
	for (var/mob/living/O in frozen_crew) //We do another check just in case
		if (O == M) //We got our boy
			for(var/obj/machinery/cryopod/C in cryopods)
				if (!(C.occupant)) //Get a cryopod that is not occupied
					C.close_machine(O, TRUE)
					frozen_crew -= O
					return TRUE

			//Doing the deed quick and dirty, force eject onto a random cryopod's turf
			var/obj/machinery/cryopod/CR = pick(cryopods)
			if (CR) //We got ANY cryopod
				O.forceMove(get_turf(CR))
			else // There are no cryopods linked to the console
				O.forceMove(get_turf(src))
			O.remove_status_effect(STATUS_EFFECT_CRYOPROTECTION) //Backup statuseffect removal
			frozen_crew -= O
			return TRUE
	return FALSE

/obj/item/circuitboard/cryopodcontrol
	name = "Circuit board (Cryogenic Oversight Console)"
	build_path = /obj/machinery/computer/cryopod

//Cryopods themselves.
/obj/machinery/cryopod
	name = "cryogenic freezer"
	desc = "Suited for Cyborgs and Humanoids, the pod is a safe place for personnel affected by the Space Sleep Disorder to get some rest."
	icon = 'icons/obj/cryogenic2.dmi'
	icon_state = "cryopod-open"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE
	state_open = TRUE
	var/active = TRUE //Used to distinguish bodies entering and exiting the cryopod

	var/on_store_message = "has entered long-term storage."
	var/on_store_name = "Cryogenic Oversight"

	// 5 minutes-ish safe period before being despawned.
	var/time_till_storage = 5 * 600 // This is reduced to 30 seconds if a player manually enters cryo
	var/storage_world_time = null   // Used to keep track of the safe period.

	var/obj/machinery/computer/cryopod/control_computer
	var/last_no_computer_message = 0

	// These items will prevent the person going into cryo. Basically all high-value items as well as all teleportation/ target items.
	var/static/list/blacklisted_items = list(
		/obj/item/hand_tele,
		/obj/item/card/id/captains_spare,
		/obj/item/aicard,
		/obj/item/mmi,
		/obj/item/paicard,
		/obj/item/gun,
		/obj/item/pinpointer,
		/obj/item/clothing/shoes/magboots,
		/obj/item/areaeditor/blueprints,
		/obj/item/clothing/head/helmet/space,
		/obj/item/clothing/suit/space,
		/obj/item/clothing/suit/armor,
		/obj/item/defibrillator/compact,
		/obj/item/reagent_containers/hypospray/CMO,
		/obj/item/clothing/accessory/medal/gold/captain,
		/obj/item/clothing/gloves/krav_maga,
		/obj/item/nullrod,
		/obj/item/tank/jetpack,
		/obj/item/documents,
		/obj/item/nuke_core_container
	)
	// For stuff that is a subtype of a blacklisted item that is allowed to be taken into cryo.
	var/static/list/whitelisted_items = list (
		/obj/item/mmi/posibrain
	)

/obj/machinery/cryopod/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD //Gotta populate the cryopod computer GLOB first

/obj/machinery/cryopod/LateInitialize()
	update_icon()
	find_control_computer()

/obj/machinery/cryopod/proc/find_control_computer(urgent = 0)
	for(var/M in GLOB.cryopod_computers)
		var/obj/machinery/computer/cryopod/C = M
		if(get_area(C) == get_area(src))
			control_computer = C
			control_computer.cryopods += src
			break

	// Don't send messages unless we *need* the computer, and less than five minutes have passed since last time we messaged
	if(!control_computer && urgent && last_no_computer_message + 5*60*10 < world.time)
		log_admin("Cryopod in [get_area(src)] could not find control computer!")
		message_admins("Cryopod in [get_area(src)] could not find control computer!")
		last_no_computer_message = world.time

	return control_computer != null

/obj/machinery/cryopod/JoinPlayerHere(mob/M, buckle)
	if(icon_state == "cryopod-open") //Don't stack people inside cryopods
		close_machine(M, TRUE)
	else
		M.forceMove(get_turf(src))

/obj/machinery/cryopod/latejoin/Initialize()
	. = ..()
	new /obj/effect/landmark/latejoin(src)

/obj/machinery/cryopod/close_machine(mob/user, exiting = FALSE)
	active = TRUE
	if(!control_computer)
		find_control_computer(TRUE)
	if((isnull(user) || istype(user)) && state_open && !panel_open)
		..(user)
		if(exiting && istype(user, /mob/living/carbon))
			active = FALSE
			var/mob/living/carbon/C = user
			C.remove_status_effect(STATUS_EFFECT_CRYOPROTECTION)
			icon_state = "cryopod"
			say("Cryogenic revival of [user.real_name] successful. Have a pleasant and productive day!")
			return
		var/mob/living/mob_occupant = occupant
		if(mob_occupant && mob_occupant.stat != DEAD)
			to_chat(occupant, "<span class='boldnotice'>You feel cool air surround you. You go numb as your senses turn inward.</span>")
		if(mob_occupant.client)//if they're logged in
			storage_world_time = world.time + (time_till_storage * 0.1) // This gives them 30 seconds
		else
			storage_world_time = world.time + time_till_storage
	icon_state = "cryopod"

/obj/machinery/cryopod/open_machine()
	..()
	icon_state = "cryopod-open"
	density = TRUE
	name = initial(name)

/obj/machinery/cryopod/container_resist_act(mob/living/user)
	visible_message("<span class='notice'>[occupant] emerges from [src]!</span>",
		"<span class='notice'>You climb out of [src]!</span>")
	open_machine()

/obj/machinery/cryopod/relaymove(mob/user)
	container_resist_act(user)

/obj/machinery/cryopod/process()
	if(!occupant)
		return

	if (!active) //Person is exiting cryostorage
		return

	var/mob/living/mob_occupant = occupant
	if(mob_occupant)
		// Eject dead people
		if(mob_occupant.stat == DEAD)
			open_machine()

		if(!(world.time > storage_world_time))
			return

		if(mob_occupant.stat <= 2) //Occupant is living and has no client.
			if(!control_computer)
				find_control_computer(urgent = TRUE)//better hope you found it this time
				if(!control_computer)
					say("Unable to find control computer for safe cryogenic storage handling! Contact Central Command if this issue persists!")
					storage_world_time = world.time + 30 SECONDS // 30 seconds cooldown until next test

			if (is_clean())
				store_occupant()
			else
				storage_world_time = world.time + 30 SECONDS

//Compares all contents of the mob being moved to cryo against blacklisted_items and whitelisted_items.
//If a blacklisted item is within the mob, return TRUE, otherwise FALSE
/obj/machinery/cryopod/proc/has_blacklisted_items()
	var/mob/living/mob_occupant = occupant
	var/list/bad_items = list()
	var/plural_items = "item"
	var/skip = FALSE //If item is in whitelisted_items
	for(var/obj/item/T in mob_occupant.GetAllContents())
		for(var/B in blacklisted_items) //No nasty items in my cryo storage
			if(istype(T, B))
				for(var/W in whitelisted_items) //Yes nasty items in my cryo storage
					if(istype(T, W))
						skip = TRUE //If it's in the whitelisted_items then it may pass
						break //Item redeemed itself
				if(!skip) //If item is in blacklisted_items but not in whitelisted_items
					bad_items += T.name //Log all illegal items

	if(bad_items.len > 0)
		if (bad_items.len > 1)
			plural_items = "items" //Please make this more pretty
		say("Illegal [plural_items] found within occupant. Please remove the following [plural_items]:")
		for (var/S in bad_items) //List all of the items on the naughty list
			say ("Illegal item: [S]")
		return TRUE //Occupant has blacklisted items
	else
		return FALSE //Occupant is clean of blacklisted items

// Checks if the occupant is clean items and stats wise
// Checks for nanites, race specific stuff and other shenanigans to pull them out of cryo forcefully.
/obj/machinery/cryopod/proc/is_clean()
	if(has_blacklisted_items())
		return FALSE
	//Todo:
	//Check for implants, nanites, luminescent bluespace ability, quantum trauma, etc.
	return TRUE

//Puts the occupant into storage
/obj/machinery/cryopod/proc/store_occupant()
	var/mob/living/mob_occupant = occupant
	var/announce_rank = null

	for(var/datum/data/record/G in GLOB.data_core.general)
		if((G.fields["name"] == mob_occupant.real_name))
			announce_rank = G.fields["rank"]

	//Make an announcement and log the person entering storage.
	if(control_computer)
		control_computer.frozen_crew += mob_occupant
		mob_occupant.forceMove(control_computer)

	if(GLOB.announcement_systems.len)
		var/obj/machinery/announcement_system/announcer = pick(GLOB.announcement_systems)
		announcer.announce("CRYOSTORAGE", mob_occupant.real_name, announce_rank, list())
		visible_message("<span class='notice'>\The [src] hums and hisses as it moves [mob_occupant.real_name] into storage.</span>")

	mob_occupant.apply_status_effect(STATUS_EFFECT_CRYOPROTECTION)// Gives them godmode
	open_machine()

/obj/machinery/cryopod/attack_hand(mob/living/user)
	open_machine() //Open the cryopod to get SSD people out of it


/obj/machinery/cryopod/MouseDrop_T(mob/living/target, mob/user)
	if(!istype(target) || user.incapacitated() || !target.Adjacent(user) || !Adjacent(user) || !ismob(target) || (!ishuman(user) && !iscyborg(user)) || !istype(user.loc, /turf) || target.buckled)
		return

	if(occupant)
		to_chat(user, "<span class='boldnotice'>The cryo pod is already occupied!</span>")
		return

	if(target.stat == DEAD)
		to_chat(user, "<span class='notice'>Dead people can not be put into cryo.</span>")
		return

	if(target.client && user != target)
		if(iscyborg(target))
			to_chat(user, "<span class='danger'>You can't put [target] into [src]. They're online.</span>")
		else
			to_chat(user, "<span class='danger'>You can't put [target] into [src]. They're conscious.</span>")
		return

	else if(target.client)
		if(tgui_alert(target, "Would you like to enter cryosleep?", "Cryopod", list("Yes","No")) != "Yes")
			return

	if(!target || user.incapacitated() || !target.Adjacent(user) || !Adjacent(user) || (!ishuman(user) && !iscyborg(user)) || !istype(user.loc, /turf) || target.buckled)
		return
		//rerun the checks in case of shenanigans

	if(target == user)
		visible_message("[user] starts climbing into the cryo pod.")
	else
		visible_message("[user] starts putting [target] into the cryo pod.")

	if(occupant)
		to_chat(user, "<span class='boldnotice'>\The [src] is in use.</span>")
		return
	close_machine(target)

	to_chat(target, "<span class='boldnotice'>Your character will be put into cryo storage in a short amount of time. To get out of storage on your own, click the cryo status alert</span>")
	name = "[name] ([occupant.name])"
	log_admin("<span class='notice'>[key_name(target)] entered a stasis pod.</span>")
	message_admins("[key_name_admin(target)] entered a stasis pod. (<A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
	add_fingerprint(target)

//Attacks/effects.
/obj/machinery/cryopod/blob_act()
	return //Sorta gamey, but we don't really want these to be destroyed.
