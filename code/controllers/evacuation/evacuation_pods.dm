#define EVAC_OPT_ABANDON_SHIP "abandon_ship"
#define EVAC_OPT_BLUESPACE_JUMP "bluespace_jump"
#define EVAC_OPT_CANCEL_ABANDON_SHIP "cancel_abandon_ship"
#define EVAC_OPT_CANCEL_BLUESPACE_JUMP "cancel_bluespace_jump"

// Apparently, emergency_evacuation --> "abandon ship" and !emergency_evacuation --> "bluespace jump"
// That stuff should be moved to the evacuation option datums but someone can do that later
/datum/evacuation_controller
	var/confirmed

/datum/evacuation_controller/proc/make_prepared()

/datum/evacuation_controller/starship
	name = "escape pod controller"

	evac_prep_delay    = 5 MINUTES
	evac_launch_delay  = 3 MINUTES
	evac_transit_delay = 2 MINUTES

	transfer_prep_additional_delay     = 15 MINUTES
	autotransfer_prep_additional_delay = 5 MINUTES
	emergency_prep_additional_delay    = 0 MINUTES

	evacuation_options = list(
		EVAC_OPT_ABANDON_SHIP = new /datum/evacuation_option/abandon_ship(),
		EVAC_OPT_BLUESPACE_JUMP = new /datum/evacuation_option/bluespace_jump(),
		EVAC_OPT_CANCEL_ABANDON_SHIP = new /datum/evacuation_option/cancel_abandon_ship(),
		EVAC_OPT_CANCEL_BLUESPACE_JUMP = new /datum/evacuation_option/cancel_bluespace_jump()
	)

/datum/evacuation_controller/starship/finish_preparing_evac()
	. = ..()
	// Arm the escape pods.
	if (emergency_evacuation)
		for (var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods)
			if (pod.arming_controller)
				pod.arming_controller.arm()

