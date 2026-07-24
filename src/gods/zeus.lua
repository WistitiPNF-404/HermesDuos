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
        displayName = "{!Icons.Bullet}{#PropertyFormat}Chain-lightning Damage:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "ZeusWeaponBoon", "ZeusSpecialBoon", "ZeusCastBoon", "ZeusSprintBoon", "ZeusManaBoon" },
			{ "MoneyMultiplierBoon", "TimedKillBuffBoon", "RestockBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Zeus_45",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			External = true,
			ExtractAs = "Damage",
			BaseType = "ProjectileBase",
			BaseName = "ProjectileZeusSpark",
			BaseProperty = "Damage",
		},
	},

	ExtraFields = 
	{
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
				ZappingDistance = 300,
				Cooldown = 0.5,
				ReportedValues = { 
					ReportedMinimum = "Minimum",
				},
			},
		},
    },
})