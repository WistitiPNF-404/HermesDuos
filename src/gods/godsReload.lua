-- Hermes x Zeus
function mod.MagnetifyCrowd( hero, args, victim )
	while true do
		-- Finding the lightning rod
		local nearbyTargetIds = GetClosestIds({ Id = CurrentRun.Hero.ObjectId, DestinationName = "EnemyTeam", IgnoreInvulnerable = true, IgnoreHomingIneligible = true, IgnoreSelf = true, Distance = 2000 })
		local eligibleEnemies = {}
		for _, id in pairs(nearbyTargetIds) do
			if ActiveEnemies[id] and not ActiveEnemies[id].IsDead and not ActiveEnemies[id].SkipModifiers then
				table.insert(eligibleEnemies, ActiveEnemies[id])
			end
		end
		if not IsEmpty(eligibleEnemies) and TableLength(eligibleEnemies) >= 1 then
			if not MapState.CrowdZappingEnemy or MapState.CrowdZappingEnemy.IsDead then
				if SessionMapState.ZapFieldPresentation then
					StopAnimation({ Name = "MagneticFieldVfx", DestinationId = MapState.AnchorId, IncludeCreatedAnimations = true })
					Destroy( MapState.AnchorId )
				end
				MapState.CrowdZappingEnemy = GetRandomValue(eligibleEnemies)
				SessionMapState.ZapFieldPresentation = false
			end

			if MapState.CrowdZappingEnemy ~= nil then
				if not SessionMapState.ZapFieldPresentation then
					local enemyLocation = GetLocation({Id = MapState.CrowdZappingEnemy.ObjectId })
					local anchorId = SpawnObstacle({ Name = "InvisibleTarget", LocationX = enemyLocation.X, LocationY = enemyLocation.Y, ForceToValidLocation = true })
					MapState.AnchorId = anchorId
					Attach({ Id = anchorId, DestinationId = MapState.CrowdZappingEnemy.ObjectId })
					CreateAnimation({ Name = "MagneticFieldVfx", DestinationId = anchorId, ScaleRadius = 350 })
					SessionMapState.ZapFieldPresentation = true
				end
				thread( mod.ZapNearbyEnemies, MapState.CrowdZappingEnemy )
			end
		else
			wait(0.3, RoomThreadName)
			if IsEmpty(eligibleEnemies) and TableLength(eligibleEnemies) <= 1 then
				StopAnimation({ Name = "MagneticFieldVfx", DestinationId = MapState.AnchorId, IncludeCreatedAnimations = true })
				DestroyOnDelay( MapState.AnchorId, 0.75)
				SessionMapState.ZapFieldPresentation = false
			end
		end
		wait(0.3, RoomThreadName)
	end
end

function mod.ZapNearbyEnemies ( zapper )
	-- Zapping time
	local traitData = GetHeroTrait(gods.GetInternalBoonName("ZappyFieldBoon"))
	local functionArgs = traitData.SetupFunction.Args 
	local zapDistance = functionArgs.ZappingDistance
	local nearbyZappableTargetIds = GetClosestIds({Id = zapper.ObjectId, DestinationName = "EnemyTeam", Distance = zapDistance, IgnoreInvulnerable = true, IgnoreHomingIneligible = true, IgnoreSelf = true})
	local eligibleZappableEnemies = {}
	for _, id in pairs(nearbyZappableTargetIds) do
		if ActiveEnemies[id] and not ActiveEnemies[id].IsDead and not ActiveEnemies[id].SkipModifiers then
			table.insert(eligibleZappableEnemies, ActiveEnemies[id])
		end
	end

	local cooldown = functionArgs.Cooldown
	local bonusDamageMultiplier = 0
	local addlProperties = {}
	if HeroHasTrait("ReboundingSparkBoon") then
		addlProperties.AllowRepeatedOwnerJumpHit = true
		addlProperties.AffectsSelf = true
		--addlProperties.MultipleUnitCollisions = true
	end
	if CheckCooldown( "ZappyFieldBoon", cooldown ) then
		if not IsEmpty(eligibleZappableEnemies) and TableLength(eligibleZappableEnemies) >= 1 then
			if not MapState.ZappableEnemy or MapState.ZappableEnemy.IsDead then
				MapState.ZappableEnemy = GetRandomValue(eligibleZappableEnemies)
			end
			addlProperties.NumJumps = GetBaseDataValue({ Type = "Projectile", Name = functionArgs.ProjectileName, Property = "NumJumps"}) + GetTotalHeroTraitValue("ZeusSparkBonusBounces")
			if zapper.ObjectId ~= nil then
				if zapper.ObjectId or not zapper.ObjectId.IsDead then
					CreateProjectileFromUnit({ 
						Name = functionArgs.ProjectileName, 
						Id = CurrentRun.Hero.ObjectId, 
						DestinationId = zapper.ObjectId, 
						FireFromTarget = true,
						DamageMultiplier = 3 + bonusDamageMultiplier, -- to change with boon description
						ProjectileCap = 5,
						DataProperties = addlProperties 
					})
				end
			end
		end
		if functionArgs.EffectNames then
		
			for i, effectName in pairs( functionArgs.EffectNames ) do
				ApplyEffect( { DestinationId = zapper.ObjectId, Id = CurrentRun.Hero.ObjectId, EffectName = effectName, DataProperties = EffectData[effectName].EffectData, })
			end
		end
	end	
