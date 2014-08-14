hook.Add( "PostDrawTranslucentRenderables", "GunInfo", function()
	if not IsValid( LocalPlayer() ) then return end

	local gun = LocalPlayer():GetEyeTrace().Entity
	if IsValid( gun ) and gun:IsWeapon()
		and gun:IsScripted()
		and LocalPlayer():GetPos():Distance( gun:GetPos() ) < GS.Distance
		then

		if not GS.Panels[gun] or type( GS.Panels[gun].textalpha ) == "table" then gun:FormPanel() end

	end

	local ang = LocalPlayer():EyeAngles()
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	for ent, panel in pairs( GS.Panels ) do

		if IsValid( ent ) and ent.Owner == NULL then

			if gun ~= ent then panel.removing = true
			else panel.removing = false end

			if ( panel.textalpha < GS.TextColor.a or panel.alpha < GS.BGColor.a ) and not panel.removing then
				panel.alpha = math.Approach( panel.alpha, GS.BGColor.a, FrameTime() *GS.BGFadeIn )
				panel.textalpha = math.Approach( panel.textalpha, GS.TextColor.a, FrameTime() *GS.TextFadeIn )
			end

			local pos = ent:LocalToWorld( ent:OBBCenter() ) +Vector( 0, 0, panel.offset ) +ang:Up()

			x, y = -panel.width/2, math.sin( ( CurTime() *2 ) ) *50

			cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), GS.Scale )
				render.PushFilterMag( TEXFILTER.ANISOTROPIC )
				render.PushFilterMin( TEXFILTER.ANISOTROPIC )

				draw.RoundedBox( 2, x, y, panel.width, panel.height, GS.SetColorAlpha( GS.BGColor, panel.alpha ) )

				local _, h = GS.GetTextSize( "GI_Large", panel.name )
				GS.DrawText( panel.name, "GI_Large", 0, y, GS.SetColorAlpha( panel.color, panel.textalpha ), TEXT_ALIGN_CENTER )
				draw.RoundedBox( 8, -panel.width *0.25, y +h, panel.width *0.5, 5, GS.SetColorAlpha( panel.color, panel.textalpha ) )

				if panel.stats then

					for k, stat in SortedPairs( panel.stats ) do

						local _, h2 = GS.GetTextSize( "GI_Medium", stat.left )
						GS.DrawText( stat.left, "GI_Medium", x +GS.Padding, y +h/2 +( h2/1.2 )*k, GS.SetColorAlpha( stat.lcolor, panel.textalpha ) )
						GS.DrawText( stat.right, "GI_Medium", panel.width/2 -GS.Padding, y +h/2 +( h2/1.2 )*k, GS.SetColorAlpha( stat.rcolor, panel.textalpha ), TEXT_ALIGN_RIGHT )

					end

				end

				render.PopFilterMag()
				render.PopFilterMin()
			cam.End3D2D()

			if ( panel.textalpha > 0 or panel.alpha > 0 ) and panel.removing then
				panel.alpha = math.Approach( panel.alpha, 0, FrameTime() *GS.BGFadeOut )
				panel.textalpha = math.Approach( panel.textalpha, 0, FrameTime() *GS.TextFadeOut )
			end
			if panel.textalpha == 0 and panel.alpha == 0 and panel.removing then GS.Panels[ent] = nil end

		else ent:RemovePanel() end

	end

end )

surface.CreateFont( "GI_Large", {
	font 		= GS.Font,
	size 		= 75,
	weight 		= 700,
	antialias 	= true,
	bold 		= true,
} )

surface.CreateFont( "GI_Medium", {
	font 		= GS.Font,
	size 		= 50,
	weight 		= 700,
	antialias 	= true,
	bold 		= true,
} )

