-- Hermes x Hera
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "OopsAllCursedBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 14 },
	reuseBaseIcons = true,

    displayName = "Royal Propagation",
    description = "Inflicting {$Keywords.Link} on foes applies every {$Keywords.Status} you can inflict using other abilities.",
	StatLines = { "CursePotencyDisplay1" },
    customStatLine = {
        Id = "CursePotencyDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Olympian Curse Potency:",
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
			Key = "ReportedCurseMultiplier",
			ExtractAs = "TooltipData",
			Format = "Percent",
		},
	},

	ExtraFields = 
	{
		CurseModifiers = {
			CursePotencyMultiplier = { BaseValue = 1.5 },
			ReportValues = { 
				ReportedCurseMultiplier = "CursePotencyMultiplier",
			},
		},
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
    addToExistingGod = { boonPosition = 15 },
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
    addToExistingGod = { boonPosition = 16 },
	reuseBaseIcons = true,

    displayName = "Hurricane Eye",
    description = "Your {$Keywords.Omega} create {#BoldFormatGraft}2 {#Prev}{$Keywords.ModsWistitiSlowFieldPlural} that orbit around you, but uses {#ManaFormat}+{$TooltipData.ExtractData.ManaCostAddition}{#Prev}{!Icons.Mana}.",
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
				GustDamage = 20, --description only
				ReportValues = { 
					ReportedGustDamage = "GustDamage",
				},
			},
		},
    },
})

