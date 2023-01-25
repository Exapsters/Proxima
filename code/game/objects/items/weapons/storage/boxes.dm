/*
 *	Everything derived from the common cardboard box.
 *	Basically everything except the original is a kit (starts full).
 *
 *	Contains:
 *		Empty box, starter boxes (survival/engineer),
 *		Latex glove and sterile mask boxes,
 *		Syringe, beaker, dna injector boxes,
 *		Blanks, flashbangs, and EMP grenade boxes,
 *		Tracking and chemical implant boxes,
 *		Prescription glasses and drinking glass boxes,
 *		Condiment bottle and silly cup boxes,
 *		Donkpocket and monkeycube boxes,
 *		ID and security PDA cart boxes,
 *		Handcuff, mousetrap, and pillbottle boxes,
 *		Snap-pops and matchboxes,
 *		Replacement light boxes.
 *
 *		For syndicate call-ins see uplink_kits.dm
 */

/obj/item/storage/box
	name = "box"
	desc = "It's just an ordinary box."
	icon_state = "box"
	item_state = "syringe_kit"
	max_storage_space = DEFAULT_BOX_STORAGE
	use_sound = 'sound/effects/storage/box.ogg'
	var/foldable = /obj/item/stack/material/cardboard	// BubbleWrap - if set, can be folded (when empty) into a sheet of cardboard
	allow_slow_dump = TRUE

/obj/item/storage/box/large
	name = "large box"
	icon_state = "largebox"
	w_class = ITEM_SIZE_LARGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE

/obj/item/storage/box/union_cards
	name = "box of union cards"
	desc = "A box of spare unsigned union membership cards."
	startswith = list(/obj/item/card/union = 7)

/obj/item/storage/box/large/union_cards
	name = "large box of union cards"
	desc = "A large box of spare unsigned union membership cards."
	startswith = list(/obj/item/card/union = 14)

// BubbleWrap - A box can be folded up to make card
/obj/item/storage/box/attack_self(mob/user as mob)
	if(..()) return

	//try to fold it.
	if ( contents.len )
		return

	if ( !ispath(src.foldable) )
		return
	var/found = 0
	// Close any open UI windows first
	for(var/mob/M in range(1))
		if (M.s_active == src)
			src.close(M)
		if ( M == user )
			found = 1
	if ( !found )	// User is too far away
		return
	// Now make the cardboard
	to_chat(user, "<span class='notice'>You fold [src] flat.</span>")
	if(ispath(foldable, /obj/item/stack))
		var/stack_amt = max(2**(w_class - 3), 1)
		new src.foldable(get_turf(src), stack_amt)
	else
		new src.foldable(get_turf(src))
	qdel(src)

/obj/item/storage/box/make_exact_fit()
	..()
	foldable = null //special form fitted boxes should not be foldable.

/obj/item/storage/box/survival
	name = "crew survival kit"
	desc = "A box decorated in warning colors that contains a limited supply of survival tools. The panel and white stripe indicate this one contains oxygen."
	icon_state = "survival"
	startswith = list(/obj/item/clothing/mask/breath/scba = 1,
					/obj/item/tank/oxygen_emergency = 1,
					/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline = 1,
					/obj/item/stack/medical/bruise_pack = 1,
					/obj/item/device/flashlight/flare/glowstick = 1,
					/obj/item/reagent_containers/food/snacks/proteinbar = 1,
					/obj/item/device/oxycandle = 1)

/obj/item/storage/box/vox
	name = "vox survival kit"
	desc = "A box decorated in warning colors that contains a limited supply of survival tools. The panel and black stripe indicate this one contains nitrogen."
	icon_state = "survivalvox"
	startswith = list(/obj/item/clothing/mask/breath = 1,
					/obj/item/tank/nitrogen_emergency = 1,
					/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline = 1,
					/obj/item/stack/medical/bruise_pack = 1,
					/obj/item/device/flashlight/flare/glowstick = 1,
					/obj/item/reagent_containers/food/snacks/proteinbar = 1)