end

-- Hermes x Hera
function mod.HitchCopyStatus( victim, functionArgs, triggerArgs )
	if triggerArgs.EffectName == "DamageShareEffect" and not triggerArgs.Reapplied or not victim or victim.IsDead then 
		local activeCurses = DeepCopyTable( SessionMapState.ValidEffects )
		for i, enemy in pairs( ShallowCopyTable( ActiveEnemies ) ) do
			if enemy ~= victim and not enemy.SkipModifiers and enemy.ActiveEffects then
				for effectName, effectStacks in pairs(enemy.ActiveEffects) do
					if functionArgs.ValidStatusNames[effectName] and activeCurses[effectName] then
						if effectName == "BurnEffect" then
							if not activeCurses[effectName].NumStacks or activeCurses[effectName].NumStacks < effectStacks then
								activeCurses[effectName].NumStacks = effectStacks
							end
						end
						if effectName == "DamageShareEffect" then
							if not activeCurses[effectName].Amount or activeCurses[effectName].Amount < enemy.DamageShareAmount then
								activeCurses[effectName].Amount = enemy.DamageShareAmount
							end
						end
						if effectName == "DamageEchoEffect" then
							if enemy.ActiveEchoes and enemy.ActiveEchoes[effectName] and enemy.ActiveEchoes[effectName].Payoff and 
								( not activeCurses[effectName].Modifier or activeCurses[effectName].Modifier < enemy.ActiveEchoes[effectName].Payoff ) then
								activeCurses[effectName].Modifier = enemy.ActiveEchoes[effectName].Payoff
							end
						end
						
						if effectName == "DelayedKnockbackEffect" then
							activeCurses[effectName].TriggerDamage = enemy.TriggerDamage 
						end
					end
				end
			end
		end

		for effectName, effectData in pairs( activeCurses ) do
			if effectName ~= "DamageShareEffect" then
				if type(functionArgs.ValidStatusNames[effectName]) == "string" then
					thread( _G[functionArgs.ValidStatusNames[effectName]], victim, { EffectName = effectName, EffectArgs = { Modifier = effectData.Modifier, Amount = effectData.Amount }, NumStacks = effectData.NumStacks }, {})
				else
					local dataProperties = {}
					if EffectData[effectName].EffectData then
						dataProperties = MergeTables( EffectData[effectName].EffectData, effectData )
					elseif EffectData[effectName].DataProperties then
						dataProperties = MergeTables( EffectData[effectName].DataProperties, effectData )
					end
					ApplyEffect( { DestinationId = victim.ObjectId, Id = CurrentRun.Hero.ObjectId, EffectName = effectName, DataProperties = dataProperties })	
				end			
			end
		end
	end
end

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
	if not MapState.OmegaStorms then
		MapState.OmegaStorms = {}
	end	
	
	local isExIndirectCast = false
	if SessionMapState.ArmCast and weaponData.ArmedCastChargeStage then
		isExIndirectCast = true
	end
	local targetId = SpawnObstacle({ Name = "InvisibleTarget", DestinationId = CurrentRun.Hero.ObjectId })
	local angle = GetAngle({ Id = CurrentRun.Hero.ObjectId })
	
	if IsEmpty(MapState.AttachedOmegaStormProjectileIds) then
		MapState.AttachedOmegaStormProjectileIds = {}
	end

	if IsExWeapon( weaponData.Name, {Combat = true}, triggerArgs ) or isExIndirectCast then
		for i=1, functionArgs.NumProjectiles do
			angle = i * ( 360 / functionArgs.NumProjectiles )
			local projectileId = CreateProjectileFromUnit({ 
				Name = functionArgs.ProjectileName, 
				DestinationId = targetId,
				Id = CurrentRun.Hero.ObjectId, 
				DamageMultiplier = functionArgs.DamageMultiplier,
				Angle = angle
			})				
			table.insert(MapState.AttachedOmegaStormProjectileIds, projectileId)
		end
		
		table.insert(MapState.OmegaStorms, ShallowCopyTable(MapState.AttachedOmegaStormProjectileIds) )
		
		if TableLength( MapState.OmegaStorms ) > functionArgs.ProjectileCap then
			ExpireProjectiles({ ProjectileIds = MapState.OmegaStorms[1] })
			table.remove( MapState.OmegaStorms, 1)
		end
	end 
