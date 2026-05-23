---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

-- These are some sample code snippets of what you can do with our modding framework:
local file = rom.path.combine(rom.paths.Content, 'Game/Text/en/ShellText.en.sjson')
sjson.hook(file, function(data)
	return sjson_ShellText(data)
end)

modutil.mod.Path.Wrap("SetupMap", function(base, ...)
	prefix_SetupMap()
	return base(...)
end)

local HelpTextFile = rom.path.combine(rom.paths.Content, "Game/Text/en/HelpText.en.sjson")
local Order = { "Id", "InheritFrom", "DisplayName", "Description" }

local newKeywords = {
	"ModsWistitiSlowFieldPlural",
}
game.ConcatTableValuesIPairs(game.KeywordList, newKeywords)

mod.GustPlural = sjson.to_object({
	Id = "ModsWistitiSlowFieldPlural",
	InheritFrom = "SlowField",
	DisplayName = "Gusts",
	Description = "{#ItalicBoldFormat}{$Keywords.Status}: {#Prev}Afflicted foes are {#BoldFormat}{$TooltipData.ExtractData.ChillAmount}% {#Prev}slower, and their ranged shots {$TooltipData.ExtractData.ProjectileSlow:F} slower. Lasts {#BoldFormatGraft}{$TooltipData.ExtractData.Duration} Sec.",
}, Order)

sjson.hook(HelpTextFile, function(data)
	table.insert(data.Texts, mod.GustPlural)
end)

ResetKeywords()

--Projectiles
local playerProjectilesFile = rom.path.combine(rom.paths.Content,"Game\\Projectiles\\PlayerProjectiles.sjson")
sjson.hook(playerProjectilesFile, function(data)
	local projectileFile = rom.path.combine(rom.paths.plugins(), _PLUGIN.guid .. "\\projectiles\\Projectiles.sjson")
	mod.readSjson(projectileFile, data, "Projectiles")
end)

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
	}
})
game.ProcessDataStore(game.ProjectileData)

game.ConcatTableValues(game.WeaponSets.OlympianProjectileNames,{
	"DemeterOmegaStorm",
	"ProjectileSprintFireball",
})

game.OverwriteTableKeys( game.ScreenData.RunClear.DamageSourceMap, {
	DemeterOmegaStorm = "Hurricane Eye",
	ProjectileSprintFireball = "Aerobic Capacity",
})

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
