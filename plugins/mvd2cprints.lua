--[[
MVDTOOL https://git.skuller.net/mvdtool/
A tool ignores centerprints (Accuracy,Impressive,Excellent,ACTION!) in Action Q2 mod and should be fixed in a program itself but...skuller is gone :(
Anyway, this script stores that information as a different print level and shown nicely with MVDTOOL
e.g.
[0:44.9] ACTION!
[0:46.7] ACCURACY oke!
[0:46.8] wat caught oke's flying knife with her forehead
--]]

local mvdfix = 1
function q2a_load()
    gi.AddCommandString("sets q2a_mvd2cprints "..mvdfix.."\n")
end

function LogMessage(msg)
        if string.match(msg,"ACTION!") then
                gi.bprintf(PRINT_LOW,"MVD %s",msg)
        end
        if  string.match(msg,"ACCURACY.+") then
                gi.bprintf(PRINT_LOW,"MVD %s",msg)
        end
        if  string.match(msg,"IMPRESSIVE.+") then
                gi.bprintf(PRINT_LOW,"MVD %s",msg)
        end
        if  string.match(msg,"EXCELLENT.+") then
                gi.bprintf(PRINT_LOW,"MVD %s",msg)
        end
end
