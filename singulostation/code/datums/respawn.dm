GLOBAL_LIST_EMPTY(respawn_holders)
GLOBAL_VAR(respawn_cooldown)

/client
	var/datum/respawn_holder/respawn_timer

/datum/respawn_holder
	var/timerid
	var/ckey
	var/ready = FALSE

/datum/respawn_holder/New(var/mob/owner)
	timerid = addtimer(CALLBACK(src, .proc/fire), 30 SECONDS)
	ckey = owner.ckey
	if(owner.client)
		owner.client.respawn_timer = src
	GLOB.respawn_holders += src

/datum/respawn_holder/Destroy()
	for(var/client/C in GLOB.clients)
		if(C.ckey == ckey)
			C.respawn_timer = null
			continue
	GLOB.respawn_holders -= src

/datum/respawn_holder/proc/fire()
	ready = TRUE
	if (!CONFIG_GET(flag/norespawn))
		for(var/client/C in GLOB.clients)
			if(C.ckey == ckey)
				to_chat(C.mob, "<span class='ghostalert'>You can now respawn.</span>")
				SEND_SOUND(C, sound('sound/effects/adminhelp.ogg'))
				continue

/proc/find_respawn_holder(target_ckey)
	for(var/datum/respawn_holder/R in GLOB.respawn_holders)
		if(R.ckey == target_ckey)
			return R
