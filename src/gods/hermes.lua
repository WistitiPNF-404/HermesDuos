-- Hermes x Zeus
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "ZappyFieldBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 14 },
	reuseBaseIcons = true,

    displayName = "High Tension",
    description = "Automatically apply a {$Keywords.ModsWistitiMagnetic} on {#BoldFormatGraft}1 {#Prev} foe in an {$Keywords.EncounterAlt} at all times.",
	StatLines = { "ZapDamageStatDisplay1" },
    customStatLine = {
        Id = "ZapDamageStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Chain-Lightning Damage:",
        description = "{#UpgradeFormat}{$TooltipData.ExtractData.ZapDamage}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "ZeusWeaponBoon", "ZeusSpecialBoon", "ZeusCastBoon", "ZeusSprintBoon", "ZeusManaBoon" },
			{ "HermesCastDiscountBoon", "SorcerySpeedBoon", "TimedKillBuffBoon" },
		},
	},
    boonIconPath = "Wistiti-HermesDuosBoonIcons\\ZeusHermesDuo",
	boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "ZapperDamage",
			ExtractAs = "ZapDamage",
			SkipAutoExtract = true,
		},
		{
			External = true,
			BaseType = "ProjectileBase",
			BaseName = "ProjectileZeusSpark",
			BaseProperty = "NumJumps",
			Format = "TotalTargets",
			ExtractAs = "Bounces",
			SkipAutoExtract = true,
		},
	},

	ExtraFields = 
	{
		ZapperDamage = 30, -- description only
		SetupFunction =
		{
			Threaded = true,
			Name = _PLUGIN.guid .. "." .. "MagnetifyCrowd",
			Args = 
			{
				Mininum = 2,
				ProjectileName = "ProjectileZeusSpark",
				FirstHitOnly = true,
				WindowCount = 3, -- "clip fire cooldown. no more than Count projectiles every Duration"
				WindowDuration = 0.75,
				ZappingDistance = 350,
				Cooldown = 0.5,
				ReportedValues = { 
					ReportedMinimum = "Minimum",
				},
			},
		},
    },
})

-- Hermes x Hera
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "PurgeRarifyBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 15 },
	reuseBaseIcons = true,

    displayName = "Sacrosanct Alms",
    description = "You can purge most rewards, and when you do, a random {$Keywords.GodBoon} you have gains {$Keywords.Rarity}.",
	StatLines = { "RarityAmountDisplay1" },
    customStatLine = {
        Id = "RarityAmountDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Rarity Increase:",
        description = "{#UpgradeFormat}+{$TooltipData.ExtractData.RarityAmount}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "DamageShareRetaliateBoon", "CommonGlobalDamageBoon", "BoonDecayBoon", "ElementalRarityUpgradeBoon" },
			{ "MoneyMultiplierBoon", "RestockBoon", "ElementalUnifiedBoon" },
		},
	},
    boonIconPath = "Wistiti-HermesDuosBoonIcons\\HeraHermesDuo",
	boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "RarityUpgrade",
			ExtractAs = "RarityAmount",
			SkipAutoExtract = true,
		},
	},

	ExtraFields = 
	{
		SpeakerNames = { "Hera" },
		RarityUpgrade = 1, --description only
		Permanent = true,
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
    boonIconPath = "Wistiti-HermesDuosBoonIcons\\PoseidonHermesDuo",
	boonIconScale = 1.66,
    
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
    boonIconPath = "Wistiti-HermesDuosBoonIcons\\DemeterHermesDuo",
	boonIconScale = 1.66,
    
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
				ProjectileCap = 3,
				GustDamage = 5, --description only
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
    description = "While in your {$Keywords.CastSet}, restore some {!Icons.Health} of any damage you deal with your {$Keywords.WeaponSet}.",
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
    boonIconPath = "Wistiti-HermesDuosBoonIcons\\ApolloHermesDuo",
	boonIconScale = 1.66,
    
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
			ValidWeapons = WeaponSets.HeroPrimarySecondaryWeapons,
			ValidMultiplier = 0.01,
			MinLifesteal = 1,
			RequiredEffect = "InsideCastBuff",
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

    displayName = "Adoration Fee",
    description = "Inflicting {$Keywords.Weak} may temporarily {$Keywords.Charm} most foes, and their strikes gain you {#MoneyFormatBold}+5 {#Prev}{!Icons.Currency}.",
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
			{ "DodgeChanceBoon", "MoneyMultiplierBoon", "RestockBoon", "LuckyBoon" },
		},
	},
    boonIconPath = "Wistiti-HermesDuosBoonIcons\\AphroHermesDuo",
	boonIconScale = 1.66,
    
	ExtractValues =
	{
        {
			Key = "ReportedCharmChance",
			ExtractAs = "CharmChance",
			Format = "LuckModifiedPercent",
			HideSigns = true,
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
		OnDamageEnemyFunction =
		{
			FunctionName = _PLUGIN.guid .. "." .. "CharmHitCheck",
			FunctionArgs =
			{
				GoldAddition = 5,
				ReportValues = { ReportedGoldBonus = "GoldAddition" },
			},
		},
		--TransformToMoneyChance = { BaseValue = 0.5 },
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
        displayName = "{!Icons.Bullet}{#PropertyFormat}Cost per Armor Point:",
        description = "{#MoneyFormatBold}-{$TooltipData.ExtractData.TooltipArmorGain}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "HeavyArmorBoon", "ArmorBoon", "EncounterStartDefenseBuffBoon" },
			{ "SlowProjectileBoon", "MoneyMultiplierBoon", "RestockBoon" },
		},
	},
    boonIconPath = "Wistiti-HermesDuosBoonIcons\\HephHermesDuo",
	boonIconScale = 1.66,
    
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
        description = "{#UpgradeFormat}{$TooltipData.ExtractData.FireballDamage}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "CastProjectileBoon", "FireballManaSpecialBoon" },
			{ "SprintShieldBoon", "SorcerySpeedBoon", "SlowProjectileBoon" },
		},
	},
    boonIconPath = "Wistiti-HermesDuosBoonIcons\\HestiaHermesDuo",
	boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "FireballSprintDamage",
			ExtractAs = "FireballDamage",
			SkipAutoExtract = true,
		},
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
		FireballSprintDamage = 80, -- for description only
		OnWeaponFiredFunctions =
		{
			ValidWeapons =  {"WeaponSprint"},
			FunctionName = _PLUGIN.guid .. "." .. "FireballSprintSetup",
			FunctionArgs =
			{
				ProjectileName = "ProjectileSprintFireball",
				DamageMultiplier = 1,
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
			{ "SprintShieldBoon", "SorcerySpeedBoon", "TimedKillBuffBoon" },
		},
	},
    boonIconPath = "Wistiti-HermesDuosBoonIcons\\AresHermesDuo",
	boonIconScale = 1.66,
    
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