/proc/respawn_fire(target_key)
	GLOB.respawn_queue[target_key] = null
	GLOB.respawn_ready[target_key] = TRUE
	if(!CONFIG_GET(flag/norespawn))
		for(var/client/C in GLOB.clients)
			if(C.key == target_key && C.mob.stat == DEAD)
				SEND_SOUND(C, sound('sound/effects/adminhelp.ogg'))
				to_chat(C.mob, "<span class='ghostalert'>You can now respawn.</span>")
				return
