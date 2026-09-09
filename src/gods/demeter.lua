-- Hermes x Demeter
gods.CreateBoon({
    pluginGUID = _PLUGIN.guid,
    characterName = "Demeter",
	internalBoonName = "GustsOrbitBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = true,
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