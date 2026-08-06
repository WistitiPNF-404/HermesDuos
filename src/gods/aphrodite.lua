-- Hermes x Aphrodite
gods.CreateBoon({
    pluginGUID = _PLUGIN.guid,
    characterName = "Aphrodite",
	internalBoonName = "OnlyFansBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = true,
	reuseBaseIcons = true,

    displayName = "Adoration Fee",
    description = "Inflicting {$Keywords.Weak} on foes may {$Keywords.Charm} them, and any foes they strike gains you {#MoneyFormatBold}+5 {#Prev}{!Icons.Currency}.",
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