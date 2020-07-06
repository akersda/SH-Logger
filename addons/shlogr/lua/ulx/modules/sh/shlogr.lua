function ulx.chatlogs( calling_ply )
	calling_ply:ConCommand( "openshlogr_menu" ) 
end
local chatlogs = ulx.command( "Chat", "ulx chatlogs", ulx.chatlogs, "!chatlogs", true )
chatlogs:defaultAccess( ULib.ACCESS_ADMIN )
chatlogs:help( "Opens chat/event log." )