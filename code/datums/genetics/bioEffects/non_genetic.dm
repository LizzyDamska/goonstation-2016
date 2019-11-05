/datum/bioEffect/hidden
	name = "Miner Training"
	desc = "Subject is trained in geological and metallurgical matters."
	id = "training_miner"
	probability = 0
	occur_in_genepools = 0
	scanner_visibility = 0
	curable_by_mutadone = 0
	can_reclaim = 0
	can_copy = 0
	can_scramble = 0
	can_research = 0
	can_make_injector = 0
	reclaim_fail = 100
	effectType = effectTypePower

/datum/bioEffect/hidden/trainingchaplain
	name = "Chaplain Training"
	desc = "Subject is trained in cultural and psychological matters."
	id = "training_chaplain"

//	OnAdd()
//		if (ishuman(owner))
//			owner.add_ability_holder(/datum/abilityHolder/religious)

/datum/bioEffect/hidden/trainingmedical
	name = "Medical Training"
	desc = "Subject is a proficient surgeon."
	id = "training_medical"

/datum/bioEffect/hidden/arcaneshame
	// temporary debuff for when the wizard gets shaved
	name = "Wizard's Shame"
	desc = "Subject is suffering from Post Traumatic Shaving Disorder."
	id = "arcane_shame"
	msgGain = "You feel shameful.  Also bald."
	msgLose = "Your shame fades. Now you feel only righteous anger!"
	effectType = effectTypeDisability
	isBad = 1

/datum/bioEffect/hidden/arcanepower
	// Variant 1 = Half Spell Cooldown, Variant 2 = No Spell Cooldown
	// Only use variant 2 for debugging/horrible admin gimmicks ok
	name = "Arcane Power"
	desc = "Subject is imbued with an unknown power."
	id = "arcane_power"
	msgGain = "Your hair stands on end."
	msgLose = "The tingling in your skin fades."

/datum/bioEffect/hidden/husk
	name = "Husk"
	desc = "Subject appears to have been drained of all fluids."
	id = "husk"
	effectType = effectTypeDisability
	isBad = 1

	OnMobDraw()
		if(ishuman(owner))
			owner:body_standing:overlays += image('icons/mob/human.dmi', "husk")

	OnAdd()
		if (ishuman(owner))
			owner:set_body_icon_dirty()

	OnRemove()
		if (ishuman(owner))
			owner:set_body_icon_dirty()

/datum/bioEffect/hidden/eaten
	name = "Eaten"
	desc = "Subject appears to have been partially consumed."
	id = "eaten"
	effectType = effectTypeDisability
	isBad = 1

	OnMobDraw()
		if (ishuman(owner) && !owner:decomp_stage)
			owner:body_standing:overlays += image('icons/mob/human.dmi', "decomp1")
		return

	OnAdd()
		if (ishuman(owner))
			owner:set_body_icon_dirty()

	OnRemove()
		if (ishuman(owner))
			owner:set_body_icon_dirty()

/datum/bioEffect/hidden/consumed
	name = "Consumed"
	desc = "Most of their flesh has been chewed off."
	id = "consumed"
	effectType = effectTypeDisability

/datum/bioEffect/hidden/zombie
	// Don't put this one in the standard mutantrace pool
	name = "Necrotic Degeneration"
	desc = "Subject's cellular structure is degenerating due to sub-lethal necrosis."
	id = "zombie"
	effectType = effectTypeMutantRace
	isBad = 1
	msgGain = "You begin to rot."
	msgLose = "You are no longer rotting."

	OnAdd()
		owner.set_mutantrace(/datum/mutantrace/zombie)
		return

	OnRemove()
		if (istype(owner:mutantrace, /datum/mutantrace/zombie))
			owner.set_mutantrace(null)
		return

	OnLife()
		if(!istype(owner:mutantrace, /datum/mutantrace/zombie))
			holder.RemoveEffect(id)
		return

/datum/bioEffect/hidden/premature_clone
	// Probably shouldn't put this one in either
	name = "Stunted Genetics"
	desc = "Genetic abnormalities possibly resulting from incomplete development in a cloning pod."
	id = "premature_clone"
	effectType = effectTypeMutantRace
	isBad = 1
	msgGain = "You don't feel quite right."
	msgLose = "You feel normal again."
	var/outOfPod = 0 //Out of the cloning pod.

	OnAdd()
		owner.set_mutantrace(/datum/mutantrace/premature_clone)
		if (!istype(owner.loc, /obj/machinery/clonepod))
			boutput(owner, "<span style=\"color:red\">Your genes feel...disorderly.</span>")
		return

	OnRemove()
		if (istype(owner:mutantrace, /datum/mutantrace/premature_clone))
			owner.set_mutantrace(null)
		return

	OnLife()
		if(!istype(owner:mutantrace, /datum/mutantrace/premature_clone))
			holder.RemoveEffect(id)

		if (outOfPod)
			if (prob(6))
				owner.visible_message("<span style=\"color:red\">[owner.name] suddenly and violently vomits!</span>")
				playsound(owner.loc, "sound/effects/splat.ogg", 50, 1)
				new /obj/decal/cleanable/vomit(owner.loc)

			else if (prob(2))
				owner.visible_message("<span style=\"color:red\">[owner.name] vomits blood!</span>")
				playsound(owner.loc, "sound/effects/splat.ogg", 50, 1)
				random_brute_damage(owner, rand(5,8))
				bleed(owner, rand(5,8), 5)

		else if (!istype(owner.loc, /obj/machinery/clonepod))
			outOfPod = 1

		return

