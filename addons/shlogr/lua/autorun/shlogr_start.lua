if SERVER then
	AddCSLuaFile("shlogr/cl_init.lua")
	AddCSLuaFile("shlogr/cl_menu.lua")
	include("shlogr/sv_init.lua")
else
	include("shlogr/cl_init.lua")
	include("shlogr/cl_menu.lua")
end
