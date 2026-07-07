-- Hermes x Ares
gods.CreateBoon({
	pluginGUID = _PLUGIN.guid,
    characterName = "Ares",
	internalBoonName = "TrainKillBoon",
    isLegendary = false,
	InheritFrom = {
		"SynergyTrait",
	},
    addToExistingGod = true,
	reuseBaseIcons = true,

    displayName = "Train Wreck",
    description = "Whenever you {$Keywords.Sprint} through foes, deal {#BoldFormatGraft}30 {#Prev}damage, and possibly {$Keywords.ModsWistitiExecute} most foes.",
	StatLines = { "ATrainStatDisplay1" },
	TrayStatLines = { "ATrainStatDisplay2" },
    customStatLine = {
        {
			Id = "ATrainStatDisplay1",
			displayName = "{!Icons.Bullet}{#PropertyFormat}Instant Destruction Chance per Plasma:",
			description = "{#UpgradeFormat}+{$TooltipData.StatDisplay1}",
		},
		{
			Id = "ATrainStatDisplay2",
			displayName = "{!Icons.Bullet}{#PropertyFormat}Current Instant Destruction Chance:",
			description = "{#UpgradeFormat}{$TooltipData.ExtractData.PlasmaChanceAddition:P}",
		},
    },
	requirements =
	{
		OneFromEachSet =
		{
			{ "AresWeaponBoon", "AresSpecialBoon", "AresManaBoon", "BloodDropRevengeBoon" },
			{ "SorcerySpeedBoon", "SlowProjectileBoon" },
		},
	},
    boonIconPath = "GUI\\Screens\\BoonIcons\\Ares_45",
	--boonIconScale = 1.66,
    
	ExtractValues =
	{
		{
			Key = "ReportedPlasmaChanceMultiplier",
			ExtractAs = "Chance",
			Format = "LuckModifiedPercent",
			DecimalPlaces = 2,
			HideSigns = true,
		},
		{
			Key = "ReportedBaseChance",
			ExtractAs = "ExecuteBaseChance",
			SkipAutoExtract = true,
			DecimalPlaces = 2,
			Format = "LuckModifiedPercent",
			HideSigns = true,
		},
		{
			Key = "ReportedPlasmaChanceMultiplier",
			ExtractAs = "PlasmaChanceAddition",
			Format = "LuckModifiedPercent",
			PlasmaAddition = true,
			DecimalPlaces = 2,
			SkipAutoExtract = true,
			HideSigns = true,
		},
	},

	ExtraFields = 
	{
		SpeakerNames = { "Ares" },
		OnEffectApplyFunction =
		{
			FunctionName = _PLUGIN.guid .. "." .. "CheckTrainStatis",
			RunOnce = true,
			FunctionArgs = 
			{
				StartDelay = 0.2,
				Cooldown = 0.4,
				EffectName = "SprintStasisEffect", 
				ProjectileName = "AresTrainProjectile",
			}
		},
		OnEnemyDamagedAction =
		{
			ValidProjectiles = { "AresTrainProjectile" },
			FunctionName = _PLUGIN.guid .. "." .. "CheckTrainKillDamage",
			Args = 
			{
				BaseChance = 0.05,
				PlasmaAddChance = 0.005,
				Damage = 9999,
				Vfx = "RadialNovaPentagramCharged_Ares",
				HitSimSlowParametersFalseTraitName = "StaffRaiseDeadAspect",
				SimSlowDistanceThreshold = 180,
				HitSimSlowCooldown = 0.8,
				HitSimSlowParameters =
				{
					{ ScreenPreWait = 0.02, Fraction = 0.13, LerpTime = 0 },
					{ ScreenPreWait = 0.10, Fraction = 1.0, LerpTime = 0.05 },
				},
				BloodDropAmount = 3,
				BloodDropArgs = 
				{
					Name = "BloodDrop",
					DoubleChance = false,
					ReportValues = 
					{ 
						ReportedChance = "DoubleChance",
					},
				},
				ReportValues = { 
					ReportedBaseChance = "BaseChance",
					ReportedPlasmaChanceMultiplier = "PlasmaAddChance",
				},
			},
		},
		OnSprintStartAction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "StartTrainSprintPhasing",
			Args = 
			{
				EffectName = "SprintStasisEffect",
				--Interrupt = true,
				--InterruptProjectile = "ProjectileSprintStrike",
				Range = 120,
				ScaleY = 0.6,
				Cooldown = 0.5,
				Vfx = "AresMelBuff",
			}
		},
		OnSprintEndAction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "EndTrainSprintPhasing",
			Args =
			{
				Vfx = "AresMelBuff",
			},
		},
		TrayStatLines =
		{
			"ATrainStatDisplay2",
		},
    },
})