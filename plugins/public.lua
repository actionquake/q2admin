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
local version = "1.2"
local delay = 5                                         -- delay before message and settings are run
local teamplay = gi.cvar("teamplay", "").string         -- check if the server has cvar teamplay 1 or 0
local sendMsg = false
local changeDmflags
local SendMsgAt
local plrInBothTeams

local dmflags_bak = gi.cvar("dmflags_bak", "").string               -- tries to catch dmflags_bak
if dmflags_bak == '' or nil then                                    -- if its not set
    dmflags_bak = gi.cvar("dmflags", "").string                     -- it stores default dmflags instead
    gi.AddCommandString("sets dmflags_bak "..dmflags_bak.."\n")     -- and then sets it as backup cvar
end
local dmflags_now
local msg = {}

local test = gi.cvar("asdf", "").string


function override_dmflags()
    --dmflags_bak = gi.cvar("dmflags_bak", "").string
    if dmflags_now ~= 8 then                            -- set dmflags to 8 if it isn't already
        gi.AddCommandString("sets dmflags 8\n")
        gi.dprintf("public.lua: setdmflags_dm() dmflags set to 8 (default: "..dmflags_bak..")\n")
    end
end

function restore_dmflags()
    if dmflags_now ~= dmflags_bak or dmflags_bak == '' then 
        gi.AddCommandString("sets dmflags "..dmflags_bak.."\n")
        gi.dprintf("public.lua: setdmflags_dm() dmflags set back to "..dmflags_bak.."\n")
    end
end

function setdmflags()
    dmflags_now = gi.cvar("dmflags", "").string
    if teamplay == "0" then
        local plrcount = #ex.players
        if plrcount == 1 then
            override_dmflags()
            for i=1, #msg do msg[i] = nil end -- empty msg table before storing new messages
            msg[1] = '* * * You are alone on this server * * *\n'
            msg[2] = '* * * I\'ve disabled fall damage again so you can fool around while you wait for someone to join <3 * * *\n'
            sendMsg = true
            SendMsgAt = os.time() + delay
        elseif plrcount > 1 and dmflags_now ~= dmflags_bak then
            restore_dmflags()
            for i=1, #msg do msg[i] = nil end -- empty msg table before storing new messages
            msg[1] = '* * * WOHOO, you are now atleast two players, ACTION! * * *\n'
            sendMsg = true
            SendMsgAt = os.time() + delay
        end
    elseif teamplay == "1" then
        if not plrInBothTeams then
            override_dmflags()
            for i=1, #msg do msg[i] = nil end -- empty msg table before storing new messages
            msg[1] = '* * * There are not players in both teams * * *\n'
            msg[2] = '* * * I\'ve disabled fall damage so you can fool around while you wait * * *\n'
            sendMsg = true
            SendMsgAt = os.time() + delay
        elseif plrInBothTeams and dmflags_now == "8" then
            restore_dmflags()
            for i=1, #msg do msg[i] = nil end -- empty msg table before storing new messages
            msg[1] = '* * * Both teams has players, ACTION * * *\n'
            sendMsg = true
            SendMsgAt = os.time() + delay
        end
    end
end

function LogMessage(msg)
    local name = string.match(msg, "(.+) entered the game")
    if name ~= nil then
        name = nil
        setdmflags()
    end
    local name = string.match(msg, "(.+) disconnected")
    if name ~= nil then
        name = nil
        setdmflags()
    end
    local name = string.match(msg, "The round will begin in (.+) seconds!")
    if name ~= nil then
        name = nil
        plrInBothTeams = true
        setdmflags()
    end
    local name = string.match(msg, "Not enough players to play!")
    if name ~= nil then
        name = nil
        plrInBothTeams = false
        setdmflags()
    end
end

function RunFrame()
    if sendMsg then
        if SendMsgAt <= os.time() then
            for i=1, #msg do
                gi.bprintf(PRINT_CHAT, msg[i])
                msg[i] = nil
            end
            sendMsg = false
        end
    end
end

function q2a_load(config)
    gi.dprintf("public.lua: q2a_load(): "..version.." for Action Quake 2 loaded.\n")
end

function q2a_unload(config)
    gi.dprintf("public.lua: q2a_load(): setting dmflags back to default ("..dmflags_bak..")\n")
end