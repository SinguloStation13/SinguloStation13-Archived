//This is the proc for gibbing a mob. Cannot gib ghosts.
//added different sort of gibs and animations. N
/mob/proc/gib()
	return

//This is the proc for turning a mob into ash. Mostly a copy of gib code (above).
//Originally created for wizard disintegrate. I've removed the virus code since it's irrelevant here.
//Dusting robots does not eject the MMI, so it's a bit more powerful than gib() /N
/mob/proc/dust(just_ash, drop_items, force)
	return

/mob/proc/death(gibbed)
	SEND_SIGNAL(src, COMSIG_MOB_DEATH, gibbed)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MOB_DEATH, src , gibbed)
	GLOB.respawn_ready[key] = FALSE
	if(GLOB.respawn_queue[key])
		deltimer(GLOB.respawn_queue[key])
	GLOB.respawn_queue[key] = addtimer(CALLBACK(null, .proc/respawn_fire, key), CONFIG_GET(number/respawntime), TIMER_STOPPABLE)