/obj/item/storage/box/engineer
	name = "engineer survival kit"
	desc = "A box decorated in warning colors that contains a limited supply of survival tools. The panel and orange stripe indicate this one as the engineering variant."
	icon_state = "survivaleng"
	startswith = list(/obj/item/clothing/mask/breath/scba = 1,
					/obj/item/tank/oxygen_emergency_extended = 1,
					/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline = 1,
					/obj/item/reagent_containers/hypospray/autoinjector/antirad = 1,
					/obj/item/stack/medical/bruise_pack = 1,
					/obj/item/device/flashlight/flare/glowstick = 1,
					/obj/item/reagent_containers/food/snacks/proteinbar = 1,
					/obj/item/device/oxycandle = 1)

/obj/item/storage/box/gloves
	name = "box of sterile gloves"
	desc = "Contains sterile gloves."
	icon_state = "latex"
	startswith = list(/obj/item/clothing/gloves/latex = 6,
					/obj/item/clothing/gloves/latex/nitrile = 2)

/obj/item/storage/box/masks
	name = "box of sterile masks"
	desc = "This box contains masks of sterility."
	icon_state = "sterile"
	startswith = list(/obj/item/clothing/mask/surgical = 7)


/obj/item/storage/box/syringes
	name = "box of syringes"
	desc = "A box full of syringes."
	icon_state = "syringe"
	startswith = list(/obj/item/reagent_containers/syringe = 7)

/obj/item/storage/box/syringegun
	name = "box of syringe gun cartridges"
	desc = "A box full of compressed gas cartridges."
	icon_state = "syringe"
	startswith = list(/obj/item/syringe_cartridge = 7)


/obj/item/storage/box/beakers
	name = "box of beakers"
	icon_state = "beaker"
	startswith = list(/obj/item/reagent_containers/glass/beaker = 7)

/obj/item/storage/box/beakers/insulated
	name = "box of insulated beakers"
	startswith = list(/obj/item/reagent_containers/glass/beaker/insulated = 7)

/obj/item/storage/box/ammo
	name = "ammo box"
	icon_state = "ammo"
	desc = "A sturdy metal box with several warning symbols on the front.<br>WARNING: Live ammunition. Misuse may result in serious injury or death."
	use_sound = 'sound/effects/closet_open.ogg'

/obj/item/storage/box/ammo/blanks
	name = "box of blank shells"
	desc = "It has a picture of a gun and several warning symbols on the front."
	startswith = list(/obj/item/ammo_casing/shotgun/blank = 8)

/obj/item/storage/box/ammo/practiceshells
	name = "box of practice shells"
	startswith = list(/obj/item/ammo_casing/shotgun/practice = 8)

/obj/item/storage/box/ammo/beanbags
	name = "box of beanbag shells"
	startswith = list(/obj/item/ammo_magazine/shotholder/beanbag = 2)

/obj/item/storage/box/ammo/shotgunammo
	name = "box of shotgun slugs"
	startswith = list(/obj/item/ammo_magazine/shotholder = 2)

/obj/item/storage/box/ammo/shotgunshells
	name = "box of shotgun shells"
	startswith = list(/obj/item/ammo_magazine/shotholder/shell = 2)

/obj/item/storage/box/ammo/flechetteshells
	name = "box of flechette shells"
	startswith = list(/obj/item/ammo_magazine/shotholder/flechette = 2)

/obj/item/storage/box/ammo/flashshells
	name = "box of illumination shells"
	startswith = list(/obj/item/ammo_magazine/shotholder/flash = 2)

/obj/item/storage/box/ammo/stunshells
	name = "box of stun shells"
	startswith = list(/obj/item/ammo_magazine/shotholder/stun = 2)

/obj/item/storage/box/ammo/sniperammo
	name = "box of sniper shells"
	startswith = list(/obj/item/ammo_casing/shell = 7)

/obj/item/storage/box/ammo/sniperammo/apds
	name = "box of sniper APDS shells"
	startswith = list(/obj/item/ammo_casing/shell/apds = 3)
/obj/item/storage/box/flashbangs
	name = "box of flashbangs"
	desc = "A box containing 7 antipersonnel flashbang grenades.<br> WARNING: These devices are extremely dangerous and can cause blindness or deafness from repeated use."
	icon_state = "flashbang"
	startswith = list(/obj/item/grenade/flashbang = 7)

