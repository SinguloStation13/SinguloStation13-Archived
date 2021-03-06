/**
Uplink Items
**/

/* Dangerous Weapons */
/datum/uplink_item/dangerous/weebstick
	name = "Nanoforged Katana"
	desc = "A tailor-made blade forged from one of the many ninja clans within the syndicate. \
			Merely weilding this weapon grants incredible agility."
	item = /obj/item/storage/belt/weebstick
	cost = 10
	surplus = 5
	limited_stock = 1

/*Stealthy Weapons*/
/datum/uplink_item/stealthy_weapons/derringerpack
	name = "Compact Derringer"
	desc = "An easily concealable handgun capable of firing .357 rounds. Comes in an inconspicuious packet of cigarettes with additional munitions."
	item = /obj/item/storage/fancy/cigarettes/derringer
	cost = 8
	surplus = 30
	surplus_nullcrates = 40

/datum/uplink_item/stealthy_weapons/derringerpack/purchase(mob/user, datum/component/uplink/U)
	if(prob(1)) //For the 1%
		item = /obj/item/storage/fancy/cigarettes/derringer/gold
	..()

/datum/uplink_item/stealthy_weapons/syndi_borer
	name = "Syndicate Brain Slug"
	desc = "A small cortical borer, modified to be completely loyal to the owner. \
			Genetically infertile, these brain slugs can assist medically in a support role, or take direct action \
			to assist their host."
	item = /obj/item/antag_spawner/syndi_borer
	refundable = TRUE
	cost = 10
	surplus = 20 //Let's not have this be too common
	exclude_modes = list(/datum/game_mode/nuclear)

/*Botany*/
/datum/uplink_item/role_restricted/lawnmower
	name = "Gas powered lawn mower"
	desc = "A lawn mower is a machine utilizing one or more revolving blades to cut a grass surface to an even height, or bodies if that's your thing"
	restricted_roles = list("Botanist")
	cost = 14
	item = /obj/vehicle/ridden/lawnmower/emagged

/*General Combat*/
/datum/uplink_item/device_tools/telecrystal/bonemedipen
	name = "C4L-Z1UM medipen"
	desc = "A medipen stocked with an agent that will help regenerate bones and organs. A single-use pocket Medbay visit."
	item = /obj/item/reagent_containers/hypospray/medipen/bonefixingjuice
	cost = 3

/*Role Restricted*/
/datum/uplink_item/role_restricted/greykingsword
	name = "Blade of The Grey Tide"
	desc = "A weapon of legend, forged by the greatest crackheads of our generation."
	item = /obj/item/melee/greykingsword
	cost = 2
	restricted_roles = list("Assistant", "Chemist")
