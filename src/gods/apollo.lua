-- Hermes x Apollo
gods.CreateBoon({
    pluginGUID = _PLUGIN.guid,
    characterName = "Apollo",
	internalBoonName = "CastWarZoneBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = true,
	reuseBaseIcons = true,

    displayName = "Golden Prodigy",
    description = "While in your {$Keywords.CastSet}, restore some {!Icons.Health} of any damage you deal with your {$Keywords.WeaponSet}.",
	StatLines = { "LifeRestorationStatDisplay1" },
    customStatLine = {
        Id = "LifeRestorationStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Life Restoration:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "ApolloCastBoon", "ApolloSprintBoon", "ApolloManaBoon" },
			{ "HermesWeaponBoon", "HermesSpecialBoon", "HermesCastDiscountBoon", "SorcerySpeedBoon" },
		},
	},
    boonIconPath = "Wistiti-HermesDuosBoonIcons\\ApolloHermesDuo",
	boonIconScale = 1.66,
    
	ExtractValues =
	{
        {
            Key = "ReportedLifeStealAmount",
            ExtractAs = "Lifesteal",
            Format = "Percent"
        },
	},

	ExtraFields = 
	{
		OnWeaponFiredFunctions =
		{
			ValidWeapons = WeaponSets.HeroNonPhysicalWeapons,
			FunctionName = _PLUGIN.guid .. "." .. "InsideCastHealPresentation",
			FunctionArgs =
			{
				Vfx = "HermesWingsBuff",
			},
		},
		OnEffectClearFunction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "EndInsideCastHealPresentation",
			FunctionArgs =
			{
				Vfx = "HermesWingsBuff",
			},
		},
        AddOutgoingLifestealModifiers =
		{
			ValidWeapons = WeaponSets.HeroPrimarySecondaryWeapons,
			ValidMultiplier = 0.01,
			MinLifesteal = 1,
			RequiredEffect = "InsideCastBuff",
			ReportValues = 
			{ 
				ReportedLifeStealAmount = "ValidMultiplier",
			},
		},
    },
})