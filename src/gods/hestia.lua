-- Hermes x Hestia
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hestia",
	internalBoonName = "FireballSprintBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = true,
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