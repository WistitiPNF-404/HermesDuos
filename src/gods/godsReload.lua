-- Hermes x Poseidon
modutil.mod.Path.Wrap("CalculateDamageMultipliers", function(baseFunc, attacker, victim, weaponData, triggerArgs )
	baseFunc( attacker, victim, weaponData, triggerArgs )
	return mod.CalculateGoldenDamageMultiplier ( attacker, victim, weaponData, triggerArgs )
end)

function mod.CalculateGoldenDamageMultiplier ( attacker, victim, weaponData, triggerArgs )
	if attacker ~= nil and attacker.OutgoingDamageModifiers ~= nil and ( not weaponData or not weaponData.IgnoreOutgoingDamageModifiers ) then
		local appliedEffectTable = {}
		for i, modifierData in ipairs( attacker.OutgoingDamageModifiers ) do
			if modifierData.GlobalMultiplier ~= nil then
				addDamageMultiplier( modifierData, modifierData.GlobalMultiplier)
			end
			local validEffect = modifierData.ValidEffects == nil or ( triggerArgs.EffectName ~= nil and Contains(modifierData.ValidEffects, triggerArgs.EffectName ))
			local validWeapon = modifierData.ValidWeaponsLookup == nil or ( modifierData.ValidWeaponsLookup[ triggerArgs.SourceWeapon ] ~= nil and triggerArgs.EffectName == nil )
			local validProjectile = modifierData.ValidProjectilesLookup == nil or ( triggerArgs.SourceProjectile and modifierData.ValidProjectilesLookup[ triggerArgs.SourceProjectile ] ~= nil and triggerArgs.EffectName == nil )
			local validTrait = modifierData.RequiredTrait == nil or ( attacker == CurrentRun.Hero and HeroHasTrait( modifierData.RequiredTrait ) )
			local validUniqueness = modifierData.Unique == nil or not modifierData.Name or not appliedEffectTable[modifierData.Name]
			local validActiveEffect = modifierData.ValidActiveEffects == nil or (victim.ActiveEffects and ContainsAnyKey( victim.ActiveEffects, modifierData.ValidActiveEffects))
			local validActiveEffectGenus = modifierData.ValidActiveEffectGenus == nil or HasVulnerabilityGenusEffect( victim, modifierData.ValidActiveEffectGenus )
			local validActivatedTrait = modifierData.RequiredActivatedTraitName == nil or (HeroHasTrait(modifierData.RequiredActivatedTraitName) and GetHeroTrait(modifierData.RequiredActivatedTraitName).Activated)
			local validEnchantment = true
			if modifierData.WeaponOrProjectileRequirement then
				validWeapon = validWeapon or validProjectile
				validProjectile = validWeapon or validProjectile
			end
			if not validWeapon and modifierData.ConditionalValidWeapon then
				local conditionData = modifierData.ConditionalValidWeapon
				if conditionData.TraitName and HeroHasTrait(conditionData.TraitName) then
					if triggerArgs.SourceWeapon == conditionData.WeaponName then
						validWeapon = true
					end
				end
			end
			if triggerArgs.ExplicitMultipliersOnly and validWeapon and not modifierData.ValidWeaponsLookup then
				validWeapon = false
			end
			if modifierData.ValidEnchantments and attacker == CurrentRun.Hero then
				validEnchantment = false
				if modifierData.ValidEnchantments.TraitDependentWeapons then
					for traitName, validWeapons in pairs( modifierData.ValidEnchantments.TraitDependentWeapons ) do
						if Contains( validWeapons, triggerArgs.SourceWeapon) and HeroHasTrait( traitName ) then
							validEnchantment = true
							break
						end
					end
				end

				if not validEnchantment and modifierData.ValidEnchantments.ValidWeapons and Contains( modifierData.ValidEnchantments.ValidWeapons, triggerArgs.SourceWeapon ) then
					validEnchantment = true
				end
			end
			if validUniqueness and validWeapon and validProjectile and validEffect and validTrait and validEnchantment and validActiveEffect and validActiveEffectGenus and validActivatedTrait then
				if modifierData.GoldMultiplier then
					addDamageMultiplier( modifierData, 1 + GetResourceAmount( "Money" ) / 100 * modifierData.GoldMultiplier )
				end
			end
		end
	end
	return damageMultipliers * damageReductionMultipliers
end

-- Hermes x Demeter
function mod.CreateOmegaGusts (weaponData, functionArgs, triggerArgs)
	local isExIndirectCast = false
	if SessionMapState.ArmCast and weaponData.ArmedCastChargeStage then
		isExIndirectCast = true
	end
	local angle = GetAngle({ Id = CurrentRun.Hero.ObjectId })
	if IsExWeapon( weaponData.Name, {Combat = true}, triggerArgs ) or isExIndirectCast then
		local patateIds = { }
		for i=1, functionArgs.NumProjectiles do
			angle = i * ( 360 / functionArgs.NumProjectiles )
			local projectileId = CreateProjectileFromUnit({ 
				Name = functionArgs.ProjectileName, 
				Id = CurrentRun.Hero.ObjectId, 
				DamageMultiplier = functionArgs.DamageMultiplier,
				Angle = angle
			})
			table.insert( patateIds, projectileId)
		end
		wait(3, RoomThreadName)
		Destroy({ Ids = patateIds })
	end
end

-- Hermes x Apollo
-- Setup function
--[[function SetupTeleportCast( unit, args )
	SwapWeapon({ Name = "WeaponCast", SwapWeaponName = "WeaponTeleportCast", DestinationId = unit.ObjectId, StompOriginalWeapon = true })
end]]

-- Hermes x Hestia
function mod.FireballSprintSetup ( weaponData, traitArgs, triggerArgs )
	--CreateAnimation({ Name = "HestiaFlameLoopCombined", DestinationId = CurrentRun.Hero.ObjectId })
end

function mod.FireballSprintLaunch ( weaponData, traitArgs, triggerArgs )
	local traitData = GetHeroTrait(gods.GetInternalBoonName("FireballSprintBoon"))
	local functionArgs = traitData.OnWeaponFiredFunctions.FunctionArgs 
	local heroAngle = GetAngle({ Id = CurrentRun.Hero.ObjectId })

	local sprintFireballProjectile = 
	{
		Name = functionArgs.ProjectileName,
		DamageMultiplier = functionArgs.DamageMultiplier,
		Id = CurrentRun.Hero.ObjectId,
		ScaleMultiplier = 1,
	}

	CreateProjectileFromUnit(sprintFireballProjectile)
end

modutil.mod.Path.Wrap("CreateProjectileFromUnit", function (baseFunc, args)
	if args.Name == "ProjectileFireball" then -- Controlled Burn's fireball
		local fireballSizeMultiplier = GetTotalHeroTraitValue("ReportedFireballSizeMultiplier", { IsMultiplier = true })
		args.ScaleMultiplier = (args.ScaleMultiplier or 1) * fireballSizeMultiplier
	end
	return baseFunc(args)
end)

modutil.mod.Path.Wrap("OnWeaponFiredFunctions", function (baseFunc, args)
	if args.Name == "ProjectileCastFireball" then -- Glowing Coal's fireball
		local fireballSizeMultiplier = GetTotalHeroTraitValue("ReportedFireballSizeMultiplier", { IsMultiplier = true })
		args.ScaleMultiplier = (args.ScaleMultiplier or 1) * fireballSizeMultiplier
	end
	return baseFunc(args)
end)