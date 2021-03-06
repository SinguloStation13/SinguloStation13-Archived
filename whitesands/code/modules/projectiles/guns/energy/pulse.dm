/obj/item/gun/energy/pulse/terra
	name = "SolGov pulse rifle"
	desc = "An almost jury-rigged answer to NT's dominance on pulse weaponry. Features only 4 shots but can rapidly recharge."
	icon_state = "terrapulse"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse)
	internal_cell = TRUE //prevents you from giving it an OP cell - WS Edit
	cell_type = /obj/item/stock_parts/cell/gun/SolGov
	selfcharge = 1
	icon = 'whitesands/icons/obj/guns/energy.dmi'
	charge_delay = 0.5 //50 seconds to recharge the clip
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT
