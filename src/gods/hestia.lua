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