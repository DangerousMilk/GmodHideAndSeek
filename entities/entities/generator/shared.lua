ENT.Type = "anim" -- Sets the Entity type to 'anim', indicating it's an animated Entity.
ENT.Base = "base_gmodentity" -- Specifies that this Entity is based on the 'base_gmodentity', inheriting its functionality.
ENT.PrintName = "Generator" -- The name that will appear in the spawn menu.
ENT.Author = "realfancymoo" -- The author's name for this Entity.
ENT.Category = "Hide And Seek" -- The category for this Entity in the spawn menu.
ENT.Purpose = "Generatot entity" -- The purpose of this Entity.
ENT.Spawnable = true -- Specifies whether this Entity can be spawned by players in the spawn menu.

function ENT:SetupDataTables()
    self:NetworkVar("Float", "HoldStart")
    self:NetworkVar("Float", "HoldProgress")
    self:NetworkVar("Bool", "IsOn")
end
