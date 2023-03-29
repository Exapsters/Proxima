//The storage module allows a rig to be used as a sort of backpack, by using an internal storage compartment
/obj/item/rig_module/storage
	name = "internal storage compartment"
	desc = "A storage container designed to be installed in a RIG suit. Has 20 litres of space"

	var/obj/item/storage/internal/container = null
	w_class = ITEM_SIZE_HUGE

	//The default iconstate is actually really perfect for this, it looks like a reinforced box
	//Duplicate specify it here incase it gets changed in the parent in future
	icon_state = "module"

	//These vars will be passed onto the storage
	var/list/can_hold = new/list() //List of objects which this item can store (if set, it can't store anything else)
	var/list/cant_hold = new/list(/obj/item/rig, /obj/item/rig_module/storage) //List of objects which this item can't store (in effect only if can_hold isn't set)
	var/max_w_class = ITEM_SIZE_NORMAL //Max size of objects that this object can store (in effect only if can_hold isn't set)
	var/max_storage_space = DEFAULT_BACKPACK_STORAGE
	var/storage_slots = null //The number of storage slots in this container.

/obj/item/rig_module/storage/light
	name = "small internal storage compartment"
	desc = "A storage container designed to be installed in a RIG suit. Has 16 litres of space"

	max_storage_space = DEFAULT_LARGEBOX_STORAGE

/obj/item/rig_module/storage/heavy
	name = "expanded internal storage compartment"
	desc = "A storage container designed to be installed in a RIG suit. Has 25 litres of space, and can fit bigger objects"
	max_w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE + 10

//Create the internal storage and pass on various parameters
/obj/item/rig_module/storage/New()
	container = new /obj/item/storage/internal(src)
	container.can_hold = can_hold
	container.cant_hold = cant_hold
	container.max_w_class = max_w_class
	container.max_storage_space = max_storage_space
	container.storage_slots = storage_slots
	container.master_item = src //If its installed immediately after creation this will get set to the rig in install proc
	.=..()
/*****************************
	Installation
*****************************/
//Installing stuff
/obj/item/rig_module/storage/can_install(var/obj/item/rig/rig, var/mob/user, var/feedback = FALSE)
	if (rig.storage) //If it already has a storage mod installed, then no adding another one
		if (user && feedback)
			to_chat(user, SPAN_DANGER("The [rig] already has a storage module installed, you can't fit another one."))
		return FALSE
	.=..()

/obj/item/rig_module/storage/installed()
	.=..()
	holder.storage = src //Set ourselves as the storage mod
	container.master_item = holder //When its inside a rig, that rig is the thing we use for location checks

/obj/item/rig_module/storage/removed(var/obj/item/rig/former, var/mob/living/user)
	.=..()
	former.storage = null //Unset the storage mod
	container.master_item = src //When its outside a rig, use ourselves for location checks




/*****************************
	Internal Handling
*****************************/
//This is called whenever people use something on the rig backpack
/obj/item/rig_module/storage/accepts_item(var/obj/item/input_device)
	if (container)
		return container.attackby(input_device, usr)
	return FALSE

//This will return false if we're done, or true to tell us to keep going and call parent attackhand
/obj/item/rig_module/storage/proc/handle_attack_hand(mob/user as mob)
	return container.handle_attack_hand(user)

/obj/item/rig_module/storage/proc/handle_mousedrop(var/mob/user, var/atom/over_object)
	return container.handle_mousedrop(user, over_object)


/*****************************
	External handling
*****************************/
//The module can be used as a storage container even when not inside a rig
/obj/item/rig_module/storage/attackby(obj/item/W as obj, mob/user as mob)
	.=..()
	if (!.)
		return accepts_item(W)

//More external functionality
/obj/item/rig_module/storage/MouseDrop(obj/over_object)
	if(container.handle_mousedrop(usr, over_object))
		return TRUE
	return ..()


/obj/item/rig_module/storage/attack_hand(mob/user as mob)
	if (loc == user)
		container.open(user)
	else
		container.close_all()
		..()

	src.add_fingerprint(user)
	return
