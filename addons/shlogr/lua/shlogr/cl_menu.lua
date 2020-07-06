print("LOG START MENU")

shlogr_menu = {}

concommand.Add( "openshlogr_menu", function()
	net.Start("shlogr_netdata")
		net.WriteString("all")
	net.SendToServer()

	shlogr_menu = vgui.Create( "DFrame" )
	shlogr_menu:SetSize( 600, 500 )
	shlogr_menu:Center()
	shlogr_menu:MakePopup()
	shlogr_menu:SetTitle("CHAT LOGS")
	
	shlogr_menu.settings = vgui.Create( "EditablePanel", shlogr_menu )
	shlogr_menu.settings:SetTall( 36 )
	shlogr_menu.settings:Dock(TOP)
	
	shlogr_menu.selector = vgui.Create( "DComboBox", shlogr_menu.settings )
	shlogr_menu.selector:SetWide( 200 )
	shlogr_menu.selector:DockMargin(3,3,3,3)
	shlogr_menu.selector:Dock(LEFT)
	shlogr_menu.selector:SetValue( "all" )
	
	shlogr_menu.selector:AddChoice( "all","all" )
	shlogr_menu.selector:AddChoice( "chat","chat" )
	shlogr_menu.selector:AddChoice( "join/leave","jl" )
	shlogr_menu.selector:AddChoice( "commands","com" )
	shlogr_menu.selector:AddChoice( "last map","lmap" )
	function shlogr_menu.selector:OnSelect( index, value, data )
		net.Start("shlogr_netdata")
			net.WriteString(data)
		net.SendToServer()
	end
	
	shlogr_menu.scroller = vgui.Create( "RichText", shlogr_menu )
	shlogr_menu.scroller:Dock(FILL)
	function shlogr_menu:UpdateCD( data )
		self.scroller:Remove()
		self.scroller = vgui.Create( "RichText", self )
		self.scroller:Dock(FILL)
		function self.scroller:PerformLayout()
			--self:SetFontInternal("Trebuchet18")
			self:SetBGColor(Color(0, 16, 32))
		end
		for k, v in pairs( data ) do
			self.scroller:InsertColorChange(v.c.r,v.c.g,v.c.b,v.c.a)
			self.scroller:AppendText(v.t .. "\n")
		end
	end
end)