/datum/evacuation_controller/starship/launch_evacuation()

	state = EVAC_IN_TRANSIT

	if (emergency_evacuation)
		// Abondon Ship
		//[PRX BEGIN]
		for (var/mob/living/carbon/human/person in world)
			if(person.z in GLOB.using_map.station_levels) //checking if it's a crew member
				var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
				if(!(get_area(person) in GLOB.using_map.post_round_safe_areas) && istype(security_state.current_security_level, /decl/security_level/default/torchdept/code_delta))
					sound_to(person, 'proxima/sound/music/chamber.ogg')
		//[PRX END]
		for (var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods) // Launch the pods!
			if (!pod.arming_controller || pod.arming_controller.armed)
				pod.move_time = (evac_transit_delay/10)
				pod.launch(src)

		priority_announcement.Announce(replacetext_char(replacetext_char(GLOB.using_map.emergency_shuttle_leaving_dock, "%dock_name%", "[GLOB.using_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))
	else
		// Bluespace Jump
		priority_announcement.Announce(replacetext_char(replacetext_char(GLOB.using_map.shuttle_leaving_dock, "%dock_name%", "[GLOB.using_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))
		SetUniversalState(/datum/universal_state/bluespace_jump, arguments=list(GLOB.using_map.station_levels))

/datum/evacuation_controller/starship/finish_evacuation()
	..()
	if(!emergency_evacuation) //bluespace jump
		SetUniversalState(/datum/universal_state) //clear jump state

/datum/evacuation_controller/starship/cancel_evacuation()
	var/emerg = emergency_evacuation
	. = ..()

	if(emerg)
		// Close the pods (space shields)
		for(var/obj/machinery/door/blast/regular/escape_pod/ES in world)
			INVOKE_ASYNC(ES, /obj/machinery/door/blast/proc/force_close)
		for (var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods) // Unarm the pods!
			pod.set_self_unarm()

/datum/evacuation_controller/starship/can_cancel()
	// Are we evacuating?
	if(isnull(evac_called_at))
		return 0
	// Have we already launched?
	if(!((state == 1) || (state == EVAC_LAUNCHING)))
		return 0
	// Are we already committed?
	if(world.time > evac_no_return)
		return 0
	return 1

/datum/evacuation_controller/starship/make_prepared()
	var/time_diff = evac_ready_time - world.time
	evac_ready_time = world.time
	evac_launch_time -= time_diff
	evac_arrival_time -= time_diff
	evac_no_return -= time_diff

/datum/evacuation_controller/starship/call_evacuation(var/mob/user, var/_emergency_evac, var/forced, var/skip_announce, var/autotransfer)
	if((user && isAI(user)) || forced)
		if(state == 1)
			make_prepared()
			return 1
		emergency_prep_additional_delay = 0 MINUTES
		confirmed = "confirmed"
		skip_announce = TRUE


	. = ..(user, _emergency_evac, forced, skip_announce, autotransfer)
	emergency_prep_additional_delay = initial(emergency_prep_additional_delay)	// Reseting time shortcut
	if(.)
		evac_no_return = evac_ready_time + round(evac_launch_delay/2)

/datum/evacuation_controller/starship/available_evac_options()
	if (is_on_cooldown())
		return list()
	if (is_idle())
		return list(evacuation_options[EVAC_OPT_BLUESPACE_JUMP], evacuation_options[EVAC_OPT_ABANDON_SHIP])
	if (is_evacuating())
		if (emergency_evacuation)
			return list(evacuation_options[EVAC_OPT_CANCEL_ABANDON_SHIP])
		else
			return list(evacuation_options[EVAC_OPT_CANCEL_BLUESPACE_JUMP])

/datum/evacuation_option/abandon_ship
	option_text = "Abandon spacecraft"
	option_desc = "abandon the spacecraft"
	option_target = EVAC_OPT_ABANDON_SHIP
	needs_syscontrol = TRUE
	silicon_allowed = TRUE
	abandon_ship = TRUE

/datum/evacuation_option/abandon_ship/execute(mob/user)
	if (!evacuation_controller)
		return
	if (evacuation_controller.deny)
		to_chat(user, "Unable to initiate escape procedures.")
		return
	if (evacuation_controller.is_on_cooldown())
		to_chat(user, evacuation_controller.get_cooldown_message())
		return
	if (evacuation_controller.is_evacuating())
		to_chat(user, "Escape procedures already in progress.")
		return
	if (evacuation_controller.call_evacuation(user, 1))
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has initiated abandonment of the spacecraft.")

/datum/evacuation_option/bluespace_jump
	option_text = "Initiate bluespace jump"
	option_desc = "initiate a bluespace jump"
	option_target = EVAC_OPT_BLUESPACE_JUMP
	needs_syscontrol = TRUE
	silicon_allowed = TRUE

/datum/evacuation_option/bluespace_jump/execute(mob/user)
	if (!evacuation_controller)
		return
	if (evacuation_controller.deny)
		to_chat(user, "Unable to initiate jump preparation.")
		return
	if (evacuation_controller.is_on_cooldown())
		to_chat(user, evacuation_controller.get_cooldown_message())
		return
	if (evacuation_controller.is_evacuating())
		to_chat(user, "Jump preparation already in progress.")
		return
	if (evacuation_controller.call_evacuation(user, 0))
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has initiated bluespace jump preparation.")

/datum/evacuation_option/cancel_abandon_ship
	option_text = "Cancel abandonment"
	option_desc = "cancel abandonment of the spacecraft"
	option_target = EVAC_OPT_CANCEL_ABANDON_SHIP
	needs_syscontrol = TRUE
	silicon_allowed = FALSE

/datum/evacuation_option/cancel_abandon_ship/execute(mob/user)
	if (evacuation_controller && evacuation_controller.cancel_evacuation())
		log_and_message_admins("[key_name(user)] has cancelled abandonment of the spacecraft.")

/datum/evacuation_option/cancel_bluespace_jump
	option_text = "Cancel bluespace jump"
	option_desc = "cancel the jump preparation"
	option_target = EVAC_OPT_CANCEL_BLUESPACE_JUMP
	needs_syscontrol = TRUE
	silicon_allowed = FALSE

/datum/evacuation_option/cancel_bluespace_jump/execute(mob/user)
	if (evacuation_controller && evacuation_controller.cancel_evacuation())
		log_and_message_admins("[key_name(user)] has cancelled the bluespace jump.")

#undef EVAC_OPT_ABANDON_SHIP
#undef EVAC_OPT_BLUESPACE_JUMP
#undef EVAC_OPT_CANCEL_ABANDON_SHIP
#undef EVAC_OPT_CANCEL_BLUESPACE_JUMP
