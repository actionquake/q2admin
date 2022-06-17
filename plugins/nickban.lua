local banned = { "player", "nameless jerk", "suislide", "unnamed", "nigger", "n1gg3r", "negro", "n3gro", "n3gr0", "hitler", "h1tl3r", "h1tler" }

function ClientConnect(client, userinfo)
    local name = string.lower(Info_ValueForKey(userinfo, "name"))
    for k,v in pairs(banned) do
        if v == name then
            Info_SetValueForKey(userinfo, "rejmsg", "This name ("..v..") is banned, please use another one.")
            return false
        end
    end

    return true
end

function ClientUserinfoChanged(client, userinfo)
    local name = string.lower(Info_ValueForKey(userinfo, "name"))
    for k,v in pairs(banned) do
        if v == name then
            Info_SetValueForKey(userinfo, "name", players[client].name)
            gi.cprintf(client, PRINT_HIGH, "Name "..v.." is not available.\n")
            return
        end
    end
end
