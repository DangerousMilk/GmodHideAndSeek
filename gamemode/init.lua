AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("game_hud.lua")

include("shared.lua")
include("concommands.lua")

local exitDoor = nil
local exitOpen = false
local seeker = nil

function GM:Initialize()
    util.AddNetworkString("HighlightExitDoor")
    util.AddNetworkString("PlayMusicExceptSelf")
    CreateConVar("hs_generator_fix_time", "3", FCVAR_ARCHIVE + FCVAR_REPLICATED)
    CreateConVar("hs_generator_fix_sound_range", "85", FCVAR_ARCHIVE + FCVAR_REPLICATED)
    CreateConVar("hs_max_generators", "5", FCVAR_ARCHIVE + FCVAR_REPLICATED)
    SetGlobalInt("FixedGenerators", 0)
end

function GM:PlayerSpawn(ply)
    ply:SetGravity(.80)
    ply:SetMaxHealth(100)
    ply:Give("weapon_physgun")
    ply:SetupHands()
end

function selectExitDoor()
    local doors = {}

    for _, ent in ipairs(ents.GetAll()) do
        if IsValid(ent) and ent:GetClass() == "prop_door_rotating" then
            table.insert(doors, ent)
        end
    end

    if #doors == 0 then return nil end
    exitDoor = table.Random(doors)

    -- Send the exitDoor to the clients
    net.Start("HighlightExitDoor")
    net.WriteEntity(exitDoor)
    net.Broadcast()
end

function resetGenerators()
    for _, ent in ipairs(ents.FindByClass("generator")) do
        if IsValid(ent) then
	    ent:ResetGenerator()
        end
    end
end

function resetGame()
    -- Remove exitDoor halo from clients
    net.Start("HighlightExitDoor")
    net.WriteEntity(nil)
    net.Broadcast()

    -- Generators
    resetGenerators()
    SetGlobalInt("FixedGenerators", 0)

    -- Exit
    exitOpen = false

    PlayMusicFromPlayer(true)
end

function sendToAllPlayers(text)
    for _, ply in ipairs(player.GetAll()) do
	ply:ChatPrint(text)
    end
end

function PlayMusicFromPlayer(stop)
    for _, v in ipairs(player.GetAll()) do
        if v ~= seeker then
            net.Start("PlayMusicExceptSelf")
            net.WriteEntity(seeker)       -- Who the sound is coming from
            net.WriteBool(stop)       -- Who the sound is coming from
            net.Send(v)
        end
    end
    if stop then seeker = nil end
end

-- Hooks

hook.Add("ResetHideAndSeek", "ResetGlobal", function()
    resetGame()
end)

hook.Add("GeneratorFixed", "CheckGenerators", function()
    if exitOpen then return end
    SetGlobalInt("FixedGenerators", GetGlobalInt("FixedGenerators") + 1)
    sendToAllPlayers("Generators Fixed: " .. GetGlobalInt("FixedGenerators") .. " / " .. GetConVar("hs_max_generators"):GetInt())
    if GetGlobalInt("FixedGenerators") >= GetConVar("hs_max_generators"):GetInt() then
	selectExitDoor()
	exitOpen = true

	sendToAllPlayers("All Generators Fixed. Escape.")
	sound.Play("music/Ravenholm_1.mp3", Vector(0, 0, 0), 0, 100, 1)
    end
end)

hook.Add("PlayerUse", "TrackExitDoor", function(ply, ent)
    if ent == exitDoor and exitOpen then
	hook.Run("ResetHideAndSeek")

	sendToAllPlayers("The survivors win!")
    end
end)

hook.Add("PlayerSay", "ProcessChatMessages", function(ply, text, public)
    if text == "!seeker" then
	if seeker == ply then
	    ply:ChatPrint("You are no longer the seeker.")
	    PlayMusicFromPlayer(true)
	else
	    ply:ChatPrint("You are now the seeker.")
	    seeker = ply
	    PlayMusicFromPlayer(false)
	end

        return "" -- returning empty string prevents the message from showing in chat
    end

    return text
end)

hook.Add("EntityRemoved", "StopPlayerMusic", function(ent)
    if ent == exitDoor then
	selectExitDoor()
	exitDoor = nil
    end
end)
