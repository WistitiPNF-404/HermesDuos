---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

-- These are some sample code snippets of what you can do with our modding framework:
modutil.mod.Path.Wrap("SetupMap", function(base, ...)
	prefix_SetupMap()
	return base(...)
end)

local HelpTextFile = rom.path.combine(rom.paths.Content, "Game/Text/en/HelpText.en.sjson")
local Order = { "Id", "InheritFrom", "DisplayName", "Description" }

local newKeywords = {
	"ModsWistitiSlowFieldPlural",
	"ModsWistitiExecute",
	"ModsWistitiMagnetic",
}
game.ConcatTableValuesIPairs(game.KeywordList, newKeywords)

mod.GustPlural = sjson.to_object({
	Id = "ModsWistitiSlowFieldPlural",
	InheritFrom = "SlowField",
	DisplayName = "Gusts",
	Description = "{#ItalicBoldFormat}{$Keywords.Status}: {#Prev}Afflicted foes are {#BoldFormat}{$TooltipData.ExtractData.ChillAmount}% {#Prev}slower, and their ranged shots {$TooltipData.ExtractData.ProjectileSlow:F} slower. Lasts {#BoldFormatGraft}{$TooltipData.ExtractData.Duration} Sec.",
}, Order)

mod.ExecuteStatus = sjson.to_object({
	Id = "ModsWistitiExecute",
	DisplayName = "Execute",
	Description = "Susceptible foes have a {#BoldFormat}{$TooltipData.ExtractData.ExecuteBaseChance}% {#Prev} chance to be destroyed outright, dropping {#BoldFormat}3 {#Prev}{!Icons.BloodDropWithCountIcon} when slained. Outcome increases with your current {!Icons.BloodDropWithCountIcon} count.",
}, Order)

mod.MagneticField = sjson.to_object({
	Id = "ModsWistitiMagnetic",
	DisplayName = "Magnetic Field",
	Description = "An area that surrounds a single foe, unleashing chain-lightning upon any foes who dare draw near.",
}, Order)

mod.AresTrainBoon_CombatText = sjson.to_object({
	Id = "AresTrain_CombatText",
	DisplayName = "{#CombatTextHighlightFormat}{$TraitData."..(gods.GetInternalBoonName("TrainKillBoon"))..".Name}{#Prev}!",
}, Order)

mod.HermesDuoBoonProphecy_Quest = sjson.to_object({
	Id = "ModsWistiti_QuestGetAllHermesDuoBoons",
	DisplayName = "Duos Express",
	Description = "The daughter of the god of the dead shall someday earn a variety of Duo Boons offered by the the God of Swiftness with his fellow Olympians.",
}, Order)

sjson.hook(HelpTextFile, function(data)
	table.insert(data.Texts, mod.GustPlural)
	table.insert(data.Texts, mod.ExecuteStatus)
	table.insert(data.Texts, mod.MagneticField)
	table.insert(data.Texts, mod.AresTrainBoon_CombatText)
	table.insert(data.Texts, mod.HermesDuoBoonProphecy_Quest)
end)

ResetKeywords()

--Projectiles
local playerProjectilesFile = rom.path.combine(rom.paths.Content,"Game\\Projectiles\\PlayerProjectiles.sjson")
sjson.hook(playerProjectilesFile, function(data)
	local projectileFile = rom.path.combine(rom.paths.plugins(), _PLUGIN.guid .. "\\projectiles\\Projectiles.sjson")
	mod.readSjson(projectileFile, data, "Projectiles")
end)

--Animations
local generalEnemyAnimationsFile = rom.path.combine(rom.paths.Content,"Game\\Animations\\Enemy_General_VFX.sjson")
sjson.hook(generalEnemyAnimationsFile, function(data)
	local AnimationFile = rom.path.combine(rom.paths.plugins(), _PLUGIN.guid .. "\\animations\\Animations.sjson")
	mod.readSjson(AnimationFile, data, "Animations")
end)

--Adding valid projectiles to existing boons
--Demeter x Hermes
table.insert(game.TraitData["StormSpawnBoon"].SetupFunction.Args.TargetProjectileNames, "DemeterOmegaStorm")
--Hestia x Hermes
table.insert(game.TraitData["FireballRendBoon"].AddOutgoingDamageModifiers.ValidProjectiles, "ProjectileSprintFireball")

