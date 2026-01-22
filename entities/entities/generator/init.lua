AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- Server-side initialization function for the Entity
function ENT:Initialize()
    self:SetModel( "models/props_mining/diesel_generator.mdl" ) -- Sets the model for the Entity.
    self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
    self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
    self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
    local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.
    if phys:IsValid() then -- Checks if the physics object is valid.
        phys:Wake() -- Activates the physics object, making the Entity subject to physics (gravity, collisions, etc.).
    end

    self.lastUsed = CurTime()
    self:SetHoldProgress(0)
    self:SetHoldStart(0)

    --self.WorkingSound = "ambient/energy/spark1.wav"
    self.FixingSound = "ambient/energy/spark1.wav"
    self.RepairedSound = "buttons/button1.wav"
end

function ENT:Use(activator, caller, useType, value)
    -- Ignore when already on
    if self:GetIsOn() then return end
    if not IsValid(activator) then return end

    local now = CurTime()
    local holdStart = self:GetHoldStart()
    local holdProgress = self:GetHoldProgress()

    -- Hold start is zero when the generator has not been used
    if holdStart == 0 then
	-- Generator first used
	self:SetHoldStart(now - holdProgress)
    else
	-- Generator being repaired
	-- How long the button was held down for
	local delta = now - holdStart

	print(delta % 0.1)
	-- Sound
	-- add delay
	if delta % 0.002 == 0 then
	    -- Spark sound
	    self:EmitSound(self.FixingSound, GetConVar("hs_generator_fix_sound_range"):GetInt())
	end

	print("Using: " .. delta)

	-- Check if fixed
	if delta >= GetConVar("hs_generator_fix_time"):GetInt() then
	    -- Generator fixed
	    print("I am FULLY charged")
	    self:SetIsOn(true)

	    SetGlobalInt("FixedGenerators", GetGlobalInt("FixedGenerators") + 1)
	    print("Fixed " .. GetGlobalInt("FixedGenerators"))

	    self:EmitSound(self.RepairedSound, self.SoundRange)
	end
    end

    self.lastUsed = now
end

function ENT:Think()
    -- Test sound
    --if math.floor(CurTime()) % 2 == 0 then
    --    self:EmitSound(self.FixingSound, GetConVar("hs_generator_fix_sound_range"):GetInt())
    --end

    if self:GetIsOn() then return end
    if self:GetHoldStart() == 0 then return end

    -- Last used timer stops updating when the generator
    -- is not being interacted with.
    if(CurTime() - self.lastUsed >= 0.15) then
	-- Save the current progress
	self:SetHoldProgress((CurTime() - 0.15) - self:GetHoldStart())
	-- Reset
	self:SetHoldStart(0)
	print("Stopped")
    end
end

function ENT:OnRemove()
end
