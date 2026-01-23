function HUD()
    --surface.SetDrawColor(255,0,0,255)
    --surface.DrawRect(0, 0, 100, 100)
    draw.RoundedBox(5, 50, 50, 500, 100, Color(0,0,0, 150))
    draw.SimpleText(
	"Generators " .. GetGlobalInt("FixedGenerators") .. " / " .. GetConVar("hs_max_generators"):GetInt(),
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
