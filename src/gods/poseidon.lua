-- Hermes x Poseidon
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Poseidon",
	internalBoonName = "MoneyMoreDamageBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = true,
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