print("LOG START")

local function load_chat( outtab )
	local intab = net.ReadTable()
	
	for k,v in pairs(intab) do
		if v.al and v.te != nil then
			table.insert(outtab, {
				t = "[" .. v.ti .. "] [" .. team.GetName( v.te ) .. "] " .. v.pl .. ": " .. v.me ,
				c = Color(0,200,0),
				s = v.ct
			} )
		elseif v.al then
			table.insert(outtab, {
				t = "[" .. v.ti .. "] " .. v.pl .. ": " .. v.me ,
				c = Color(190,190,190),
				s = v.ct
			} )
		elseif v.te != nil then
			table.insert(outtab, {
				t = "[" .. v.ti .. "] [" .. team.GetName( v.te ) .. "] *DEAD* " .. v.pl .. ": " .. v.me ,
				c = Color(200,200,0),
				s = v.ct
			} )
		else
			table.insert(outtab, {
				t = "[" .. v.ti .. "] *DEAD* " .. v.pl .. ": " .. v.me ,
				c = Color(160,50,0),
				s = v.ct
			} )
		end
	end
end

local function load_jl( outtab )
	local intab = net.ReadTable()
	
	for k,v in pairs(intab) do
		if v.ty == "join" then
			table.insert(outtab, {
				t =  "[" .. v.ti .. "] " .. v.pl .. " joined.  " .. v.id .. "  |  " .. v.ip ,
				c = Color(80,180,80),
				s = v.ct
			} )
		elseif v.ty == "leave" then
			table.insert(outtab, {
				t =  "[" .. v.ti .. "] " .. v.pl .. " left.  " .. v.id ,
				c = Color(180,100,80),
				s = v.ct
			} )
		elseif v.ty == "chname" then
			table.insert(outtab, {
				t =  "[" .. v.ti .. "] NameChange: " .. v.on .. " is now: " .. v.nn ,
				c = Color(100,100,100),
				s = v.ct
			} )
		end
	end
end

local function load_com( outtab )
	local intab = net.ReadTable()
	
	for k,v in pairs(intab) do
		table.insert(outtab, {
			t =  "[" .. v.ti .. "] :: " .. v.pl .. " | " .. v.da ,
			c = Color(250,250,250),
			s = v.ct
		} )
	end
end

net.Receive("shlogr_netdata", function()
	local rtype = net.ReadString()
	local outtab = {}
	
	if rtype == "lmap" then
		outtab = net.ReadTable()
		PrintTable(outtab)
	else
		if rtype == "all" then
			load_chat( outtab )
			load_jl( outtab )
			load_com( outtab )
		elseif rtype == "chat" then
			load_chat( outtab )
		elseif rtype == "jl" then
			load_jl( outtab )
		elseif rtype == "com" then
			load_com( outtab )
		end
		
		table.sort( outtab, function(a, b) return a.s > b.s end )
	end

	if ispanel(shlogr_menu) then
		shlogr_menu:UpdateCD( outtab )
	end
end)