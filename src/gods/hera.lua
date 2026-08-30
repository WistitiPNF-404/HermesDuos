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
    boonIconPath = "Wistiti-HermesDuosBoonIcons\\HeraHermesDuo",
	boonIconScale = 1.66,
    
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
					BlindEffect = LinkedTraitData.ApolloBlindTraits,
					DelayedKnockbackEffect = { "MassiveKnockupBoon" },
					AresStatus = LinkedTraitData.AresRendTraits,
				},
				ConditionalOutgoingDamageMultipliers = 
				{
					{
						EffectName = "AresStatus",
						OutgoingDamageModifiers = 
						{
							ValidProjectilesLookup = { 
								"HeraCastDamageProjectile",
								"HeraSprintProjectile",
							},
							MissingEffectDamage = EffectData.AresStatus.BonusBaseDamageOnInflict,
							MissingEffectName = "AresStatus",
							MissingDamagePresentation = 
							{
								TextStartColor = Color.AresDamageLight,
								TextColor = Color.AresDamage,
								FunctionName = "AresRendApplyPresentation",
								HitSimSlowParametersFalseTraitName = "StaffRaiseDeadAspect",
								SimSlowDistanceThreshold = 180,
								HitSimSlowCooldown = 0.8,
								HitSimSlowParameters =
								{
									{ ScreenPreWait = 0.02, Fraction = 0.13, LerpTime = 0 },
									{ ScreenPreWait = 0.10, Fraction = 1.0, LerpTime = 0.05 },
								},
							},
						}
					}
				}
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
					BlindEffect = true,
					DelayedKnockbackEffect = true,
					-- AresStatus = true,
				},
			},
		},
    },
})