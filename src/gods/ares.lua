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
    description = "Whenever you {$Keywords.Sprint} through foes, deal {#BoldFormatGraft}30 {#Prev}damage with a chance to {$Keywords.ModsWistitiExecute} susceptible foes.",
	StatLines = { "ATrainStatDisplay1" },
    customStatLine = {
        Id = "ATrainStatDisplay1",
        displayName = "{!Icons.Bullet}{#PropertyFormat}Instant Destruction Chance per Plasma:",
        description = "{#UpgradeFormat}{$TooltipData.StatDisplay1}",
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
			Key = "ReportedChance",
			ExtractAs = "Chance",
			Format = "LuckModifiedPercent",
			HideSigns = true,
		},
	},

	ExtraFields = 
	{
		SpeakerNames = { "Ares" },
		OnSprintAction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "TrainSprintOutcome",
			RunOnce = true,
			Args = 
			{
				Radius = 120,
				Range = 120,
				StartDelay = 0.2,
				Cooldown = 0.35,
				NumJumps = 1,
				ProjectileName = "AresTrainProjectile",
				DamageMultiplier = { BaseValue = 1 },
				ReportValues = 
				{
					ReportedJumps = "NumJumps",
					ReportedMultiplier = "DamageMultiplier",
				}
			}
		},
		OnEnemyDamagedAction =
		{
			ValidProjectiles = { "AresTrainProjectile" },
			FunctionName = _PLUGIN.guid .. "." .. "CheckTrainKillDamage",
			Args = 
			{
				Chance = 0.05,
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
				ReportValues = { ReportedChance = "Chance" },
			},
		},
		OnSprintStartAction = 
		{
			FunctionName = _PLUGIN.guid .. "." .. "StartTrainSprintPhasing",
			Args = 
			{
				EffectName = "SprintStasisEffect",
				Interrupt = true,
				InterruptProjectile = "ProjectileSprintStrike",
				Range = 120,
				ScaleY = 0.6,
				Cooldown = 0.35,
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
    },
})