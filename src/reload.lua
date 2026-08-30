---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.


-- These functions are part of the example code snippets from ready.lua

function prefix_SetupMap()
	mod.LoadBoonIconsPackage()
end


--modutil.mod.Hades.PrintOverhead(config.message)



-------------------------------------------------------------------
-- This function is part of the mod creation guide from the wiki --
-------------------------------------------------------------------
function mod.LoadBoonIconsPackage()
	local packageName = _PLUGIN.guid .. "BoonIcons"
	--print("Wistiti-HermesDuos - Loading package: " .. packageName)
	LoadPackages({ Name = packageName })
end