--Damage coloring
game.OverwriteTableKeys( game.ProjectileData, {
	DemeterOmegaStorm =
	{
		InheritFrom = { "DemeterColorProjectile" },
	},
	ProjectileSprintFireball =
	{
		InheritFrom = { "HestiaColorProjectile" },
	},
	AresTrainProjectile =
	{
		InheritFrom = { "AresColorProjectile" },
	},
})
game.ProcessDataStore(game.ProjectileData)

game.ConcatTableValues(game.WeaponSets.OlympianProjectileNames,{
	"DemeterOmegaStorm",
	"ProjectileSprintFireball",
	"AresTrainProjectile",
})

game.OverwriteTableKeys( game.ScreenData.RunClear.DamageSourceMap, {
	DemeterOmegaStorm = "Hurricane Eye",
	ProjectileSprintFireball = "Aerobic Capacity",
	AresTrainProjectile = "Train Wreck",
})

local newQuestOrderData = {
	"ModsWistiti_QuestGetAllHermesDuoBoons",
}
game.ConcatTableValuesIPairs(game.QuestOrderData, newQuestOrderData)

local newQuestData = {
	ModsWistiti_QuestGetAllHermesDuoBoons = {
		Name = "ModsWistiti_QuestGetAllHermesDuoBoons",
		InheritFrom = { "DefaultQuestItem", "DefaultOlympianQuest" },
		RewardResourceName = "WeaponPointsRare",
		RewardResourceAmount = 5,
		UnlockGameStateRequirements = {
			{
				Path = { "GameState", "TraitsTaken" },
				CountOf = {
					gods.GetInternalBoonName("ZappyFieldBoon"),
					gods.GetInternalBoonName("OopsAllCursedBoon"),
					gods.GetInternalBoonName("MoneyMoreDamageBoon"),
					gods.GetInternalBoonName("GustsOrbitBoon"),
					gods.GetInternalBoonName("CastWarZoneBoon"),
					gods.GetInternalBoonName("OnlyFansBoon"),
					gods.GetInternalBoonName("MoneyToShieldBoon"),
					gods.GetInternalBoonName("FireballSprintBoon"),
					gods.GetInternalBoonName("TrainKillBoon"),
				},
				Comparison = ">=",
				Value = 1,
			},
		},
		CompleteGameStateRequirements = {
			{
				Path = { "GameState", "TraitsTaken" },
				HasAll = {
					gods.GetInternalBoonName("ZappyFieldBoon"),
					gods.GetInternalBoonName("OopsAllCursedBoon"),
					gods.GetInternalBoonName("MoneyMoreDamageBoon"),
					gods.GetInternalBoonName("GustsOrbitBoon"),
					gods.GetInternalBoonName("CastWarZoneBoon"),
					gods.GetInternalBoonName("OnlyFansBoon"),
					gods.GetInternalBoonName("MoneyToShieldBoon"),
					gods.GetInternalBoonName("FireballSprintBoon"),
					gods.GetInternalBoonName("TrainKillBoon"),
				},
			},
		},
	},
}
game.QuestData["ModsWistiti_QuestGetAllHermesDuoBoons"] = newQuestData.ModsWistiti_QuestGetAllHermesDuoBoons

function mod.readSjson(file,data,key)
    local fileHandle = io.open(file,"r")
    if fileHandle ~= nil then
        local sjsonContent = fileHandle:read("*a")
        local sjsonTable = sjson.decode(sjsonContent)
        for _, value in pairs(sjsonTable[key]) do
            table.insert(data[key], value)
        end
    end
end

-- Weapons
--[[local playerWeaponsFile = rom.path.combine(rom.paths.Content, "Game\\Weapons\\PlayerWeapons.sjson")
sjson.hook(playerWeaponsFile, function(data)
	local weaponFile = rom.path.combine(rom.paths.plugins(), _PLUGIN.guid .. "\\weapons\\PlayerWeapons.sjson")
	mod.readSjson(projectileFile, data, "PlayerWeapons")
end)]]

-- Everything below this line is part of the example mod creation guide,
-- which you can find on our wiki, replacing Schelemeus portrait:
-- https://sgg-modding.github.io/Hades2ModWiki/docs/category/creating-your-first-mod
-- Note that the custom .pkg files are not included in the template, and you will
-- need to create them yourself if you want to follow the tutorial.