/obj/item/storage/box/teargas
	name = "box of pepperspray grenades"
	desc = "A box containing 7 tear gas grenades. A gas mask is printed on the label.<br> WARNING: Exposure carries risk of serious injury or death. Keep away from persons with lung conditions."
	icon_state = "flashbang"
	startswith = list(/obj/item/grenade/chem_grenade/teargas = 7)

/obj/item/storage/box/emps
	name = "box of emp grenades"
	desc = "A box containing 5 military grade EMP grenades.<br> WARNING: Do not use near unshielded electronics or biomechanical augmentations, death or permanent paralysis may occur."
	icon_state = "flashbang"
	startswith = list(/obj/item/grenade/empgrenade = 5)

/obj/item/storage/box/frags
	name = "box of frag grenades"
	desc = "A box containing 5 military grade fragmentation grenades.<br> WARNING: Live explosives. Misuse may result in serious injury or death."
	icon_state = "flashbang"
	startswith = list(/obj/item/grenade/frag = 5)

/obj/item/storage/box/fragshells
	name = "box of frag shells"
	desc = "A box containing 5 military grade fragmentation shells.<br> WARNING: Live explosive munitions. Misuse may result in serious injury or death."
	icon_state = "flashbang"
	startswith = list(/obj/item/grenade/frag/shell = 5)

/obj/item/storage/box/smokes
	name = "box of smoke bombs"
	desc = "A box containing 5 smoke bombs."
	icon_state = "flashbang"
	startswith = list(/obj/item/grenade/smokebomb = 5)

/obj/item/storage/box/anti_photons
	name = "box of anti-photon grenades"
	desc = "A box containing 5 experimental photon disruption grenades."
	icon_state = "flashbang"
	startswith = list(/obj/item/grenade/anti_photon = 5)

/obj/item/storage/box/supermatters
	name = "box of supermatter grenades"
	desc = "A box containing 5 highly experimental supermatter grenades."
	icon_state = "radbox"
	startswith = list(/obj/item/grenade/supermatter = 5)

/obj/item/storage/box/hypercharged_guncells
	name = "box of hypercharged cells"
	desc = "A box containing 6 higly unstable hypercharged guncells. Both ammunition and a improvised grenade."
	icon_state = "flashbang"
	startswith = list(	/obj/item/cell/guncell/overcharged/large = 3,
						/obj/item/cell/guncell/pistol/overcharged/large = 3)

/obj/item/storage/box/trackimp
	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	icon_state = "implant"
	startswith = list(/obj/item/implantcase/tracking = 4,
		/obj/item/implanter = 1,
		/obj/item/implantpad = 1,
		/obj/item/locator = 1)

/obj/item/storage/box/chemimp
	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	icon_state = "implant"
	startswith = list(/obj/item/implantcase/chem = 5,
					/obj/item/implanter = 1,
					/obj/item/implantpad = 1)

/obj/item/storage/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	icon_state = "glasses"
	startswith = list(/obj/item/clothing/glasses/prescription = 7)

/obj/item/storage/box/cdeathalarm_kit
	name = "death alarm kit"
	desc = "Box of stuff used to implant death alarms."
	icon_state = "implant"
	item_state = "syringe_kit"
	startswith = list(/obj/item/implanter = 1,
				/obj/item/implantcase/death_alarm = 6)

/obj/item/storage/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."
	startswith = list(/obj/item/reagent_containers/food/condiment = 6)

/obj/item/storage/box/cups
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."
	startswith = list(/obj/item/reagent_containers/food/drinks/sillycup = 7)

//cubed animals

/obj/item/storage/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/food.dmi'
	icon_state = "monkeycubebox"
	can_hold = list(/obj/item/reagent_containers/food/snacks/monkeycube)
	startswith = list(/obj/item/reagent_containers/food/snacks/monkeycube/wrapped = 5)

/obj/item/storage/box/monkeycubes/farwacubes
	name = "farwa cube box"
	desc = "Drymate brand farwa cubes, shipped from Nyx. Just add water!"
	startswith = list(/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube = 5)

/obj/item/storage/box/monkeycubes/stokcubes
	name = "stok cube box"
	desc = "Drymate brand stok cubes, shipped from Moghes. Just add water!"
	startswith = list(/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/stokcube = 5)