end

-- Hermes x Apollo
function mod.InsideCastHealPresentation ( functionArgs )
	wait (0.25)
	if CurrentRun.Hero.ActiveEffects ~= nil then
		if CurrentRun.Hero.ActiveEffects["InsideCastBuff"] then
			CreateAnimation({ Name = "HermesWingsBuff", DestinationId = CurrentRun.Hero.ObjectId })
		end
	end
end

function mod.EndInsideCastHealPresentation ( functionArgs )
	if IsEmpty( CurrentRun.Hero.ActiveEffects ) or not CurrentRun.Hero.ActiveEffects["InsideCastBuff"] then
		StopAnimation({ Name = "HermesWingsBuff", DestinationId = CurrentRun.Hero.ObjectId })
	end
end

-- Hermes x Aphrodite
function mod.WeakToCharmChance ( victim, functionArgs, triggerArgs )
	local nearbyTargetIds = GetClosestIds({ Id = CurrentRun.Hero.ObjectId, DestinationName = "EnemyTeam", IgnoreInvulnerable = true, IgnoreHomingIneligible = true, IgnoreSelf = true, Distance = 2000 })
	local charmedOFEnemies = {}
	if triggerArgs.EffectName == "WeakEffect" and not triggerArgs.Reapplied and victim.ActivationFinished then
		if RandomChance( functionArgs.CharmChance * GetTotalHeroTraitValue("LuckMultiplier", {IsMultiplier = true})) then
			ApplyEffect({ 
				Id = CurrentRun.Hero.ObjectId, 
				DestinationId = victim.ObjectId, 
				EffectName = functionArgs.EffectName or "Charm",
				DataProperties = 
				{
					Type = "CHARM",
					Duration = 8,
					Active = true,
					TimeModifierFraction = 0,
				}
			})
		end
		for _, id in pairs(nearbyTargetIds) do
			if ActiveEnemies[id] and not ActiveEnemies[id].IsDead and not ActiveEnemies[id].SkipModifiers and ActiveEnemies[id].ActiveEffects["Charm"] then
				table.insert(charmedOFEnemies, ActiveEnemies[id])
			end
		end
	end
end

function mod.CharmHitCheck ( traitArgs, attacker, victim, triggerArgs )
	local victim = triggerArgs.Victim
	local attacker = triggerArgs.AttackerTable
	if victim == nil or attacker == nil then
		return
	end
	if attacker ~= CurrentRun.Hero then 
		if IsCharmed({ Id = attacker.ObjectId }) then
			local charmPaycheck = GetTotalHeroTraitValue( "ReportedGoldBonus" )
			AddResource( "Money", round(charmPaycheck * GetTotalHeroTraitValue( "MoneyMultiplier", { IsMultiplier = true } )), "BonusCharmMoney" )
		end
	end
end

-- Hermes x Hephaestus
modutil.mod.Path.Wrap("SpendResource", function (baseFunc, name, amount, source, args)
	if HasHeroTraitValue("GoldtoArmorData") then
		local goldToArmorData = GetHeroTraitValues("GoldtoArmorData")[1]
		local moneyCost = math.ceil(goldToArmorData.GoldCost)
		local currentMoney = GetResourceAmount( "Money" )
		local armorGained = 0
		if currentMoney >= moneyCost then
			local oldGoldToArmorSource = MapState.HealthBufferSources[ "GoldToArmorSource" ] or 0
			armorGained = amount / moneyCost
			AddArmor( oldGoldToArmorSource + armorGained )
			CurrentRun.HasMoneyForArmor = true
		else
			if CurrentRun.HasMoneyForArmor then
				CurrentRun.HasMoneyForArmor = nil
			end
		end
	end
	return baseFunc(name, amount, source, args)
end)

