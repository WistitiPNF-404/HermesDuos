-- Hermes x Zeus
--[[gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "TeleportBurstBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 14 },
	reuseBaseIcons = true,

    displayName = "Zap Dart",
    description = "You may {$Keywords.Cast} again to teleport to your binding circle, and unleash a burst attack when reappearing.",
	StatLines = { "GoldenRatioStatDisplay1" },
    customStatLine = {
        Id = "SuperSpeedDurationStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Bonus Speed Duration:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "PoseidonCastBoon", "PoseidonSprintBoon", "PoseidonManaBoon" },
			{ "MoneyMultiplierBoon", "TimedKillBuffBoon", "RestockBoon" },
			{ "RoomRewardBonusBoon", "DoubleRewardBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Zeus_43",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "ReportedReduction",
			ExtractAs = "TooltipData",
			Format = "Percent",
		},
	},

	ExtraFields = 
	{
		OnSprintAction =
		{
			FunctionName = _PLUGIN.guid .. "." .. "OnZapDashStart",
			RunOnce = true,
			Args = 
			{
				SpeedMultiplier = { BaseValue = 10, SourceIsMultiplier = true },
				ZapBuffDuration = 0.5,
			},
		},
		PropertyChanges =
		{
			{
				WeaponNames = WeaponSets.HeroBlinkWeapons,
				WeaponProperty = "BlinkDuration",
				BaseValue = 0.2,
				SourceIsMultiplier = true,
				DecimalPlaces = 3,
				ChangeType = "Multiply",
				ReportValues = { ReportedReduction = "ChangeValue"},
			},
		},
    },
})]]

-- Hermes x Hera
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "OopsAllCursedBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 15 },
	reuseBaseIcons = true,

    displayName = "Royal Propagation",
    description = "Inflicting {$Keywords.Link} on foes applies every {$Keywords.Status} you can inflict using other abilities.",
	StatLines = { "CursePotencyDisplay1" },
    customStatLine = {
        Id = "CursePotencyDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Bonus {$Keywords.Link} Damage:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "HeraWeaponBoon", "HeraSpecialBoon", "HeraCastBoon", "HeraSprintBoon" },
			{ "HermesWeaponBoon", "HermesSpecialBoon", "TimedKillBuffBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Apollo_44",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "DamageShareAmountIncrease",
			ExtractAs = "TooltipAmount",
			Format = "Percent",
		},
		{
			ExtractAs = "DamageShareDuration",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "DamageShareEffect",
			BaseProperty = "Duration",
		},
		{
			ExtractAs = "DamageShareAmount",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "DamageShareEffect",
			BaseProperty = "Amount",
			Format = "Percent",
		},
	},

	ExtraFields = 
	{
		DamageShareAmountIncrease = { BaseValue = 0.2 },
		SetupFunction = 
		{
			Name = "BuildValidEffects",
			Args = 
			{
				StatusTraitNames = 
				{
					DamageEchoEffect = LinkedTraitData.ZeusEchoTraits,
					BurnEffect = LinkedTraitData.HestiaBurnTraits,
					ChillEffect = LinkedTraitData.DemeterRootTraits,
					LegacyChillEffect = { "DemeterSprintBoon", "CastNovaBoon", "StormSpawnBoon" },
					AmplifyKnockbackEffect = { "PoseidonStatusBoon", "PoseidonCastBoon" },
					WeakEffect = LinkedTraitData.AphroditeWeakTraits,
					DamageShareEffect = LinkedTraitData.HeraLinkTraits,
					BlindEffect = LinkedTraitData.ApolloBlindTraits,
					DelayedKnockbackEffect = { "MassiveKnockupBoon" },
				},
			},
		},
		OnEffectApplyFunction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "HitchCopyStatus",
			FunctionArgs = 
			{
				ValidStatusNames = 
				{
					DamageEchoEffect = true,
					BurnEffect = "ApplyBurn",
					ChillEffect = "ApplyRoot",
					LegacyChillEffect = true,
					AmplifyKnockbackEffect = true,
					WeakEffect = "ApplyAphroditeVulnerability",
					DamageShareEffect = "ApplyDamageShare",
					BlindEffect = true,
					DelayedKnockbackEffect = true,
				},
			},
		},
    },
})

