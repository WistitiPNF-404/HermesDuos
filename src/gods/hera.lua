-- Hermes x Hera
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Hera",
	internalBoonName = "OopsAllCursedBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = true,
	reuseBaseIcons = true,

    displayName = "Royal Decree",
    description = "Inflicting {$Keywords.Link} on foes applies every {$Keywords.Status} you can inflict using other abilities.",
	StatLines = { "CursePotencyDisplay1" },
    customStatLine = {
        Id = "CursePotencyDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Bonus {$Keywords.Link} Damage:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "HeraWeaponBoon", "HeraSpecialBoon", "HeraCastBoon", "HeraSprintBoon" },
			{ "HermesWeaponBoon", "HermesSpecialBoon", "TimedKillBuffBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Apollo_44",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "DamageShareAmountIncrease",
			ExtractAs = "TooltipAmount",
			Format = "Percent",
		},
		{
			ExtractAs = "DamageShareDuration",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "DamageShareEffect",
			BaseProperty = "Duration",
		},
		{
			ExtractAs = "DamageShareAmount",
			SkipAutoExtract = true,
			External = true,
			BaseType = "EffectData",
			BaseName = "DamageShareEffect",
			BaseProperty = "Amount",
			Format = "Percent",
		},
	},

	ExtraFields = 
	{
		DamageShareAmountIncrease = { BaseValue = 0.2 },
		SetupFunction = 
		{
			Name = "BuildValidEffects",
			Args = 
			{
				StatusTraitNames = 
				{
					DamageEchoEffect = LinkedTraitData.ZeusEchoTraits,
					BurnEffect = LinkedTraitData.HestiaBurnTraits,
					ChillEffect = LinkedTraitData.DemeterRootTraits,
					LegacyChillEffect = { "DemeterSprintBoon", "CastNovaBoon", "StormSpawnBoon" },
					AmplifyKnockbackEffect = { "PoseidonStatusBoon", "PoseidonCastBoon" },
					WeakEffect = LinkedTraitData.AphroditeWeakTraits,
					DamageShareEffect = LinkedTraitData.HeraLinkTraits,
					BlindEffect = LinkedTraitData.ApolloBlindTraits,
					DelayedKnockbackEffect = { "MassiveKnockupBoon" },
				},
			},
		},
		OnEffectApplyFunction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "HitchCopyStatus",
			FunctionArgs = 
			{
				ValidStatusNames = 
				{
					DamageEchoEffect = true,
					BurnEffect = "ApplyBurn",
					ChillEffect = "ApplyRoot",
					LegacyChillEffect = true,
					AmplifyKnockbackEffect = true,
					WeakEffect = "ApplyAphroditeVulnerability",
					DamageShareEffect = "ApplyDamageShare",
					BlindEffect = true,
					DelayedKnockbackEffect = true,
				},
			},
		},
    },
})