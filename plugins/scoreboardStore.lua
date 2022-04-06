
-- 
-- Simple script to grab and store AQ2-TNG 2nd scoreboard into a MVD2 file in a Matchmode.
--
-- Requirements:
-- mvd.lua v1.8
--
-- TODO: 
-- Make it work with Teamplay too...
-- Changelog:
-- v1.0: initial script

function LogMessage(msg)
        if string.match(msg,"Match is.+") then
                MVD_scoreBoard2()
        end
end

function MVD_scoreBoard2()
        for i,plr in pairs(ex.players) do
                if plr.name == "[MVDSPEC]" then
                        id = i - 1
                        gi.AddCommandString("stuff "..id.." putaway${sc}score${sc}score${sc}wait 10${sc}putaway")
                end

        end
end
