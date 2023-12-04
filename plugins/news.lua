local version = "1.0"
gi.AddCommandString("set q2a_news "..version.."\n")

local broadcasts = {}

function wait (millisecond)
end

function news_os_exec(script)
    os.execute(script)
    wait(1000) -- wait 1s to make sure download is complete and went smooth
    for line in io.lines('action/broadcasts.txt') do
        table.insert(broadcasts, line)
    end
    local last_update = os.date()
    gi.AddCommandString('sets news_update '..last_update..'\n') -- write update time to cvar
end

function q2a_load(config)
    gi.dprintf("news.lua q2a_load(): "..version.." for Action Quake 2 loaded.\n")
    
    root_dir = config.root_dir
    url = config.url
    if root_dir == nil then
      gi.dprintf("news.lua q2a_load(): 'root_dir' not defined in the config.lua file... aborting\n")
      return 0
    end
    if url == nil then
      gi.dprintf("news.lua q2a_load(): 'url' not defined in the config.lua file... aborting\n")
      return 0
    end
  
    gi.dprintf("news.lua q2a_load(): Checking/Downloading news... ")
    news_update = root_dir..'plugins/news_update.sh  "'..url..'" '
    news_os_exec(cvarbans_update) -- check for updated cvarbanlist on load
end


local current_index = 1
local last_check = os.time()

function RunFrame()
    local now = os.time()

    if now - last_check >= 600 then  -- 600 seconds = 10 minutes
        local bcast = broadcasts[current_index]
        gi.bprintf(PRINT_CHAT, '*** '..bcast..'\n')

        current_index = current_index + 1
        if current_index > #broadcasts then
            current_index = 1
        end

        last_check = now
    end
end