/obj/item/storage/box/monkeycubes/neaeracubes
	name = "neaera cube box"
	desc = "Drymate brand neaera cubes, shipped from Jargon 4. Just add water!"
	startswith = list(/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube = 5)

/obj/item/storage/box/monkeycubes/spidercubes
	name = "spiderling cube box"
	desc = "Drymate brand Instant spiders. WHY WOULD YOU ORDER THIS!?"
	startswith = list(/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/spidercube = 5)

/obj/item/storage/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "id"
	startswith = list(/obj/item/card/id = 7)

/obj/item/storage/box/large/ids
	name = "box of spare IDs"
	desc = "Has so, so many empty IDs."
	icon_state = "id_large"
	startswith = list(/obj/item/card/id = 14)

/obj/item/storage/box/handcuffs
	name = "box of spare handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"
	startswith = list(/obj/item/handcuffs = 7)

/obj/item/storage/box/mousetraps
	name = "box of Pest-B-Gon mousetraps"
	desc = "<B><FONT color='red'>WARNING:</FONT></B> <I>Keep out of reach of children</I>."
	icon_state = "mousetraps"
	startswith = list(/obj/item/device/assembly/mousetrap = 6)

/obj/item/storage/box/mousetraps/empty
	startswith = null

/obj/item/storage/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."
	startswith = list(/obj/item/storage/pill_bottle = 7)

/obj/item/storage/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/toy.dmi'
	icon_state = "spbox"
	can_hold = list(/obj/item/toy/snappop)
	startswith = list(/obj/item/toy/snappop = 8)

/obj/item/storage/box/matches
	name = "matchbox"
	desc = "A small box of 'Space-Proof' premium matches."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_BELT
	can_hold = list(/obj/item/flame/match)
	startswith = list(/obj/item/flame/match = 10)

/obj/item/storage/box/matches/attackby(obj/item/flame/match/W as obj, mob/user as mob)
	if(istype(W) && !W.lit && !W.burnt)
		W.lit = 1
		W.damtype = INJURY_TYPE_BURN
		W.icon_state = "match_lit"
		START_PROCESSING(SSobj, W)
		playsound(src.loc, 'sound/items/match.ogg', 60, 1, -4)
		user.visible_message("<span class='notice'>[user] strikes the match on the matchbox.</span>")
	W.update_icon()
	return

/obj/item/storage/box/autoinjectors
	name = "box of injectors"
	desc = "Contains autoinjectors."
	icon_state = "syringe"

	startswith = list(/obj/item/reagent_containers/hypospray/autoinjector = 7)

/obj/item/storage/box/lights
	name = "box of replacement bulbs"
	icon = 'icons/obj/storage.dmi'
	icon_state = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	item_state = "syringe_kit"
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try

/obj/item/storage/box/lights/Initialize()
	. = ..()
	make_exact_fit()

/obj/item/storage/box/lights/bulbs
	startswith = list(/obj/item/light/bulb = 21)

/obj/item/storage/box/lights/bulbs/empty
	startswith = null

/obj/item/storage/box/lights/tubes
	name = "box of replacement tubes"
	icon_state = "lighttube"
	startswith = list(/obj/item/light/tube = 17,
					/obj/item/light/tube/large = 4)

/obj/item/storage/box/lights/tubes/random
	name = "box of replacement tubes -- party pack"
	icon_state = "lighttube"
	startswith = list(/obj/item/light/tube/party = 17,
					/obj/item/light/tube/large/party = 4)

/obj/item/storage/box/lights/tubes/empty
	startswith = null

/obj/item/storage/box/lights/mixed
	name = "box of replacement lights"
	icon_state = "lightmixed"
	startswith = list(/obj/item/light/tube = 12,
					/obj/item/light/tube/large = 4,
					/obj/item/light/bulb = 5)

/obj/item/storage/box/lights/mixed/empty
	startswith = null

/obj/item/storage/box/glowsticks
	name = "box of mixed glowsticks"
	icon_state = "box"
	startswith = list(/obj/item/device/flashlight/flare/glowstick = 1, /obj/item/device/flashlight/flare/glowstick/red = 1,
					/obj/item/device/flashlight/flare/glowstick/blue = 1, /obj/item/device/flashlight/flare/glowstick/orange = 1,
					/obj/item/device/flashlight/flare/glowstick/yellow = 1, /obj/item/device/flashlight/flare/glowstick/random = 1)

