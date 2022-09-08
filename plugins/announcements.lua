--[[
LUA script for multi-server announcements
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
  automatically download centralized announcement list from from GitHub
  utilize the broadcast lua feature to send messages in servers on an interval

TODO
 - fill this in
------------------------------
plugins = {
    some_other_plugin = {
        blah = "blah"
    },
    announcements = {
        root_dir = '/aq2server',  -- rootdir of this server
        url = 'https://raw.githubusercontent.com/actionquake/dist/master/scripts/announcements.txt', -- url to download announcements.txt
    }, -- downloads and executes announcements list
}
------------------------------

--]]

local version = "1.0"
local root_dir -- set this in config.lua
local url -- set this in config.lua
local announcements
local game = gi.cvar("game", "").string

function wait (millisecond)
end
 
gi.AddCommandString("set q2a_announcements "..version.."\n")

function announce_os_exec(script)
    os.execute(script)
    wait(1000) -- wait 1s to make sure download is complete and went smooth
    gi.AddCommandString("exec h_cvarbans.cfg\n") -- execute the file
    local last_update = os.date()
    gi.AddCommandString('set announcements '..last_update..'\n') -- write update time to cvar
end

function checkcvarbans()
    gi.AddCommandString("checkcvarbans\n")
    gi.dprintf("checking all clients cvars\n")
end

-- log illegal cvar settings
function ClientCommand(client)
  if(gi.argv(1) == 'cvarbanlog->') then
      local plr = ex.players[client]
      local ip = string.match(plr.ip, '^([^:]+)')
      local now = os.time()
      local logmsg = gi.argv(2).." "..gi.argv(3).." "..gi.argv(4).." "..gi.argv(5).." "..gi.argv(6).." "..gi.argv(7).." "..gi.argv(8).." "..gi.argv(9)
      if gi.argc() == 1 then
        return false
      else
        gi.dprintf("[cvarbans.lua] [%s (%s)] "..logmsg.." \n", ex.players[client].name, ex.players[client].ip)
        return true
      end
      return false
  end
  return false
end

function q2a_load(config)
  gi.dprintf("announcements.lua q2a_load(): "..version.." for Action Quake 2 loaded.\n")
  
  root_dir = config.root_dir
  url = config.url
  if root_dir == nil then
    gi.dprintf("announcements.lua q2a_load(): 'root_dir' not defined in the config.lua file... aborting\n")
    return 0
  end
  if url == nil then
    gi.dprintf("announcements.lua q2a_load(): 'url' not defined in the config.lua file... aborting\n")
    return 0
  end

  gi.dprintf("announcements.lua q2a_load(): Checking/Downloading new announcements... ")
  announcements = root_dir..'plugins/announcements.sh  "'..url..'" "'..game..'"'
  announce_os_exec(announcements) -- check for updated announcements on load
end