-- Hermes x Hestia
function mod.FireballSprintSetup ( weaponData, traitArgs, triggerArgs )
	--CreateAnimation({ Name = "HestiaFlameLoopCombined", DestinationId = CurrentRun.Hero.ObjectId })
end

function mod.FireballSprintLaunch ( weaponData, traitArgs, triggerArgs )
	local traitData = GetHeroTrait(gods.GetInternalBoonName("FireballSprintBoon"))
	local functionArgs = traitData.OnWeaponFiredFunctions.FunctionArgs 

	local sprintFireballProjectile = 
	{
		Name = functionArgs.ProjectileName,
		DamageMultiplier = functionArgs.DamageMultiplier,
		Id = CurrentRun.Hero.ObjectId,
		ScaleMultiplier = 1,
		DataProperties = 
		{
			DamageRadius = 320,
		}
	}
	CreateProjectileFromUnit(sprintFireballProjectile)
end

modutil.mod.Path.Wrap("CreateProjectileFromUnit", function (baseFunc, args)
	if args.Name == "ProjectileFireball" then -- Controlled Burn's fireball
		local fireballSizeMultiplier = GetTotalHeroTraitValue("ReportedFireballSizeMultiplier", { IsMultiplier = true })
		args.ScaleMultiplier = (args.ScaleMultiplier or 1) * fireballSizeMultiplier
		if args.DataProperties == nil then
			args.DataProperties = { DamageRadius = 320 }
		end
		args.DataProperties.DamageRadius = (args.DataProperties.DamageRadius or 320) * fireballSizeMultiplier
	end
	if args.Name == "ProjectileSprintFireball" then -- Aerobic Capacity's fireball
		local fireballSizeMultiplier = GetTotalHeroTraitValue("ReportedFireballSizeMultiplier", { IsMultiplier = true })
		args.ScaleMultiplier = (args.ScaleMultiplier or 1) * fireballSizeMultiplier
		if args.DataProperties == nil then
			args.DataProperties = { DamageRadius = 320 }
		end
		args.DataProperties.DamageRadius = (args.DataProperties.DamageRadius or 320) * fireballSizeMultiplier
	end
	return baseFunc(args)
end)

-- Hermes x Ares
function mod.StartTrainSprintPhasing ( args, triggerArgs )
	SetPlayerPhasing("SprintMetaupgrade")
	CreateAnimation({ Name = args.Vfx, DestinationId = CurrentRun.Hero.ObjectId })
	thread( mod.CheckTrainSprintPhasingCollision, args )
end

function mod.CheckTrainSprintPhasingCollision( args )
	if HasThread( mod.StartTrainSprintPhasing ) then
		return
	end
	args = args or {}
	args.Cooldown = args.Cooldown or 0.5
	args.Range = args.Range or 150
	-- optimize by making version of OnUnitCollision that triggers even on phased units
	while SessionMapState.SprintActive do
		local ids = GetClosestIds({ Id = CurrentRun.Hero.ObjectId, DestinationName = "EnemyTeam", IgnoreHomingIneligible = true, Distance = args.Range, ScaleY = args.ScaleY})
		for _, id in pairs( ids ) do
			local enemy = ActiveEnemies[id]
			if enemy and enemy.ActivationFinished and CheckCooldown( id .. "SprintFreeze", args.Cooldown ) and enemy and not enemy.IsBoss and not enemy.IgnoreSprintPhasingStasisStun then
				local effectName = args.EffectName
				if effectName then
					thread( SprintPhasingUnitPresentation, enemy )
					thread( SprintPhasingMelPresentation, CurrentRun.Hero )
					ApplyEffect({ DestinationId = id, Id = CurrentRun.Hero.ObjectId, EffectName = effectName, DataProperties = EffectData[effectName].DataProperties })
				end
				if args.Interrupt then
					thread( TemporaryMuteStunImmunity, enemy, "OnSprintHitStun")
					CreateProjectileFromUnit({ Name = args.InterruptProjectile, Id = CurrentRun.Hero.ObjectId, DestinationId = id, FireFromTarget = true })
				end
			end
		end
		wait(0.1, "SprintPhasingCheck")
	end
end

function mod.EndTrainSprintPhasing ( args, triggerArgs )
	if args and args.CheckSprint and ConfigOptionCache.SprintAutoHold then
		return
	end
	if not ConfigOptionCache.SprintAutoHold and (( triggerArgs and triggerArgs.Canceled ) or ( args and args.CheckSprint and SessionMapState.SprintActive )) then
		return
	end
	SetPlayerUnphasing("SprintMetaupgrade")
	StopAnimation({ Name = "AresMelBuff", DestinationId = CurrentRun.Hero.ObjectId })
	killTaggedThreads( mod.StartTrainSprintPhasing )