/obj/item/storage/box/greenglowsticks
	name = "box of green glowsticks"
	icon_state = "box"
	startswith = list(/obj/item/device/flashlight/flare/glowstick = 6)

/obj/item/storage/box/freezer
	name = "portable freezer"
	desc = "This nifty shock-resistant device will keep your 'groceries' nice and non-spoiled."
	icon = 'icons/obj/storage.dmi'
	icon_state = "portafreezer"
	item_state = "medicalpack"
	foldable = null
	max_w_class = ITEM_SIZE_NORMAL
	w_class = ITEM_SIZE_LARGE
	can_hold = list(/obj/item/organ, /obj/item/reagent_containers/food, /obj/item/reagent_containers/glass)
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	use_to_pickup = 1 // for picking up broken bulbs, not that most people will try
	temperature = -16 CELSIUS

/obj/item/storage/box/freezer/ProcessAtomTemperature()
	return PROCESS_KILL

/obj/item/storage/box/checkers
	name = "checkers box"
	desc = "This box holds a nifty portion of checkers. Foam-shaped on the inside so that only checkers may fit."
	icon_state = "checkers"
	max_storage_space = 24
	foldable = null
	can_hold = list(/obj/item/reagent_containers/food/snacks/checker)
	startswith = list(/obj/item/reagent_containers/food/snacks/checker = 12,
					/obj/item/reagent_containers/food/snacks/checker/red = 12)

/obj/item/storage/box/checkers/chess
	name = "black chess box"
	desc = "This box holds all the pieces needed for the black side of the chess board."
	icon_state = "chess_b"
	startswith = list(/obj/item/reagent_containers/food/snacks/checker/pawn = 8,
				/obj/item/reagent_containers/food/snacks/checker/knight = 2,
				/obj/item/reagent_containers/food/snacks/checker/bishop = 2,
				/obj/item/reagent_containers/food/snacks/checker/rook = 2,
				/obj/item/reagent_containers/food/snacks/checker/queen = 1,
				/obj/item/reagent_containers/food/snacks/checker/king = 1)

/obj/item/storage/box/checkers/chess/red
	name = "red chess box"
	desc = "This box holds all the pieces needed for the red side of the chess board."
	icon_state = "chess_r"
	startswith = list(/obj/item/reagent_containers/food/snacks/checker/pawn/red = 8,
				/obj/item/reagent_containers/food/snacks/checker/knight/red = 2,
				/obj/item/reagent_containers/food/snacks/checker/bishop/red = 2,
				/obj/item/reagent_containers/food/snacks/checker/rook/red = 2,
				/obj/item/reagent_containers/food/snacks/checker/queen/red = 1,
				/obj/item/reagent_containers/food/snacks/checker/king/red = 1)


/obj/item/storage/box/headset
	name = "box of spare headsets"
	desc = "A box full of headsets."
	startswith = list(/obj/item/device/radio/headset = 7)

//Spare Armbands

/obj/item/storage/box/armband/engine
	name = "box of spare engineering armbands"
	desc = "A box full of engineering armbands. For use in emergencies when provisional engineering peronnel are needed."
	startswith = list(/obj/item/clothing/accessory/armband/engine = 6)

/obj/item/storage/box/armband/med
	name = "box of spare medical armbands"
	desc = "A box full of medical armbands. For use in emergencies when provisional medical personnel are needed."
	startswith = list(
		/obj/item/clothing/accessory/armband/med = 6)

/obj/item/storage/box/armband/peace
	name = "box of spare peacekeeper armbands"
	desc = "A box full of peacekeeper armbands. For use in emergencies when provisional security personnel are needed."
	startswith = list(/obj/item/clothing/accessory/armband/bluegold = 6)

/obj/item/storage/box/imprinting
	name = "box of education implants"
	desc = "A box full of neural implants for on-job training."
	startswith = list(
		/obj/item/implanter,
		/obj/item/implantpad,
		/obj/item/implantcase/imprinting = 3
		)

/obj/item/storage/box/detergent
	name = "detergent pods bag"
	desc = "A bag full of juicy, yummy detergent pods. This bag has been labeled: Tod Pods, a Waffle Co. product."
	icon_state = "detergent"
	startswith = list(/obj/item/reagent_containers/pill/detergent = 10)