-- Hermes x Poseidon
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "MoneyMoreDamageBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 16 },
	reuseBaseIcons = true,

    displayName = "Gilded Hook",
    description = "You deal more damage the more {!Icons.Currency} you have.",
	StatLines = { "GoldenRatioStatDisplay1" },
    customStatLine = {
        Id = "GoldenRatioStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Bonus Damage per 100 Gold:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "PoseidonCastBoon", "PoseidonSprintBoon", "PoseidonManaBoon" },
			{ "MoneyMultiplierBoon", "TimedKillBuffBoon", "RestockBoon" },
			{ "RoomRewardBonusBoon", "DoubleRewardBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Poseidon_44",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "ReportedMultiplier",
			ExtractAs = "TooltipData",
			Format = "Percent",
		},
	},

	ExtraFields = 
	{
		InflationIndex = 100,
		AddOutgoingDamageModifiers =
		{
			GoldMultiplier = 0.05,
			ReportValues = { 
				ReportedMultiplier = "GoldMultiplier",
			},
		},
    },
})

-- Hermes x Demeter
gods.CreateBoon({
    pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "GustsOrbitBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 17 },
	reuseBaseIcons = true,

    displayName = "Hurricane Eye",
    description = "Your {$Keywords.Omega} create {$Keywords.ModsWistitiSlowFieldPlural} that orbit around you, but use {#ManaFormat}+{$TooltipData.ExtractData.ManaCostAddition}{#Prev}{!Icons.Mana}.",
	StatLines = { "GustOrbitStatDisplay1" },
    customStatLine = {
        Id = "GustOrbitStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Gust Area Damage:",
        description = "{#UpgradeFormat}{$TooltipData.ExtractData.GustDamage} {#Prev}{#ItalicFormat}(every 0.25 Sec.)",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "DemeterSprintBoon", "CastNovaBoon" },
			{ "HermesCastDiscountBoon", "SlowProjectileBoon", "DodgeChanceBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Apollo_41",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "ReportedGustDamage",
			ExtractAs = "GustDamage",
			SkipAutoExtract = true,
		},
		{
            ExtractAs = "ProjectileSlow",
            External = true,
            BaseType = "ProjectileBase",
            BaseName = "DemeterSprintDefense",
            BaseProperty = "SpeedMultiplierOfEnemyProjectilesInside",
            Format = "NegativePercentDelta",
            SkipAutoExtract = true,
        },
        {
            ExtractAs = "Duration",
            External = true,
            BaseType = "ProjectileBase",
            BaseName = "DemeterOmegaStorm",
            BaseProperty = "TotalFuse",
            DecimalPlaces = 2,
            SkipAutoExtract = true,
        },
        {
            ExtractAs = "Fuse",
            External = true,
            BaseType = "ProjectileBase",
            BaseName = "DemeterOmegaStorm",
            BaseProperty = "Fuse",
            DecimalPlaces = 2,
            SkipAutoExtract = true,
        },
        {
            ExtractAs = "ChillAmount",
            SkipAutoExtract = true,
            External = true,
            BaseType = "EffectData",
            BaseName = "LegacyChillEffect",
            BaseProperty = "ElapsedTimeMultiplier",
            Format = "NegativePercentDelta",
        },
        {
            ExtractAs = "ChillDuration",
            SkipAutoExtract = true,
            External = true,
            BaseType = "EffectData",
            BaseName = "LegacyChillEffect",
            BaseProperty = "Duration",
        },
        {
            Key = "ReportedCost",
            ExtractAs = "ManaCostAddition",
            IncludeSigns = true,
            SkipAutoExtract = true,
        },
	},

	ExtraFields = 
	{
		ManaCostModifiers = 
		{
			WeaponNames = ConcatTableValues(WeaponSets.HeroAllWeaponsAndSprint, {"WeaponCastProjectileHades", "WeaponAnywhereCast", "WeaponCastProjectile", "WeaponCastLob" }),
			ExWeapons = true,
			ManaCostAdd = 10,
			ReportValues = 
			{ 
				ReportedCost = "ManaCostAdd" 
			},
		},
        OnEnemyDamagedAction = 
		{
			ValidProjectiles = { "DemeterOmegaStorm" },
			EffectName = "LegacyChillEffect",
		},
		OnWeaponFiredFunctions =
		{
			WeaponNames = ConcatTableValues(WeaponSets.HeroAllWeaponsAndSprint, {"WeaponCastProjectileHades", "WeaponAnywhereCast", "WeaponCastProjectile", "WeaponCastLob" }),	
			FunctionName = _PLUGIN.guid .. "." .. "CreateOmegaGusts",
			FunctionArgs = 
			{
				ProjectileName = "DemeterOmegaStorm",
                NumProjectiles = 2,
				GustDamage = 10, --description only
				ReportValues = { 
					ReportedGustDamage = "GustDamage",
				},
			},
		},
    },
})

