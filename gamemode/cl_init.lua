include("shared.lua")
include("game_hud.lua")

function GM:SpawnMenuOpen()
    return true
end

local exitDoor = nil

net.Receive("HighlightExitDoor", function()
    exitDoor = net.ReadEntity()
end)

--hook.Add("PreDrawHalos", "HaloDebugTest", function()
--    halo.Add(
--        ents.FindByClass("prop_door_rotating"),
--        Color(255, 0, 0),
--        3, 3,
--        1,
--        true,
--        true
--    )
--end)

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
