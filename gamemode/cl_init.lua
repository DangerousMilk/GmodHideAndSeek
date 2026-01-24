include("shared.lua")
include("game_hud.lua")

function GM:SpawnMenuOpen()
    return true
end

local exitDoor = nil
local seekerSound = nil
local seeker = nil

net.Receive("HighlightExitDoor", function()
    exitDoor = net.ReadEntity()
end)


net.Receive("PlayMusicExceptSelf", function()
    seeker = net.ReadEntity()
    stop = net.ReadBool()
    if stop then
	print("stop")
	if seekerSound ~= nil then
	    print("stop full")
	    seekerSound:Stop()
	    seekerSound = nil
	end
    else
	print("play")
	-- Create looping 3D sound
	local soundObj = CreateSound(seeker, "ambient/machines/engine1.wav")
	soundObj:Play()
	soundObj:ChangeVolume(1, 0) -- full volume instantly

	-- Store it so we can update its position
	seekerSound = soundObj
    end
end)

-- Update sound positions every frame
hook.Add("Think", "UpdateMusicPositions", function()
    if not IsValid(seekerSound) then return end
    if not IsValid(seeker) then
	seekerSound:Stop()
	seekerSound = nil
    else
	seekerSound:SetSoundLevel(75) -- optional, max distance
	-- 3D sound automatically follows the entity
    end
end)

hook.Add("EntityRemoved", "StopPlayerMusic", function(ent)
    if seeker == ent then
	if IsValid(seekerSound) then
	    seekerSound:Stop()
	    seekerSound = nil
	end
    end
end)

hook.Add("PreDrawHalos", "HighlightExitDoorHalo", function()
    if IsValid(exitDoor) then
        halo.Add(
            { exitDoor },           -- entities
            Color(0, 255, 0),        -- green glow
            2, 2,                    -- blur X / Y
            2,                       -- passes
            true,                    -- additive
            false                     -- ignore Z (see through walls)
        )
    end
end)

local function DrawGeneratorHUD()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    -- Trace from player's eyes
    local tr = ply:GetEyeTrace()
    local ent = tr.Entity

    if IsValid(ent) and ent:GetClass() == "generator" then
        -- Generator info
        local isOn = ent:GetIsOn()
        local holdStart = ent:GetHoldStart()
        local holdProgress = ent:GetHoldProgress()
        local fixTime = GetConVar("hs_generator_fix_time"):GetInt()

        local text = ""
        if isOn then
            text = "Working."
        else
	    local progress = 0
	    if holdStart ~= 0 then
		progress = CurTime() - holdStart
	    else
		progress = holdProgress
	    end
            text = "Generator Integrity: " .. math.Round(progress, 1) .. " / " .. fixTime
        end

        draw.SimpleText(
            text,
            "HudDefault",
	    ScrW() / 2,
	    ScrH() / 2 + 60,
            Color(0, 255, 0, 255),
	    TEXT_ALIGN_CENTER,
	    TEXT_ALIGN_CENTER
        )
    end
end
hook.Add("HUDPaint", "GeneratorLookHUD", DrawGeneratorHUD)
