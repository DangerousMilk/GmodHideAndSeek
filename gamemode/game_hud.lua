function HUD()
    local fixedGenerators = GetGlobalInt("FixedGenerators")
    local maxGenerators = GetConVar("hs_max_generators"):GetInt()

    -- Background
    draw.RoundedBox(5, 50, 50, 500, 100, Color(0,0,0, 150))
    -- Text
    draw.SimpleText(
	"Generators " .. fixedGenerators .. " / " .. maxGenerators,
	"Title",
	65,
	65
    )
end

surface.CreateFont( "Title", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer.
	extended = false,
	size = 70,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

hook.Add("HUDPaint", "GameHud", HUD)
