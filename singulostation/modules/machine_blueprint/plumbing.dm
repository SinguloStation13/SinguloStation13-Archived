//Synthesizer: Produced amount, chem type, visuals
/obj/machinery/plumbing/synthesizer/can_blueprint_to()
	return ..() + /obj/machinery/plumbing/synthesizer

/obj/machinery/plumbing/synthesizer/blueprint_to(obj/machinery/plumbing/synthesizer/other)
	. = ..()
	if(!istype(other))
		return
	other.amount = amount
	other.reagent_id = reagent_id
	other.update_icon()
	other.reagents.clear_reagents()

//Pill press: Produce type, amount, pill type, name
/obj/machinery/plumbing/pill_press/can_blueprint_to()
	return ..() + /obj/machinery/plumbing/pill_press

/obj/machinery/plumbing/pill_press/blueprint_to(obj/machinery/plumbing/pill_press/other)
	. = ..()
	if(!istype(other))
		return
	other.product = product
	other.max_volume = max_volume
	other.current_volume = current_volume
	other.pill_number = pill_number
	other.product_name = product_name

//Reaction chamber: Recipe
/obj/machinery/plumbing/reaction_chamber/can_blueprint_to()
	return ..() + /obj/machinery/plumbing/reaction_chamber

/obj/machinery/plumbing/reaction_chamber/blueprint_to(obj/machinery/plumbing/reaction_chamber/other)
	. = ..()
	if(!istype(other))
		return
	var/reagent
	for(reagent in other.required_reagents)
		other.required_reagents.Remove(reagent)
	for(reagent in required_reagents)
		other.required_reagents[reagent] = required_reagents[reagent]

//Acclimator: On/off, temperature, max temperature difference
/obj/machinery/plumbing/acclimator/can_blueprint_to()
	return ..() + /obj/machinery/plumbing/acclimator

/obj/machinery/plumbing/acclimator/blueprint_to(obj/machinery/plumbing/acclimator/other)
	. = ..()
	if(!istype(other))
		return
	other.enabled = enabled
	other.target_temperature = target_temperature
	other.allowed_temperature_difference = allowed_temperature_difference

//Filter: Left filter, right filter
/obj/machinery/plumbing/filter/can_blueprint_to()
	return ..() + /obj/machinery/plumbing/filter

/obj/machinery/plumbing/filter/blueprint_to(obj/machinery/plumbing/filter/other)
	. = ..()
	if(!istype(other))
		return
	other.left = left.Copy()
	other.right = right.Copy()
	other.english_left = english_left.Copy()
	other.english_right = english_right.Copy()

//Splitter: Split amounts
/obj/machinery/plumbing/splitter/can_blueprint_to()
	return ..() + /obj/machinery/plumbing/splitter

/obj/machinery/plumbing/splitter/blueprint_to(obj/machinery/plumbing/splitter/other)
	. = ..()
	if(!istype(other))
		return
	other.transfer_straight = transfer_straight
	other.transfer_side = transfer_side