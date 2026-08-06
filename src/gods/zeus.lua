-- Hermes x Zeus
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Zeus",
	internalBoonName = "ZappyFieldBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = true,
	reuseBaseIcons = true,

    displayName = "High Tension",
    description = "A {$Keywords.ModsWistitiMagnetic} is applied to {#BoldFormatGraft}1 {#Prev} foe in an {$Keywords.EncounterAlt} at all times.",
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
				Mininum = 1,
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