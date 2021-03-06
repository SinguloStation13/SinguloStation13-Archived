/obj/structure/closet/secure_closet/brig_phys
	name = "\proper brig physician's locker"
	req_access = list(ACCESS_BRIG)
	icon_state = "brig_phys"

/obj/structure/closet/secure_closet/brig_phys/PopulateContents()
	..()
	new /obj/item/defibrillator/loaded(src)
	new /obj/item/radio/headset/headset_medsec(src)
	new	/obj/item/storage/firstaid/regular(src)
	new	/obj/item/storage/firstaid/fire(src)
	new	/obj/item/storage/firstaid/toxin(src)
	new	/obj/item/storage/firstaid/o2(src)
	new	/obj/item/storage/firstaid/brute(src)
	new /obj/item/storage/belt/medical(src)
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/clothing/gloves/color/latex/nitrile(src)
	new /obj/item/clothing/suit/toggle/labcoat/brig_phys(src)
	new /obj/item/clothing/suit/armor/vest/security/brig_phys(src)
	new /obj/item/clothing/head/beret/sec/brig_phys(src)

/obj/structure/closet/secure_closet/lieutenant
	name = "SolGov official's locker"
	req_access = list(ACCESS_SOLGOV)
	icon_state = "solgov"

/obj/structure/closet/secure_closet/lieutenant/PopulateContents()
	..()
	new /obj/item/clothing/head/beret/solgov(src)
	new /obj/item/storage/briefcase(src)
	new	/obj/item/storage/firstaid/regular(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/suit/armor/vest/solgov/rep(src)
	new /obj/item/clothing/suit/solgov_trenchcoat(src)
	new /obj/item/clothing/accessory/waistcoat/solgov(src)
	new /obj/item/clothing/shoes/laceup(src)
