-- Hermes x Hera
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hera",
	internalBoonName = "PurgeRarifyBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = true,
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