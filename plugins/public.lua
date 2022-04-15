--[[
LUA script for improving public AQ2 server experience
------------------------------
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
------------------------------
Function:
   change serversettings to make it more fun to wait for more players
   to join the server
------------------------------

--]]
local version = "1.0"
local delay = 3                                      	-- delay before message and settings are run
local teamplay = gi.cvar("teamplay", "").string         -- check if the server has cvar teamplay 1 or 0

local dmflags_cfg = gi.cvar("dmflags", "").string       -- store dmflagssetting

local changedmflags
local changedmflagsat
local plrInBothTeams
local dmflags_now
local dmflags_bak

function override_dmflags()
    dmflags_now = gi.cvar("dmflags", "").string
    dmflags_bak = gi.cvar("dmflags_bak", "").string
    if dmflags_bak == '' then                           -- save default dmflags setting if not stored before
        gi.AddCommandString("sets dmflags_bak "..dmflags_cfg.."\n")
    end
    if dmflags_now ~= 8 then                            -- set dmflags to 8 if it isn't already
        gi.AddCommandString("sets dmflags 8\n")
        gi.dprintf("public.lua: setdmflags_dm() dmflags set to 8 (default: "..dmflags_cfg..")\n")
    end
end

function restore_dmflags()
    dmflags_now = gi.cvar("dmflags", "").string
    if dmflags_now ~= dmflags_bak or dmflags_bak == '' then  
        gi.AddCommandString("sets dmflags "..dmflags_bak.."\n")
        gi.dprintf("public.lua: setdmflags_dm() dmflags set back to "..dmflags_cfg.."\n")
    end
end


function setdmflags()
    if teamplay == "0" then
        local plrcount = #ex.players
        if plrcount == 1 then
            override_dmflags()
            gi.bprintf(PRINT_CHAT, '* * * You are alone on this server * * *\n')
            gi.bprintf(PRINT_CHAT, '* * * I\'ve disabled fall damage again so you can fool around while you wait for someone to join <3 * * *\n')
        elseif plrcount > 1 and dmflags ~= dmflags_cfg then
            restore_dmflags()
            gi.bprintf(PRINT_CHAT, '* * * WOHOO, you are now atleast two players, ACTION! * * *\n')       
        end
    elseif teamplay == "1" then
        if plrInBothTeams ~= true then
            override_dmflags()
            gi.bprintf(PRINT_CHAT, '* * * There are not players in both teams * * *\n')
            gi.bprintf(PRINT_CHAT, '* * * I\'ve disabled fall damage so you can fool around while you wait * * *\n')
        elseif plrInBothTeams == true then
            restore_dmflags()
            gi.bprintf(PRINT_CHAT, '* * * Both teams has players, ACTION * * *\n')
        end
    end
end

function LogMessage(msg)
    local name = string.match(msg, "(.+) entered the game")
    if name ~= nil then
		name = nil
        changedmflags = true
		changedmflagsat = os.time() + delay
    end
    local name = string.match(msg, "(.+) disconnected")
    if name ~= nil then
        name = nil
        changedmflags = true
		changedmflagsat = os.time() + delay
    end
    local name = string.match(msg, "The round will begin in (.+) seconds!")
    if name ~= nil then
        name = nil
        changedmflags = true
		plrInBothTeams = true
		changedmflagsat = os.time() + delay
    end
    local name = string.match(msg, "Not enough players to play!")
    if name ~= nil then
        name = nil
        changedmflags = true
		plrInBothTeams = false
		changedmflagsat = os.time() + delay
    end
end

function RunFrame()
	if changedmflags == true then
		if changedmflagsat <= os.time() then
			setdmflags()
			changedmflags = false
		end
	end
end

function q2a_load(config)
    gi.dprintf("public.lua: q2a_load(): "..version.." for Action Quake 2 loaded.\n")
end