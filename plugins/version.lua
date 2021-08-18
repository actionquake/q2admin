--[[
simple !version* script by TgT 

	Requirements: 
		q2proded r548 or later
		
	Changelog:
		v2.1
		+ works with Aprq2 and Q2pro
		v2.0
		+ a rewrite from scratch
	TODO:
		+ make it universal for every client...
--]]

local version = "2.1"
local word = "!versio.+"

gi.AddCommandString("sets q2a_version "..version.."\n")
gi.AddCommandString("addstuffcmd begin set version 0 u")

function ClientCommand(client)
	local sm = string.match
	
	cmd = gi.argv(1)
	match = sm(cmd,word)
	
	if match then
		gi.cprintf(client,PRINT_HIGH,"num name            client version\n")
		gi.cprintf(client,PRINT_HIGH,"--- --------------- ---------------------------------------------\n")
		
		for i,plr in pairs(ex.players) do
			if plr.name ~= "[MVDSPEC]" then
				gi.cprintf(client,PRINT_HIGH,"%3d %-15s %s\n", i-1,plr.name,plr.version)
			end
		end
		return true
	end
end
