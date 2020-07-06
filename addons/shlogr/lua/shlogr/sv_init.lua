print("LOG START INIT")

SHLOGR = {} -- global table

util.AddNetworkString( "shlogr_netdata" )

SHLOGR.chat = {} -- chat table
SHLOGR.jl = {} -- join/leave table
SHLOGR.com = {} -- command table (p msgs)
SHLOGR.lmap = {} -- last map

if file.Exists( "chatlog_lastmap.txt", "DATA" ) then
	SHLOGR.lmap = string.Explode( "\n", file.Read( "chatlog_lastmap.txt", "DATA" ) )
	for k,v in pairs( SHLOGR.lmap ) do
		SHLOGR.lmap[k] = util.JSONToTable( v )
	end
end
file.Write( "chatlog_lastmap.txt", "" )

function SHLOGR.AddRecord( text, col )
	file.Append( "chatlog_lastmap.txt", util.TableToJSON({t=text,c=col}) .. "\n" )
end

hook.Add( "PlayerSay", "shlogr_addchat", function( ply, msg, tc )
	if tc then
		table.insert( SHLOGR.chat, { 
			ti = os.date( "%X" ),
			te = ply:Team(),
			pl = ply:Nick(),
			al = ply:Alive(),
			me = msg,
			ct = CurTime()
		} )
		if ply:Alive() then
			SHLOGR.AddRecord( os.date( "%X" ) .. "T|" .. team.GetName(ply:Team()) .. "|" .. ply:Nick() .. ": " .. msg , Color(0,200,0) )
		else
			SHLOGR.AddRecord( os.date( "%X" ) .. "TD|" .. team.GetName(ply:Team()) .. "|" .. ply:Nick() .. ": " .. msg, Color(200,200,0) )
		end
	else
		table.insert( SHLOGR.chat, { 
			ti = os.date( "%X" ),
			pl = ply:Nick(),
			al = ply:Alive(),
			me = msg,
			ct = CurTime()
		} )
		if ply:Alive() then
			SHLOGR.AddRecord( os.date( "%X" ) .. "|" .. ply:Nick() .. ": " .. msg, Color(190,190,190) )
		else
			SHLOGR.AddRecord( os.date( "%X" ) .. "D|" .. ply:Nick() .. ": " .. msg, Color(160,50,0) )
		end
	end
end)

gameevent.Listen( "player_connect" )
hook.Add("player_connect", "shlogr_addconnect", function( data )
	table.insert( SHLOGR.jl, { 
		ti = os.date( "%X" ),
		ty = "join",
		pl = data.name,
		ip = data.address,
		id = data.networkid,
		ct = CurTime()
	} )
	SHLOGR.AddRecord( os.date( "%X" ) .. "|" .. data.name .. " join. " .. data.networkid .. " | " .. data.address , Color(80,180,80) )
end)

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "shlogr_addleave", function( data )
	table.insert( SHLOGR.jl, { 
		ti = os.date( "%X" ),
		ty = "leave",
		pl = data.name,
		id = data.networkid,
		ct = CurTime()
	} )
	SHLOGR.AddRecord( os.date( "%X" ) .. "|" .. data.name .. " leave. " .. data.networkid , Color(180,100,80) )
end )

gameevent.Listen( "player_changename" )
hook.Add( "player_changename", "shlogr_addnamechange", function( data )
	table.insert( SHLOGR.jl, { 
		ti = os.date( "%X" ),
		ty = "chname",
		on = data.oldname,
		nn = data.newname,
		ct = CurTime()
	} )
	SHLOGR.AddRecord( os.date( "%X" ) .. "| NameChange: " .. data.oldname .. " is now: " .. data.newname , Color(100,100,100) )
end )

net.Receive( "shlogr_netdata", function(leng,ply)
	if ply:query( "ulx chatlogs" ) then
		local rtype = net.ReadString()
		net.Start("shlogr_netdata")
			net.WriteString(rtype)
			if rtype == "lmap" then
				net.WriteTable(SHLOGR.lmap)
			elseif rtype == "all" then
				net.WriteTable(SHLOGR.chat)
				net.WriteTable(SHLOGR.jl)
				net.WriteTable(SHLOGR.com)
			elseif rtype == "chat" then
				net.WriteTable(SHLOGR.chat)
			elseif rtype == "jl" then
				net.WriteTable(SHLOGR.jl)
			elseif rtype == "com" then
				net.WriteTable(SHLOGR.com)
			end
		net.Send(ply)
	end
end)

function SHLOGR.AddComm( plyn, data )
	table.insert( SHLOGR.com, { 
		ti = os.date( "%X" ),
		pl = plyn,
		da = data,
		ct = CurTime()
	} )
	SHLOGR.AddRecord( os.date( "%X" ) .. "| " .. plyn .. "::" .. data , Color(250,250,250) )
end


print("LOG END INIT")