/obj/machinery/computer/helm
	name = "helm control console"
	desc = "Used to view or control the ship."
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	circuit = /obj/item/circuitboard/computer/shuttle/helm
	light_color = LIGHT_COLOR_FLARE

	///The ship
	var/obj/structure/overmap/current_ship
	var/list/concurrent_users = list()
	///Is this for viewing only?
	var/viewer = FALSE
	///The overmap object/shuttle ID
	var/id

/obj/machinery/computer/helm/Initialize(mapload)
	. = ..()
	LAZYADD(SSovermap.helms, src)
	if(!mapload)
		set_ship()

/obj/machinery/computer/helm/proc/set_ship(_id)
	if(_id)
		id = _id
	if(!id)
		var/obj/docking_port/mobile/port = SSshuttle.get_containing_shuttle(src)
		var/area/A = get_area(src)
		if(port)
			if(port.current_ship)
				current_ship = port.current_ship
				return
			id = port.id
		else if(is_station_level(z) && !A?.outdoors)
			id = MAIN_OVERMAP_OBJECT_ID
		else
			return FALSE
	current_ship = SSovermap.get_overmap_object_by_id(id)

/obj/machinery/computer/helm/Destroy()
	. = ..()
	LAZYREMOVE(SSovermap.helms, src)

/obj/machinery/computer/helm/ui_interact(mob/user, datum/tgui/ui)
	// Update UI
	if(!current_ship)
		set_ship()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		var/user_ref = REF(user)
		var/is_living = isliving(user)
		// Ghosts shouldn't count towards concurrent users, which produces
		// an audible terminal_on click.
		if(is_living)
			concurrent_users += user_ref
		// Turn on the console
		if(length(concurrent_users) == 1 && is_living)
			playsound(src, 'sound/machines/terminal_on.ogg', 25, FALSE)
			use_power(active_power_usage)
		// Register map objects
		if(current_ship)
			user.client.register_map_obj(current_ship.cam_screen)
			user.client.register_map_obj(current_ship.cam_plane_master)
			user.client.register_map_obj(current_ship.cam_background)
			current_ship.update_screen()

		// Open UI
		ui = new(user, src, "HelmConsole", name)
		ui.open()

/obj/machinery/computer/helm/ui_data(mob/user)
	. = list()
	.["shipInfo"] = list(
		name = current_ship.name,
		class = istype(current_ship, /obj/structure/overmap/ship) ? "Ship" : istype(current_ship, /obj/structure/overmap/level) ? "Planetoid" : "Station",
		integrity = current_ship.integrity,
		sensor_range = current_ship.sensor_range,
		ref = REF(current_ship)
	)
	.["otherInfo"] = list()
	for (var/object in current_ship.close_overmap_objects)
		var/obj/structure/overmap/O = object
		var/list/other_data = list(
			name = O.name,
			integrity = O.integrity,
			ref = REF(O)
		)
		.["otherInfo"] += list(other_data)

	if(istype(current_ship.loc, /obj/structure/overmap))
		.["x"] = current_ship.loc.x
		.["y"] = current_ship.loc.y
	else
		.["x"] = current_ship.x
		.["y"] = current_ship.y

	if(!istype(current_ship, /obj/structure/overmap/ship/simulated))
		return

	var/obj/structure/overmap/ship/simulated/S = current_ship

	.["canFly"] = TRUE
	.["state"] = S.state
	.["docked"] = S.docked ? TRUE : FALSE
	.["heading"] = dir2angle(S.get_heading()) || 0
	.["speed"] = S.get_speed()
	.["maxSpeed"] = S.max_speed
	.["eta"] = S.get_eta()
	.["stopped"] = S.is_still()
	.["shipInfo"] += list(
		mass = S.mass,
		est_thrust = S.est_thrust
	)
	.["engineInfo"] = list()
	for(var/obj/machinery/power/shuttle/engine/E in S.shuttle.engine_list)
		var/list/engine_data
		if(!E.thruster_active)
			engine_data = list(
				name = E.name,
				fuel = 0,
				maxFuel = 100,
				enabled = E.enabled,
				ref = REF(E)
			)
		else
			engine_data = list(
				name = E.name,
				fuel = E.return_fuel(),
				maxFuel = E.return_fuel_cap(),
				enabled = E.enabled,
				ref = REF(E)
			)
		.["engineInfo"] += list(engine_data)

/obj/machinery/computer/helm/ui_static_data(mob/user)
	. = list()
	.["isViewer"] = viewer
	.["mapRef"] = current_ship.map_name

/obj/machinery/computer/helm/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(viewer)
		return
	if(!istype(current_ship, /obj/structure/overmap/ship/simulated))
		return

	var/obj/structure/overmap/ship/simulated/S = current_ship
	switch(action)
		if("act_overmap")
			var/obj/structure/overmap/to_act = locate(params["ship_to_act"])
			say(S.overmap_object_act(usr, to_act))
		if("undock")
			S.calculate_avg_fuel()
			if(S.avg_fuel_amnt < 25 && tgui_alert(usr, "Ship only has ~[round(S.avg_fuel_amnt)]% fuel remaining! Are you sure you want to undock?", name, list("Yes", "No")) != "Yes")
				return
			say(S.undock())
		if("reload_ship")
			set_ship()
		if("reload_engines")
			S.refresh_engines()
		if("toggle_engine")
			var/obj/machinery/power/shuttle/engine/E = locate(params["engine"])
			E.enabled = !E.enabled
			S.refresh_engines()
		if("change_heading")
			S.burn_engines(text2num(params["dir"]))
		if("stop")
			S.burn_engines()

/obj/machinery/computer/helm/ui_close(mob/user)
	var/user_ref = REF(user)
	var/is_living = isliving(user)
	// Living creature or not, we remove you anyway.
	concurrent_users -= user_ref
	// Unregister map objects
	if(current_ship)
		user.client.clear_map(current_ship.map_name)
	// Turn off the console
	if(length(concurrent_users) == 0 && is_living)
		playsound(src, 'sound/machines/terminal_off.ogg', 25, FALSE)
		use_power(0)

/obj/machinery/computer/helm/viewscreen
	name = "ship viewscreen"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "telescreen"
	layer = SIGN_LAYER
	density = FALSE
	viewer = TRUE