-- Hermes x Apollo
gods.CreateBoon({
    pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "CastWarZoneBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 18 },
	reuseBaseIcons = true,

    displayName = "Golden Prodigy",
    description = "While you stand in your {$Keywords.CastSet}, restore some {!Icons.Health} of any damage you deal.",
	StatLines = { "LifeRestorationStatDisplay1" },
    customStatLine = {
        Id = "LifeRestorationStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Life Restoration:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "ApolloCastBoon", "ApolloSprintBoon", "ApolloManaBoon" },
			{ "HermesWeaponBoon", "HermesSpecialBoon", "HermesCastDiscountBoon", "SorcerySpeedBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Zeus_41",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
        {
            Key = "ReportedLifeStealAmount",
            ExtractAs = "Lifesteal",
            Format = "Percent"
        },
	},

	ExtraFields = 
	{
		OnWeaponFiredFunctions =
		{
			ValidWeapons = WeaponSets.HeroNonPhysicalWeapons,
			FunctionName = _PLUGIN.guid .. "." .. "InsideCastHealPresentation",
			FunctionArgs =
			{
				Vfx = "HermesWingsBuff",
			},
		},
		OnEffectClearFunction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "EndInsideCastHealPresentation",
			FunctionArgs =
			{
				EffectName = "InsideCastBuff",
				Vfx = "HermesWingsBuff",
			},
		},
        AddOutgoingLifestealModifiers =
		{
			ValidMultiplier = 0.01,
			MinLifesteal = 1,
			RequiredEffect = "InsideCastBuff",
			Unmultiplied = true,
			ReportValues = 
			{ 
				ReportedLifeStealAmount = "ValidMultiplier",
			},
		},
    },
})

-- Hermes x Aphrodite
gods.CreateBoon({
    pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "OnlyFansBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 19 },
	reuseBaseIcons = true,

    displayName = "Fanatic Exclusivity",
    description = "Inflicting {$Keywords.Weak} on foes may {$Keywords.Charm} them. Any foes they strike gains you {#MoneyFormatBold}+5 {#Prev}{!Icons.Currency}.",
	StatLines = { "CharmChanceStatDisplay1" },
    customStatLine = {
        Id = "CharmChanceStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Charm Chance:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "AphroditeCastBoon", "AphroditeSprintBoon", "AphroditeManaBoon" },
			{ "HermesWeaponBoon", "HermesSpecialBoon", "HermesCastDiscountBoon", "SorcerySpeedBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Apollo_42",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
        {
			Key = "ReportedCharmChance",
			ExtractAs = "CharmChance",
			Format = "LuckModifiedPercent",
		},
		{
			ExtractAs = "TooltipWeakDuration",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "WeakEffect",
			BaseProperty = "Duration",
		},
		{
			ExtractAs = "TooltipWeakModifier",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "WeakEffect",
			BaseProperty = "Modifier",
			Format = "NegativePercentDelta"
		},
	},

	ExtraFields = 
	{
		OnEffectApplyFunction =
		{
			FunctionName = _PLUGIN.guid .. "." .. "WeakToCharmChance",
			FunctionArgs =
			{
				CharmChance = 0.25,
				EffectName = "Charm",
				ReportValues = { ReportedCharmChance = "CharmChance" },
			},
		},
		CharmDataModifiers =
		{
			OnHitGoldModifiers =
			{
				GoldAddition = 5,
				ReportValues = { ReportedGoldBonus = "GoldAddition" },
			},
		},
    },
})

-- Hermes x Hephaestus
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "MoneyToShieldBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 20 },
	reuseBaseIcons = true,

    displayName = "Sturdy Investment",
    description = "You gain {!Icons.ArmorTotal} upon spending or losing {!Icons.Currency}.",
	StatLines = { "ArmorCostStatDisplay1" },
    customStatLine = {
        Id = "ArmorCostStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Cost per Armor Point Gained:",
        description = "{#MoneyFormatBold}-{$TooltipData.ExtractData.TooltipArmorGain}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "HephaestusWeaponBoon", "HephaestusSpecialBoon", "HephaestusCastBoon", "HephaestusSprintBoon", "HephaestusManaBoon" },
			{ "HermesCastDiscountBoon", "SorcerySpeedBoon", "SlowProjectileBoon" },
			{ "HeavyArmorBoon", "ArmorBoon", "EncounterStartDefenseBuffBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Apollo_43",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "ReportedMultiplier",
			SkipAutoExtract = true,
			ExtractAs = "TooltipArmorGain",
		},
	},

	ExtraFields = 
	{
		GoldtoArmorData = 
		{
			GoldCost = 5,
			ArmorGain = 1,
			ReportValues = { ReportedMultiplier = "GoldCost" },
		},
    },
})

