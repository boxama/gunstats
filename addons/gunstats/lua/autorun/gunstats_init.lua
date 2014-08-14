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
	GS = {}
	setmetatable( GS, tab )

	include( "gunstats/cl_config.lua" )
	include( "gunstats/cl_util.lua")
	include( "gunstats/cl_display.lua" )

end