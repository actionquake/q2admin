--
-- Q2Admin example configuration
-- 
-- rename to "config.lua" and place this to quake 2 root
--

plugins = {
    lrcon = {
        quit_on_empty = true,
        cvars = {
            -- server
            'password', 'maxclients', 'timelimit', 'dmflags', 'sv_gravity', 'sv_iplimit', 'fraglimit',
            'sv_anticheat_required','sv_fps',

            -- mod
            'teamplay', 'ctf', 'matchmode', 'roundtimelimit', 'tgren', 'limchasecam', 'forcedteamtalk',
            'mm_forceteamtalk', 'ir', 'wp_flags', 'itm_flags', 'hc_single', 'use_punch',  'darkmatch',
            'allitem', 'allweapon', 'use_3teams'
        }
       },
        mvd = {
            mvd_webby = 'https://demos.aq2world.com',
            exec_script_on_system_after_recording = '/aq2server/plugins/mvd_transfer.sh',
            exec_script_cvars_as_parameters = {"q2a_mvd_file", "s3cmd"},
            needs_cvar_q2a_mvd_autorecord = false
        }
    },
    coinflip = {}, -- Heads & Tails script
    broadcast = {}, -- Broadcast script
    version = {}, -- version feedback script
    mvd2cprints = {}, -- store centerprints from AQ2 into MVD2
    scoreboardStore = {}, -- store scoreboard at match end into MVD2
}
