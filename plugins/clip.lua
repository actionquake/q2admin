-- q2clip script by TgT
--[[

CHANGELOG
v1.0 initial release, should work if q2a_mvd plugin by Haui is enabled
TODO:

]]--

local version = "1.0"
local q2mvd = gi.cvar("q2a_mvd", "").string

if q2mvd == "" then
    gi.dprintf("Q2A Lua: (clip.lua) WARNING: This script only loads when plugin q2mvd enabled!\n")
    return 0
end

function q2a_load()
	gi.dprintf("q2client version "..version.." script loaded\n")
end

gi.AddCommandString("sets q2a_clip "..version.."\n")

local file
local fileStr
local mvd2_time
local mvd2_now
local demosDir = "action/demos/"



function ClientCommand(client)
	cmd = gi.argv(1)
	if cmd == "!clip" then
		if gi.argc() == 2 then
			if fileStr then
				mvd2_now = os.time()
				local mvd2_pos = mvd2_now - mvd2_time
				gi.cprintf(client,PRINT_HIGH,"*** Clipped to %s\n*** MVD2 positin is at %d seconds\n", fileStr, mvd2_pos)
				file = demosDir..fileStr
				local logfd = io.open(file..".txt", "a+")
				if not logfd then return end
				logfd:write(mvd2_pos.."\t\t"..gi.argv(2).."\n")
				logfd:close()
				
			else
				local owner = gi.cvar("_admin", "").string
				if owner == "" then owner = "Admin" end
				gi.cprintf(client,PRINT_HIGH, "This server does not record MVDs. Contact: %s!\n", owner)
			end
			return true
		else
			gi.cprintf(client,PRINT_HIGH,"USAGE: !clip name/id\n")
		end
		return true
	end
	return false
end

function LogMessage(msg)
		fileStr = string.match(msg,"started: (.+).mvd2.gz")
		if fileStr then
			mvd2_time = os.time()
		end
end