end

function mod.CheckTrainStatis( victim, functionArgs, triggerArgs )
	if not SessionMapState.SprintActive or not SessionMapState.SprintStartTime or ( functionArgs.StartDelay and (_worldTimeUnmodified - SessionMapState.SprintStartTime) < functionArgs.StartDelay ) then
		return
	end
	if triggerArgs.EffectName == "SprintStasisEffect" and not triggerArgs.Reapplied then
		if victim.ActiveEffects then
			if victim.ActiveEffects[functionArgs.EffectName] then
				if victim and not victim.IsDead then
					thread( mod.AftermathProjectile, victim.ObjectId, functionArgs )
				end
			end
		end
	end
end

function mod.AftermathProjectile( enemyId, functionArgs )
	waitUnmodified( 0.05 )
	if enemyId and ActiveEnemies[enemyId] and not ActiveEnemies[enemyId].IsDead then
		CreateProjectileFromUnit({ Name = functionArgs.ProjectileName, Id = CurrentRun.Hero.ObjectId, DestinationId = enemyId })
		PlaySound({ Name = "/SFX/AresRendApply", Id = enemyId, ManagerCap = 46 })
		waitUnmodified( 0.10 )
		local angle = AngleTowardTarget({ Id = CurrentRun.Hero.ObjectId, DestinationId = enemyId })
		CreateAnimation({ Name = "AresMissingDamageFx", DestinationId = enemyId, Angle = angle }) -- nopkg
	end
end

function mod.CheckTrainKillDamage( enemy, traitArgs, triggerArgs )
	local totalPlasma = CurrentRun.CurrentRoom.BloodDropCount
	local totalChance = traitArgs.BaseChance + math.min(totalPlasma * traitArgs.PlasmaAddChance, 0.5)
	if not enemy or not enemy.ObjectId or enemy == CurrentRun.Hero then
		return
	end
	if not traitArgs.HitSimSlowParametersFalseTraitName or not HeroHasTrait( traitArgs.HitSimSlowParametersFalseTraitName ) then
		DoWeaponHitSimulationSlow( unit, triggerArgs, traitArgs )
	end
	if enemy.IsBoss or enemy.UseBossHealthBar or not RandomChance( totalChance * GetTotalHeroTraitValue( "LuckMultiplier", { IsMultiplier = true })) then
		return
	end
	local damageAmount = traitArgs.Damage
	thread( mod.DoTrainKillDamage, enemy, traitArgs, damageAmount )
	ShakeScreen({ Angle = 90, Distance = 6, Speed = 300, FalloffSpeed = 600, Duration = 0.25 })
	for i = 1, traitArgs.BloodDropAmount do
		CreateBloodDrop( enemy, traitArgs.BloodDropArgs )
	end
end

function mod.DoTrainKillDamage( enemy, traitArgs, damageAmount )
	wait(0.1, RoomThreadName )
	CreateAnimation({ Name = traitArgs.Vfx, DestinationId = enemy.ObjectId, Group = "FX_Standing_Top" })
	thread( mod.TrainKillPresentation, enemy )
	thread( Damage, enemy, { AttackerId = CurrentRun.Hero.ObjectId, AttackerTable = CurrentRun.Hero, SourceProjectile = "AresProjectile", DamageAmount = damageAmount, Silent = false, PureDamage = true, IgnoreHealthBuffer = true } )
end

function mod.TrainKillPresentation( unit )
	thread( PlayVoiceLines, GlobalVoiceLines.AresInstaKillVoiceLines, true )
	PlaySound({ Name = "/Leftovers/SFX/PlayerKilledNEW", Id = unit.ObjectId })
	if CheckCooldown( "SpawnKillPresentationCooldown", 1.0 ) then
		thread( InCombatText, CurrentRun.Hero.ObjectId, "AresTrain_CombatText", 0.75, { PreDelay = 0.25 } )
	end
end

modutil.mod.Path.Wrap("FormatExtractedValue", function(baseFunc, value, extractData)
	if extractData.PlasmaAddition and CurrentRun.CurrentRoom ~= nil then
		value = (value * (CurrentRun.CurrentRoom.BloodDropCount)) + GetTotalHeroTraitValue("ReportedBaseChance")
		value = math.min(value, 0.55)
	end
	return baseFunc(value, extractData)
end)