//cargosia supply boxes - Primarily for restocking

/obj/item/storage/box/tapes
	name = "box of spare tapes"
	desc = "A box full of blank tapes."
	startswith = list(/obj/item/device/tape/random = 14)

/obj/item/storage/box/taperolls
	name = "box of spare taperolls"
	desc = "A box full of mixed barricade tapes."
	startswith = list(/obj/item/taperoll/police,
						/obj/item/taperoll/engineering,
						/obj/item/taperoll/atmos,
						/obj/item/taperoll/research,
						/obj/item/taperoll/medical,
						/obj/item/taperoll/bureaucracy
					)

/obj/item/storage/box/bogrolls
	name = "box of spare bogrolls"
	desc = "A box full of toilet paper."
	startswith = list(/obj/item/taperoll/bog = 6)

/obj/item/storage/box/cola
	name = "box of sodas"
	desc = "A box full of soda cans."
	startswith = list(/obj/item/reagent_containers/food/drinks/cans/cola = 7)

/obj/item/storage/box/cola/beastenergy
	name = "box of beast energy"
	desc = "A box full of beast energy cans."
	startswith = list(/obj/item/reagent_containers/food/drinks/cans/beastenergy = 7)

/obj/item/storage/box/water
	name = "box of water bottles"
	desc = "A box full of bottled water."
	startswith = list(/obj/item/reagent_containers/food/drinks/cans/waterbottle = 7)

/obj/item/storage/box/cola/spacewind
	startswith = list(/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 7)

/obj/item/storage/box/cola/drgibb
	startswith = list(/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 7)

/obj/item/storage/box/cola/ionbru
	startswith = list(/obj/item/reagent_containers/food/drinks/cans/ionbru = 7)

/obj/item/storage/box/cola/spaceup
	startswith = list(/obj/item/reagent_containers/food/drinks/cans/space_up = 7)

/obj/item/storage/box/cola/lemonlime
	startswith = list(/obj/item/reagent_containers/food/drinks/cans/lemon_lime = 7)

/obj/item/storage/box/cola/icedtea
	startswith = list(/obj/item/reagent_containers/food/drinks/cans/iced_tea = 7)

/obj/item/storage/box/cola/grapejuice
	startswith = list(/obj/item/reagent_containers/food/drinks/cans/grape_juice = 7)

/obj/item/storage/box/cola/sodawater
	startswith = list(/obj/item/reagent_containers/food/drinks/cans/sodawater = 7)

/obj/item/storage/box/snack
	name = "box of snack food"
	desc = "A box full of snack foods."
	startswith = list(/obj/item/reagent_containers/food/snacks/skrellsnacks = 7)

/obj/item/storage/box/snack/jerky
	startswith = list(/obj/item/reagent_containers/food/snacks/sosjerky = 7)

/obj/item/storage/box/snack/noraisin
	startswith = list(/obj/item/reagent_containers/food/snacks/no_raisin = 7)

/obj/item/storage/box/snack/cheesehonks
	startswith = list(/obj/item/reagent_containers/food/snacks/cheesiehonkers = 7)

/obj/item/storage/box/snack/tastybread
	startswith = list(/obj/item/reagent_containers/food/snacks/tastybread = 7)

/obj/item/storage/box/snack/candy
	startswith = list(/obj/item/reagent_containers/food/snacks/candy = 7)

/obj/item/storage/box/snack/chips
	startswith = list(/obj/item/reagent_containers/food/snacks/chips = 7)

//canned goods in cardboard
/obj/item/storage/box/canned
	name = "box of canned food"
	desc = "A box full of canned foods."
	startswith = list(/obj/item/reagent_containers/food/snacks/canned/spinach = 1)

/obj/item/storage/box/canned/beef
	startswith = list(/obj/item/reagent_containers/food/snacks/canned/beef = 6)

/obj/item/storage/box/canned/beans
	startswith = list(/obj/item/reagent_containers/food/snacks/canned/beans = 6)

/obj/item/storage/box/canned/tomato
	startswith = list(/obj/item/reagent_containers/food/snacks/canned/tomato = 6)