-- Hermes x Hestia
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "FireballSprintBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 21 },
	reuseBaseIcons = true,

    displayName = "Aerobic Capacity",
    description = "Whenever you stop {$Keywords.DashSet}, launch a fireball. All your fireballs are {#BoldFormatGraft}100% {#Prev}larger.",
	StatLines = { "FireballRushStatDisplay1" },
    customStatLine = {
        Id = "FireballRushStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Fireball Blast Damage:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "CastProjectileBoon", "FireballManaSpecialBoon" },
			{ "HermesCastDiscountBoon", "SorcerySpeedBoon", "SlowProjectileBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Ares_48",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "ReportedMultiplier",
			ExtractAs = "Damage",
			Format = "MultiplyByBase",
			BaseType = "Projectile",
			BaseName = "ProjectileFireball",
			BaseProperty = "Damage",
		},
		{
			Key = "ReportedFireballSizeMultiplier",
			ExtractAs = "FireballSizeMultiplier",
			Format = "PercentDelta",
		},
	},

	ExtraFields = 
	{
		FireballModifiers = {
			FireballSizeMultiplier = { BaseValue = 2 },
			ReportValues = { 
				ReportedFireballSizeMultiplier = "FireballSizeMultiplier"
			},
		},
		PropertyChanges =
		{
			{
				WeaponName = "WeaponCastProjectile",
				ProjectileProperty = "Scale",
				ChangeValue = 2,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "WeaponCastProjectile",
				WeaponProperty = "ProjectileScaleMultiplier",
				ChangeValue = 2,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "WeaponCastProjectile",
				WeaponProperty = "BlastRadiusMultiplier",
				ChangeValue = 1.25,
				ChangeType = "Absolute",
			},
		},
		OnWeaponFiredFunctions =
		{
			ValidWeapons =  {"WeaponSprint"},
			FunctionName = _PLUGIN.guid .. "." .. "FireballSprintSetup",
			FunctionArgs =
			{
				ProjectileName = "ProjectileSprintFireball",
				DamageMultiplier = 2.5,
				ReportValues = 
				{
					ReportedMultiplier = "DamageMultiplier",
				}
			},
		},
		OnSprintEndAction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "FireballSprintLaunch",
		},
    },
})