/datum/bioEffect/hidden/sims_stinky
	name = "Poor Hygiene"
	desc = "This guy needs a shower, stat!"
	id = "sims_stinky"
	effectType = effectTypeDisability
	isBad = 1
	curable_by_mutadone = 0
	occur_in_genepools = 0
	var/personalized_stink = "Wow, it stinks in here!"

	New()
		..()
		src.personalized_stink = stinkString()
		if (prob(5))
			src.variant = 2

	OnLife()
		if (prob(10))
			for(var/mob/living/carbon/C in view(6,get_turf(owner)))
				if (C == owner)
					continue
				if (src.variant == 2)
					boutput(C, "<span style=\"color:red\">[src.personalized_stink]</span>")
				else
					boutput(C, "<span style=\"color:red\">[stinkString()]</span>")

////////////////
// Rocket Arm //
///////////////
/mob/proc/give_rocketarm(var/arm_check = 0, var/remove_powers = 0)
	if(ishuman(src))
		var/mob/living/carbon/human/dingus = src
		if(remove_powers == 1)
			dingus.abilityHolder.removeAbility(/datum/targetable/geneticsAbility/rocketpunch/rocketpunch_l)
			dingus.abilityHolder.removeAbility(/datum/targetable/geneticsAbility/rocketpunch/rocketpunch_r)
			return

		else
			if (arm_check == 1 && (dingus.limbs.l_arm && istype(dingus.limbs.l_arm, /obj/item/parts/human_parts/arm/left/rocket)))
				if(dingus.limbs.r_arm && istype(dingus.limbs.r_arm, /obj/item/parts/human_parts/arm/right/rocket))
					var/datum/abilityHolder/robotics/rocket2 = dingus.add_ability_holder(/datum/abilityHolder/robotics)
					rocket2.addAbility(/datum/targetable/geneticsAbility/rocketpunch/rocketpunch_r)
					rocket2.addAbility(/datum/targetable/geneticsAbility/rocketpunch/rocketpunch_l)
				else
					var/datum/abilityHolder/robotics/rocket3 = dingus.add_ability_holder(/datum/abilityHolder/robotics)
					rocket3.addAbility(/datum/targetable/geneticsAbility/rocketpunch/rocketpunch_l)
			else if (arm_check == 1 && (dingus.limbs.r_arm && istype(dingus.limbs.r_arm, /obj/item/parts/human_parts/arm/right/rocket)))
				var/datum/abilityHolder/robotics/rocket4 = dingus.add_ability_holder(/datum/abilityHolder/robotics)
				rocket4.addAbility(/datum/targetable/geneticsAbility/rocketpunch/rocketpunch_r)
			else
				return

/datum/abilityHolder/robotics
	usesPoints = 0
	regenRate = 0
	tabName = "Roboman"

/datum/targetable/geneticsAbility/rocketpunch/rocketpunch_l
	name = "Rocket Punch"
	desc = "Lets you punch people from a distance!"
	icon_state = "template"

	cast(atom/target)
		if (..())
			return 1
		if(ishuman(owner))
			var/mob/living/carbon/human/dwight = owner
			if(!dwight.l_hand)
				var/turf/T = get_turf(target)
				var/projectile_path = /datum/projectile/rocketarm/rocketarm_left
				owner.visible_message("<span style=\"color:red\"><b>[owner.name]</b> fires \his arm!</span>")
				var/datum/projectile/rocketarm/rocketarm_left/PJ = new projectile_path
				shoot_projectile_ST(owner, PJ, T)
				dwight.limbs.l_arm = null
				qdel(dwight.limbs.l_arm)
				owner.give_rocketarm(1, 1)
			else
				boutput(usr, "You can't make a fist with something in your hand!")

/datum/targetable/geneticsAbility/rocketpunch/rocketpunch_r
	name = "Rocket Punch"
	desc = "Lets you punch people from a distance!"
	icon_state = "template"

	cast(atom/target)
		if (..())
			return 1
		if(ishuman(owner))
			var/mob/living/carbon/human/dwight = owner
			if(!owner.r_hand)
				var/turf/T = get_turf(target)
				var/projectile_path = /datum/projectile/rocketarm/rocketarm_right
				owner.visible_message("<span style=\"color:red\"><b>[owner.name]</b> fires \his arm!</span>")
				var/datum/projectile/rocketarm/rocketarm_right/PJ = new projectile_path
				shoot_projectile_ST(owner, PJ, T)
				dwight.limbs.r_arm = null
				qdel(dwight.limbs.r_arm)
				owner.give_rocketarm(1, 1)
			else
				boutput(usr, "You can't make a fist with something in your hand!")