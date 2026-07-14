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
    description = "While you stand in your {$Keywords.CastSet}, restore some {!Icons.Health} of any damage you deal.",
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
    boonIconPath = "GUI\\Screens\\BoonIcons\\Zeus_41",
	--boonIconScale = 1.66,
    
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
			ValidMultiplier = 0.01,
			MinLifesteal = 1,
			RequiredEffect = "InsideCastBuff",
			Unmultiplied = true,
			ReportValues = 
			{ 
				ReportedLifeStealAmount = "ValidMultiplier",
			},
		},
    },
})