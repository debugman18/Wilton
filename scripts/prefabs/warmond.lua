local MakePlayerCharacter = require "prefabs/player_common"

local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),
        Asset( "ANIM", "anim/warmond.zip" ),
		Asset( "ANIM", "anim/bonerang.zip"),
		Asset( "ANIM", "anim/swap_bonerang.zip"),	
}
local prefabs = { "chester_eyebone", "bonerang",}

local start_inv = { "chester_eyebone", "bonerang",}

function GetSpecialCharacterString(character)
    character = string.lower(character)
    if character == "warmond" then

		local sayings =
		{
			"Ehhhhhhhhhhhhhh.",
			"Eeeeeeeeeeeer.",
			"Rattle.",
			"Click click click click",
			"Hissss!",
			"Aaaaaaaaa.",
			"Mooooooooooooaaaaan.",
			"...",
		}

		return sayings[math.random(#sayings)]
	elseif character == "wes" then
		return ""
    --else
		--print (character)
    end
end	

local fn = function(inst)
	
	-- choose which sounds this character will play
	inst.soundsname = "wilton"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilton.png" )
	inst:AddComponent("lootdropper")
	inst:AddTag("iswilton")
	-- todo: Add an example special power here.
	--wilton is very brittle
	inst.components.health.maxhealth = 50
	inst.components.sanity.max = 30
	inst.components.temperature.hurtrate = 6
	--wilton does not get hungry
	inst.components.hunger:Pause()
	inst.components.hunger:SetRate(0)
	inst.components.hunger:SetKillRate(0)
	--slow wilton
	inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * .85)
	inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * .85)
	--spawn with eyebone
	inst.components.inventory:GuaranteeItems(start_inv)
	--wilton goes insane faster in the rain
	if GetSeasonManager() and GetSeasonManager():IsRaining() and not mitigates_rain then
    	inst.components.sanity:DoDelta(-1)
	end
end

STRINGS.CHARACTER_TITLES.warmond = "The Undead"
STRINGS.CHARACTER_NAMES.warmond = "Wilton"
STRINGS.CHARACTER_DESCRIPTIONS.warmond = " *Is brittle\n *Does not starve\n *Reincarnates"
STRINGS.CHARACTER_QUOTES.warmond = "\"Rattle Rattle Rattle...\""
STRINGS.CHARACTERS.WARMOND = {}
STRINGS.CHARACTERS.WARMOND.DESCRIBE = {}
STRINGS.CHARACTERS.WARMOND.DESCRIBE.GENERIC = "Rattle Rattle Rattle."
	
return MakePlayerCharacter("warmond", prefabs, assets, fn, start_inv)


