-- Hermes x Hephaestus
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hephaestus",
	internalBoonName = "MoneyToShieldBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = true,
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