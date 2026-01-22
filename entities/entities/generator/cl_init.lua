include("shared.lua")

function ENT:Think()
    -- Light
    local isOn = self:GetIsOn()
    local light = DynamicLight(self:EntIndex())

    -- Light position
    local pos = self:GetPos()
    pos.z = pos.z + 90

    if ( light ) then
	    light.pos = pos
	    -- Color
	    light.r = isOn and 50 or 255
	    light.g = isOn and 255 or 50
	    light.b = 50

	    light.brightness = 1
	    light.decay = 1
	    light.size = 256
	    light.dietime = CurTime() + 1
    end
end

function ENT:Draw()
    -- Draws the model of the Entity. This function is called every frame.
    self:DrawModel()
end
