/obj/structure/holosign/barrier/atmos
	var/timerid
	var/duration = 60 MINUTES

/obj/structure/holosign/barrier/atmos/Destroy()
	. = ..()
	deltimer(timerid)

/obj/structure/holosign/barrier/atmos/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The holofan will decay in [timeleft(timerid)/10] seconds.</span>"