-- Hermes x Apollo
--[[gods.CreateBoon({
    pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "CastTeleportBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 16 },
	reuseBaseIcons = true,

    displayName = "Luminous Warp",
    description = "Hold {$Keywords.Cast} to aim where the binding circle appears, and teleport there.",
	StatLines = { "BiggerCastStatDisplay1" },
    customStatLine = {
        Id = "BiggerCastStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Cast Size:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "DemeterWeaponBoon", "DemeterSpecialBoon", "DemeterCastBoon" },
			{ "DemeterSprintBoon", "CastNovaBoon" },
			{ "SlowExAttackBoon", "CastAttachBoon", "RootDurationBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Zeus_41",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
        {
            Key = "ReportedAreaMultiplier",
            ExtractAs = "Damage",
            Format = "PercentDelta"
        },
	},

	ExtraFields = 
	{
        PreEquipWeapons = { "WeaponTeleportCast" },
        GameStateRequirements =
		{
			{
				Path = { "CurrentRun", "Hero", "TraitDictionary", },
				HasNone = { "WeaponAnywhereCast", "CastProjectileBoon", "HadesCastProjectileBoon", "CastLobBoon", "SelfCastBoon" },
			},
		},
        OverrideWeaponFireNames =
		{
			RangedWeapon = "nil",
			WeaponTeleportCast = "WeaponCast",
		},
        WeaponDataOverride = 
		{
			WeaponCast = 
			{
				UnarmedCastCompleteGraphic = "nil",
				Sounds = 
				{
					FireSounds = 
					{
						{ Name = "/Leftovers/SFX/WyrmCastAttack" },
					}
				}
			}
		},
        SetupFunction =
		{
			Name = _PLUGIN.guid .. "." .. "SetupTeleportCast",
			RunOnce = true,
		},
		CastProjectileModifiers =
        {
            AreaIncrease =
            {
                CastSizeBonus = 1.3,
                SourceIsMultiplier = true,
				MinMultiplier = 0.1,
                IdenticalMultiplier =
				{
					Value = -0.75,
					DiminishingReturnsMultiplier = 0.75,
				},
            },
            ReportValues = { ReportedAreaMultiplier = "AreaIncrease"}
        },
		PropertyChanges =
		{
			{
				WeaponName = "WeaponCast",
				WeaponProperties = 
				{
					IgnoreOwnerAttackDisabled = true,
					Cooldown = 0,
					ChargeTime = 0,
					SelfVelocity = 0,
					FireGraphic = "null",
					AllowMultiFireRequest = true,
					RootOwnerWhileFiring = false,
					ChargeStartAnimation = "null",
					SetCompleteAngleOnFire = true,
					IgnoreForceCooldown = true,
					AllowExternalForceRelease = false,
					AddOnFire = "null",
				},
				ExcludeLinked = true,
			},
			{
				WeaponName = "WeaponTeleportCast",
				ProjectileProperty = "Damage",
				BaseValue = 0,
				ChangeType = "Absolute",
				ReportValues = { ReportedDamage = "ChangeValue" },
				IdenticalMultiplier =
				{
					Value = -0.6,
					MinMultiplier = 0.4,
				},
				ExcludeLinked = true,
			},
			{
				WeaponName = "WeaponCast",
				EffectName = "WeaponCastAttackDisable",
				EffectProperty = "Active",
				ChangeValue = false,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "WeaponCast",
				EffectName = "WeaponCastSelfSlow",
				EffectProperty = "Active",
				ChangeValue = false,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "WeaponCast",
				EffectName = "WeaponCastSelfSlow2",
				EffectProperty = "Active",
				ChangeValue = false,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "WeaponAxeSpin",
				WeaponProperty = "RemoveControlOnCharge",
				ChangeValue = "WeaponTeleportCast",
			},
			{
				WeaponName = "WeaponAxeSpin",
				WeaponProperty = "AddControlOnFireEnd",
				ChangeValue = "WeaponTeleportCast",
			},
			{
				WeaponName = "WeaponAxeSpecialSwing",
				WeaponProperty = "RemoveControlOnCharge",
				ChangeValue = "WeaponTeleportCast",
			},
			{
				WeaponName = "WeaponAxeSpecialSwing",
				WeaponProperty = "AddControlOnFire",
				ChangeValue = "WeaponTeleportCast",
			},
			{
				WeaponName = "WeaponAxeSpecialSwing",
				WeaponProperty = "AddControlOnChargeCancel",
				ChangeValue = "WeaponTeleportCast",
			}
		},
    },
})]]

-- Hermes x Hestia
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "FireballSprintBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 17 },
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
--[[gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hermes",
	internalBoonName = "TrainKillBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = { boonPosition = 18 },
	reuseBaseIcons = true,

    displayName = "Train Wreck",
    description = "Whenever you {$Keywords.Sprint} through foes, deal {#BoldFormatGraft}30 {#Prev} damage. You might also kill them outright...",
	StatLines = { "ATrainStatDisplay1" },
    customStatLine = {
        Id = "ATrainStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Instant Destruction Chance:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "AresWeaponBoon", "AresSepcialBoon", "AresManaBoon", "BloodDropRevengeBoon" },
			{ "SorcerySpeedBoon", "SlowProjectileBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Ares_45",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "ReportedChance",
			ExtractAs = "Chance",
			Format = "LuckModifiedPercent",
			HideSigns = true,
		},
	},

	ExtraFields = 
	{
		OnSprintAction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "TrainSprintOutcome",
			RunOnce = true,
			Args = 
			{
				Radius = 120,
				Range = 120,
				StartDelay = 0.2,
				Cooldown = 0.2,
				Vfx = "AresMelBuff",
				NumJumps = 1,
				ProjectileName = "HeraSprintProjectile",
				DamageMultiplier = { BaseValue = 1 },
				ReportValues = 
				{
					ReportedJumps = "NumJumps",
					ReportedMultiplier = "DamageMultiplier",
				}
			}
		},
		OnEnemyDamagedAction =
		{
			ValidProjectiles = { "HeraSprintProjectile" },
			FunctionName = _PLUGIN.guid .. "." .. "CheckTrainKillDamage",
			Args = 
			{
				Chance = 0.1,
				Damage = 9999,
				Vfx = "ZeusLightningIris",
				ReportValues = { ReportedChance = "Chance" },
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
			}
		},
		OnSprintEndAction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "EndTrainSprintPhasing",
		},
    },
})]]