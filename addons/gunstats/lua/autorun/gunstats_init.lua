AddCSLuaFile( "gunstats/cl_config.lua" )
AddCSLuaFile( "gunstats/cl_util.lua" )
AddCSLuaFile( "gunstats/cl_display.lua" )

if CLIENT then

	local tab = {
		__index = function( self, k )
			local tab = {}
			setmetatable( tab, getmetatable( self ) )
			rawset( self, k, tab )
			return tab
		end
	}
	GS = GS or {}
	setmetatable( GS, tab )

	GS.ShouldDraw = CreateClientConVar( "gs_show", 1, true )

	hook.Add( "InitPostEntity", "GS_Startup", function()

		GS.Gamemode = ( GM or GAMEMODE ).FolderName

	end )

	include( "gunstats/cl_config.lua" )
	include( "gunstats/cl_util.lua")
	include( "gunstats/cl_display.lua" )

	MsgC( Color( 241, 196, 15 ), "Gun Stats initialized...\n" )

end