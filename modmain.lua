local STRINGS = GLOBAL.STRINGS
GetClock = GLOBAL.GetClock
GetPlayer = GLOBAL.GetPlayer

PrefabFiles = {
	"warmond", 
	"bonerang",
}

Assets = {
    Asset( "ATLAS", "images/saveslot_portraits/warmond.xml" ),
	Asset( "IMAGE", "images/saveslot_portraits/warmond.tex" ),
	
    Asset( "ATLAS", "images/selectscreen_portraits/warmond.xml" ),
	Asset( "IMAGE", "images/selectscreen_portraits/warmond.tex" ),
	
    Asset( "ATLAS", "images/selectscreen_portraits/warmond_silho.xml" ),
	Asset( "IMAGE", "images/selectscreen_portraits/warmond_silho.tex" ),
	
    Asset( "ATLAS", "bigportraits/warmond.xml" ),
	Asset( "IMAGE", "bigportraits/warmond.tex" ),	
	
	Asset( "ATLAS", "images/inventoryimages/bonerang.xml" ),
	Asset( "IMAGE", "images/inventoryimages/bonerang.tex" ),
}

function uniqueitem1(inst)
	inst:AddTag("uniqueitem1")
end

function uniqueitem2(inst)
	inst:AddTag("uniqueitem2")
end

function doresurrect(inst, dude)
	print "Wilton is trying to respawn."
	
	dude:DoTaskInTime(2, function()
		
		--This removes any already-existing eyebones and bonerangs.	
		clearduplicates1 = TheSim:FindFirstEntityWithTag("uniqueitem1")
		clearduplicates1:Remove()
		clearduplicates2 = TheSim:FindFirstEntityWithTag("uniqueitem2")
		clearduplicates2:Remove()
		dude.components.lootdropper:SetLoot({"chester_eyebone","bonerang"}) 
		
		--This sets your respawnpoint to wherever the skeleton is.
		dude.Transform:SetPosition(inst.Transform:GetWorldPosition())		
		dude:Show()
		
		--Makes next day so that there are no issues with night.
		GetClock():MakeNextDay()
		
		--Gives you back your unique items.
		dude.components.lootdropper:DropLoot()
		dude.components.lootdropper:SetLoot({})
		
		--These lines set your stats to half of normal.
		if dude.components.health and dude.components.health.maxhealth >= 10 then
			dude.components.health:Respawn(35)
			dude.components.health:SetPercent(0.5)
			dude.components.health.maxhealth = dude.components.health.maxhealth-10
        end	

		if dude.components.sanity then
            dude.components.sanity:SetPercent(0.3)
        end	
		
		dude.sg:GoToState("wakeup")
		
		--This removes the skeleton so it can't be reused.
		inst.components.resurrector.used = true
		inst:Remove()
		dude:ClearBufferedAction()
		
		--This brings the HUD back up.
		if dude.HUD then
			dude.HUD:Show()
		end
		
		--This makes sure the health meter shows the changes.
		dude.components.health:DoDelta(1)
		dude.components.health:DoDelta(-1)
		
		return true
	end)
end

function reincarnate(inst)	
	local canbehelped = false
	local MainCharacter = GetPlayer()
	
	if MainCharacter.prefab == "warmond" then
		canbehelped = true
	end
	
	if canbehelped == true then
		inst:AddComponent("resurrector")
		inst.components.resurrector.penalty = 0	
		inst.components.resurrector.active = true	
		inst.components.resurrector.used = false	
		inst.components.resurrector.doresurrect = doresurrect
	
		print "This is one skeleton"
		return inst
	end	
end

AddSimPostInit(function(inst)
	if inst.prefab == "warmond" then
		poisonflower = true
		inst.HUD.controls.status.brain:SetPosition(inst.HUD.controls.status.stomach:GetPosition())
		inst.HUD.controls.status.stomach:Hide()
		--This makes sure that Wilton cannot eat anything that isn't the "INSECT" type.
		inst.components.eater:SetInsectivore()
	end
end)

AddPrefabPostInit("petals", function(inst)	 
	--This makes sure that petals is the only food Wilton can eat, since it is the "INSECT" type.
	inst.components.edible.foodtype = "INSECT" 
	
    if poisonflower == true then 
		inst.components.edible.sanityvalue = -TUNING.SANITY_SMALL 
	end
end)

GLOBAL.STRINGS.NAMES.BONERANG = "Bone-A-Rang"

AddPrefabPostInit('skeleton', reincarnate)
AddPrefabPostInit('chester_eyebone', uniqueitem1)
AddPrefabPostInit('bonerang', uniqueitem2)
AddModCharacter("warmond")