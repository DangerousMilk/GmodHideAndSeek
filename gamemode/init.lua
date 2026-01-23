AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("game_hud.lua")

include("shared.lua")
include("concommands.lua")

function GM:PlayerSpawn(ply)
    ply:SetGravity(.80)
    ply:SetMaxHealth(100)
    ply:Give("weapon_physgun")
    ply:SetupHands()

    CreateConVar("hs_generator_fix_time", "3", {FCVAR_ARCHIVE})
    CreateConVar("hs_generator_fix_sound_range", "85", {FCVAR_ARCHIVE})
    CreateConVar("hs_max_generators", "5", {FCVAR_ARCHIVE})

    SetGlobalInt("FixedGenerators", 0)
end

hook.Add("GeneratorFixed", "CheckGenerators", function()
    if GetGlobalInt("FixedGenerators") >= GetConVar("hs_max_generators"):GetInt() then
	sound.Play("music/Ravenholm_1.mp3", Vector(0, 0, 0), 0, 100, 1)
	print("Niga")
    end
end)