-- Hermes x Ares
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "TrainKillBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 22 },
	reuseBaseIcons = true,

    displayName = "Train Wreck",
    description = "Whenever you {$Keywords.Sprint} through foes, deal {#BoldFormatGraft}30 {#Prev}damage, and possibly {$Keywords.ModsWistitiExecute} most foes.",
	StatLines = { "ATrainStatDisplay1" },
	TrayStatLines = { "ATrainStatDisplay2" },
    customStatLine = {
        {
			Id = "ATrainStatDisplay1",
			displayName = "{!Icons.Bullet}{#PropertyFormat}Instant Destruction Chance per Plasma:",
			description = "{#UpgradeFormat}+{$TooltipData.StatDisplay1}",
		},
		{
			Id = "ATrainStatDisplay2",
			displayName = "{!Icons.Bullet}{#PropertyFormat}Current Instant Destruction Chance:",
			description = "{#UpgradeFormat}{$TooltipData.ExtractData.PlasmaChanceAddition:P}",
		},
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "AresWeaponBoon", "AresSpecialBoon", "AresManaBoon", "BloodDropRevengeBoon" },
			{ "SorcerySpeedBoon", "SlowProjectileBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Ares_45",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "ReportedPlasmaChanceMultiplier",
			ExtractAs = "Chance",
			Format = "LuckModifiedPercent",
			DecimalPlaces = 2,
			HideSigns = true,
		},
		{
			Key = "ReportedBaseChance",
			ExtractAs = "ExecuteBaseChance",
			SkipAutoExtract = true,
			DecimalPlaces = 2,
			Format = "LuckModifiedPercent",
			HideSigns = true,
		},
		{
			Key = "ReportedPlasmaChanceMultiplier",
			ExtractAs = "PlasmaChanceAddition",
			Format = "LuckModifiedPercent",
			PlasmaAddition = true,
			DecimalPlaces = 2,
			SkipAutoExtract = true,
			HideSigns = true,
		},
	},

	ExtraFields = 
	{
		AcquireFunctionName = "SetupBloodDropDisplay",
		OnExpire = { FunctionName = "CheckBloodDropDisplay", },
		SpeakerNames = { "Ares" },
		OnEffectApplyFunction =
		{
			FunctionName = _PLUGIN.guid .. "." .. "CheckTrainStatis",
			RunOnce = true,
			FunctionArgs = 
			{
				StartDelay = 0.2,
				Cooldown = 0.4,
				EffectName = "SprintStasisEffect", 
				ProjectileName = "AresTrainProjectile",
			}
		},
		OnEnemyDamagedAction =
		{
			ValidProjectiles = { "AresTrainProjectile" },
			FunctionName = _PLUGIN.guid .. "." .. "CheckTrainKillDamage",
			Args = 
			{
				BaseChance = 0.05,
				PlasmaAddChance = 0.005,
				Damage = 9999,
				Vfx = "RadialNovaPentagramCharged_Ares",
				HitSimSlowParametersFalseTraitName = "StaffRaiseDeadAspect",
				SimSlowDistanceThreshold = 180,
				HitSimSlowCooldown = 0.8,
				HitSimSlowParameters =
				{
					{ ScreenPreWait = 0.02, Fraction = 0.13, LerpTime = 0 },
					{ ScreenPreWait = 0.10, Fraction = 1.0, LerpTime = 0.05 },
				},
				BloodDropAmount = 3,
				BloodDropArgs = 
				{
					Name = "BloodDrop",
					DoubleChance = false,
					ReportValues = 
					{ 
						ReportedChance = "DoubleChance",
					},
				},
				ReportValues = { 
					ReportedBaseChance = "BaseChance",
					ReportedPlasmaChanceMultiplier = "PlasmaAddChance",
				},
			},
		},
		OnSprintStartAction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "StartTrainSprintPhasing",
			Args = 
			{
				EffectName = "SprintStasisEffect",
				--Interrupt = true,
				--InterruptProjectile = "ProjectileSprintStrike",
				Range = 120,
				ScaleY = 0.6,
				Cooldown = 0.5,
				Vfx = "AresMelBuff",
			}
		},
		OnSprintEndAction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "EndTrainSprintPhasing",
			Args =
			{
				Vfx = "AresMelBuff",
			},
		},
		TrayStatLines =
		{
			"ATrainStatDisplay2",
		},
    },
})

--[[gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "InstantDashBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 14 },
	reuseBaseIcons = true,

    displayName = "Zap Dart",
    description = "Your {$Keywords.Dash} travels instantly, and run {#BoldFormatGraft}+100% {#Prev} faster at the start of your {$Keywords.Sprint}.",
	StatLines = { "GoldenRatioStatDisplay1" },
    customStatLine = {
        Id = "SuperSpeedDurationStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Bonus Speed Duration:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "PoseidonCastBoon", "PoseidonSprintBoon", "PoseidonManaBoon" },
			{ "MoneyMultiplierBoon", "TimedKillBuffBoon", "RestockBoon" },
			{ "RoomRewardBonusBoon", "DoubleRewardBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Zeus_43",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "ReportedReduction",
			ExtractAs = "TooltipData",
			Format = "Percent",
		},
	},

	ExtraFields = 
	{
		OnSprintAction =
		{
			FunctionName = _PLUGIN.guid .. "." .. "OnZapDashStart",
			RunOnce = true,
			Args = 
			{
				SpeedMultiplier = { BaseValue = 10, SourceIsMultiplier = true },
				ZapBuffDuration = 0.5,
			},
		},
		PropertyChanges =
		{
			{
				WeaponNames = WeaponSets.HeroBlinkWeapons,
				WeaponProperty = "BlinkDuration",
				BaseValue = 0.2,
				SourceIsMultiplier = true,
				DecimalPlaces = 3,
				ChangeType = "Multiply",
				ReportValues = { ReportedReduction = "ChangeValue"},
			},
			--[[{
				WeaponNames = { "WeaponSprint" },
				WeaponProperty = "SelfVelocity",
				BaseValue = 1980,
				ChangeType = "Add",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "WeaponSprint" },
				WeaponProperty = "SelfVelocityCap",
				BaseValue = 890,
				ChangeType = "Add",
				ExcludeLinked = true,
			},
			{
				WeaponName = "WeaponSprint",
				EffectName = "ChaosControl",
				EffectProperty = "Active",
				ChangeValue = true,
				ExcludeLinked = true,
			},
		},
    },
})]]