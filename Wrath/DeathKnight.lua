if UnitClassBase( 'player' ) ~= 'DEATHKNIGHT' then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local spec = Hekili:NewSpecialization( 6 )

-- ============================================================================
-- 泰坦服符文索引配置 by 风雪 20251228
-- WotLK 标准布局: 1-2=鲜血, 3-4=邪恶, 5-6=冰霜
-- 如果泰坦服使用不同布局，修改这里的索引
-- ============================================================================
local RUNE_INDEX = {
    BLOOD = { 1, 2 },      -- 鲜血符文索引
    UNHOLY = { 3, 4 },     -- 邪恶符文索引
    FROST = { 5, 6 },      -- 冰霜符文索引
}

-- 获取符文冷却的辅助函数（带错误处理）
local function SafeGetRuneCooldown( index )
    local start, duration, ready = GetRuneCooldown( index )
    start = start or 0
    duration = duration or 10
    return start, duration, ready
end

spec:RegisterResource( Enum.PowerType.RuneBlood, {
    rune_regen = {
        last = function ()
            return state.query_time
        end,

        interval = function( time, val )
            local r = state.blood_runes

            if val == 2 then return -1 end
            return r.expiry[ val + 1 ] - time
        end,

        stop = function( x )
            return x == 2
        end,

        value = 1
    },
}, setmetatable( {
    expiry = { 0, 0 },
    cooldown = 10,
    regen = 0,
    max = 2,
    forecast = {},
    fcount = 0,
    times = {},
    values = {},
    resource = "blood_runes",

    reset = function()
        local t = state.blood_runes

        for i = 1, 2 do
            local runeIndex = RUNE_INDEX.BLOOD[ i ]
            local start, duration, ready = SafeGetRuneCooldown( runeIndex )

            duration = duration or ( 10 * state.haste )

            t.expiry[ i ] = ready and 0 or start + duration
            t.cooldown = duration
        end

        table.sort( t.expiry )

        t.actual = nil
    end,

    gain = function( amount )
        local t = state.blood_runes

        for i = 1, amount do
            t.expiry[ 3 - i ] = 0
        end
        table.sort( t.expiry )

        t.actual = nil
    end,

    spend = function( amount )
        local t = state.blood_runes

        for i = 1, amount do
            t.expiry[ 1 ] = ( t.expiry[ 2 ] > 0 and t.expiry[ 2 ] or state.query_time ) + t.cooldown
            table.sort( t.expiry )
        end

        t.actual = nil
    end,

    timeTo = function( x )
        return state:TimeToResource( state.blood_runes, x )
    end,
}, {
    __index = function( t, k, v )
        if k == "actual" then
            local amount = 0

            for i = 1, 2 do
                if t.expiry[ i ] <= state.query_time then
                    amount = amount + 1
                end
            end

            return amount

        elseif k == "current" then
            -- If this is a modeled resource, use our lookup system.
            if t.forecast and t.fcount > 0 then
                local q = state.query_time
                local index, slice

                if t.values[ q ] then return t.values[ q ] end

                for i = 1, t.fcount do
                    local v = t.forecast[ i ]
                    if v.t <= q then
                        index = i
                        slice = v
                    else
                        break
                    end
                end

                -- We have a slice.
                if index and slice then
                    t.values[ q ] = max( 0, min( t.max, slice.v ) )
                    return t.values[ q ]
                end
            end

            return t.actual

        elseif k == "deficit" then
            return t.max - t.current

        elseif k == "time_to_next" then
            return t[ "time_to_" .. t.current + 1 ]

        elseif k == "time_to_max" then
            return t.current == 2 and 0 or max( 0, t.expiry[2] - state.query_time )

        elseif k == "add" then
            return t.gain

        elseif k == "regen" then
            return 0

        else
            local amount = k:match( "time_to_(%d+)" )
            amount = amount and tonumber( amount )

            if amount then return state:TimeToResource( t, amount ) end
        end
    end
} ) )

spec:RegisterResource( Enum.PowerType.RuneFrost, {
    rune_regen = {
        last = function ()
            return state.query_time
        end,

        interval = function( time, val )
            local r = state.frost_runes

            if val == 2 then return -1 end
            return r.expiry[ val + 1 ] - time
        end,

        stop = function( x )
            return x == 2
        end,

        value = 1
    },
}, setmetatable( {
    expiry = { 0, 0 },
    cooldown = 10,
    regen = 0,
    max = 2,
    forecast = {},
    fcount = 0,
    times = {},
    values = {},
    resource = "frost_runes",

    reset = function()
        local t = state.frost_runes

        for i = 1, 2 do
            local runeIndex = RUNE_INDEX.FROST[ i ]
            local start, duration, ready = SafeGetRuneCooldown( runeIndex )

            duration = duration or ( 10 * state.haste )

            t.expiry[ i ] = ready and 0 or start + duration
            t.cooldown = duration
        end

        table.sort( t.expiry )

        t.actual = nil
    end,

    gain = function( amount )
        local t = state.frost_runes

        amount = min( 2, amount )

        for i = 1, amount do
            t.expiry[ i ] = 0
        end
        table.sort( t.expiry )

        t.actual = nil
    end,

    spend = function( amount )
        local t = state.frost_runes

        amount = min( 2, amount )

        for i = 1, amount do
            t.expiry[ 1 ] = ( t.expiry[ 2 ] > 0 and t.expiry[ 2 ] or state.query_time ) + t.cooldown
            table.sort( t.expiry )
        end

        t.actual = nil
    end,

    timeTo = function( x )
        return state:TimeToResource( state.frost_runes, x )
    end,
}, {
    __index = function( t, k, v )
        if k == "actual" then
            local amount = 0

            for i = 1, 2 do
                if t.expiry[ i ] <= state.query_time then
                    amount = amount + 1
                end
            end

            return amount

        elseif k == "current" then
            -- If this is a modeled resource, use our lookup system.
            if t.forecast and t.fcount > 0 then
                local q = state.query_time
                local index, slice

                if t.values[ q ] then return t.values[ q ] end

                for i = 1, t.fcount do
                    local v = t.forecast[ i ]
                    if v.t <= q then
                        index = i
                        slice = v
                    else
                        break
                    end
                end

                -- We have a slice.
                if index and slice then
                    t.values[ q ] = max( 0, min( t.max, slice.v ) )
                    return t.values[ q ]
                end
            end

            return t.actual

        elseif k == "deficit" then
            return t.max - t.current

        elseif k == "time_to_next" then
            return t[ "time_to_" .. t.current + 1 ]

        elseif k == "time_to_max" then
            return t.current == 2 and 0 or max( 0, t.expiry[ 2 ] - state.query_time )

        elseif k == "add" then
            return t.gain

        elseif k == "regen" then
            return 0

        else
            local amount = k:match( "time_to_(%d+)" )
            amount = amount and tonumber( amount )

            if amount then return state:TimeToResource( t, amount ) end
        end
    end
} ) )

spec:RegisterResource( Enum.PowerType.RuneUnholy, {
    rune_regen = {
        last = function ()
            return state.query_time
        end,

        interval = function( time, val )
            local r = state.unholy_runes

            if val == 2 then return -1 end
            return r.expiry[ val + 1 ] - time
        end,

        stop = function( x )
            return x == 2
        end,

        value = 1
    },
}, setmetatable( {
    expiry = { 0, 0 },
    cooldown = 10,
    regen = 0,
    max = 2,
    forecast = {},
    fcount = 0,
    times = {},
    values = {},
    resource = "unholy_runes",

    reset = function()
        local t = state.unholy_runes

        for i = 1, 2 do
            local runeIndex = RUNE_INDEX.UNHOLY[ i ]
            local start, duration, ready = SafeGetRuneCooldown( runeIndex )

            duration = duration or ( 10 * state.haste )

            t.expiry[ i ] = ready and 0 or start + duration
            t.cooldown = duration
        end

        table.sort( t.expiry )

        t.actual = nil
    end,

    gain = function( amount )
        local t = state.unholy_runes

        amount = min( amount, 2 )

        for i = 1, amount do
            t.expiry[ i ] = 0
        end
        table.sort( t.expiry )

        t.actual = nil
    end,

    spend = function( amount )
        local t = state.unholy_runes

        amount = min( 2, amount )

        for i = 1, amount do
            t.expiry[ 1 ] = ( t.expiry[ 2 ] > 0 and t.expiry[ 2 ] or state.query_time ) + t.cooldown
            table.sort( t.expiry )
        end

        t.actual = nil
    end,

    timeTo = function( x )
        return state:TimeToResource( state.unholy_runes, x )
    end,
}, {
    __index = function( t, k, v )
        if k == "actual" then
            local amount = 0

            for i = 1, 2 do
                if t.expiry[ i ] <= state.query_time then
                    amount = amount + 1
                end
            end

            return amount

        elseif k == "current" then
            -- If this is a modeled resource, use our lookup system.
            if t.forecast and t.fcount > 0 then
                local q = state.query_time
                local index, slice

                if t.values[ q ] then return t.values[ q ] end

                for i = 1, t.fcount do
                    local v = t.forecast[ i ]
                    if v.t <= q then
                        index = i
                        slice = v
                    else
                        break
                    end
                end

                -- We have a slice.
                if index and slice then
                    t.values[ q ] = max( 0, min( t.max, slice.v ) )
                    return t.values[ q ]
                end
            end

            return t.actual

        elseif k == "deficit" then
            return t.max - t.current

        elseif k == "time_to_next" then
            return t[ "time_to_" .. t.current + 1 ]

        elseif k == "time_to_max" then
            return t.current == 2 and 0 or max( 0, t.expiry[2] - state.query_time )

        elseif k == "add" then
            return t.gain

        elseif k == "regen" then
            return 0

        else
            local amount = k:match( "time_to_(%d+)" )
            amount = amount and tonumber( amount )

            if amount then return state:TimeToResource( t, amount ) end
        end
    end
} ) )

spec:RegisterResource( Enum.PowerType.RunicPower )
-- butchery talent should generate 1 RP every 5/2.5 seconds depending on rank.
-- scent_of_blood should generate 10 RP on next attack.


-- Talents
spec:RegisterTalents( {
    abominations_might              = {  2105, 2, 53137, 53138 },
    acclimation                     = {  1997, 3, 49200, 50151, 50152 },
    annihilation                    = {  2048, 3, 51468, 51472, 51473 },
    anticipation                    = {  2218, 5, 55129, 55130, 55131, 55132, 55133 },
    antimagic_zone                  = {  2221, 1, 51052 },
    black_ice                       = {  1973, 5, 49140, 49661, 49662, 49663, 49664 },
    blade_barrier                   = {  2017, 5, 49182, 49500, 49501, 55225, 55226 },
    bladed_armor                    = {  1938, 5, 48978, 49390, 49391, 49392, 49393 },
    blood_gorged                    = {  2034, 5, 61154, 61155, 61156, 61157, 61158 },
    blood_of_the_north              = {  2210, 3, 54639, 54638, 54637 },
    bloodcaked_blade                = {  2004, 3, 49219, 49627, 49628 },
    bloodworms                      = {  1960, 3, 49027, 49542, 49543 },
    bloody_strikes                  = {  2015, 3, 48977, 49394, 49395 },
    bloody_vengeance                = {  1944, 3, 48988, 49503, 49504 },
    bone_shield                     = {  2007, 1, 49222 },
    butchery                        = {  1939, 2, 48979, 49483 },
    chilblains                      = {  2260, 3, 50040, 50041, 50043 },
    chill_of_the_grave              = {  1981, 2, 49149, 50115 },
    corpse_explosion                = {  1985, 1, 49158 },
    crypt_fever                     = {  1962, 3, 49032, 49631, 49632 },
    dancing_rune_weapon             = {  1961, 1, 49028 },
    dark_conviction                 = {  1943, 5, 48987, 49477, 49478, 49479, 49480 },
    death_rune_mastery              = {  2086, 3, 49467, 50033, 50034 },
    deathchill                      = {  1980, 1, 49796 },
    desecration                     = {  2226, 2, 55666, 55667 },
    desolation                      = {  2285, 5, 66799, 66814, 66815, 66816, 66817 },
    dirge                           = {  2011, 2, 49223, 49599 },
    ebon_plaguebringer              = {  2043, 3, 51099, 51160, 51161 },
    endless_winter                  = {  1971, 2, 49137, 49657 },
    epidemic                        = {  1963, 2, 49036, 49562 },
    frigid_dreadplate               = {  1990, 3, 49186, 51108, 51109 },
    frost_strike                    = {  1975, 1, 49143 },
    ghoul_frenzy                    = {  2085, 1, 63560 },
    glacier_rot                     = {  2030, 3, 49471, 49790, 49791 },
    guile_of_gorefiend              = {  2040, 3, 50187, 50190, 50191 },
    heart_strike                    = {  1957, 1, 55050 },
    howling_blast                   = {  1989, 1, 49184 },
    hungering_cold                  = {  1999, 1, 49203 },
    icy_reach                       = {  2035, 2, 55061, 55062 },
    icy_talons                      = {  2042, 5, 50880, 50884, 50885, 50886, 50887 },
    improved_blood_presence         = {  1936, 2, 50365, 50371 },
    improved_death_strike           = {  2259, 2, 62905, 62908 },
    improved_frost_presence         = {  2029, 2, 50384, 50385 },
    improved_icy_talons             = {  2223, 1, 55610 },
    improved_icy_touch              = {  2031, 3, 49175, 50031, 51456 },
    improved_rune_tap               = {  1942, 3, 48985, 49488, 49489 },
    improved_unholy_presence        = {  2013, 2, 50391, 50392 },
    impurity                        = {  2005, 5, 49220, 49633, 49635, 49636, 49638 },
    killing_machine                 = {  2044, 5, 51123, 51127, 51128, 51129, 51130 },
    lichborne                       = {  2215, 1, 49039 },
    magic_suppression               = {  2009, 3, 49224, 49610, 49611 },
    mark_of_blood                   = {  1949, 1, 49005 },
    master_of_ghouls                = {  1984, 1, 52143 },
    merciless_combat                = {  1993, 2, 49024, 49538 },
    might_of_mograine               = {  1958, 3, 49023, 49533, 49534 },
    morbidity                       = {  1933, 3, 48963, 49564, 49565 },
    necrosis                        = {  2047, 5, 51459, 51462, 51463, 51464, 51465 },
    nerves_of_cold_steel            = {  2022, 3, 49226, 50137, 50138 },
    night_of_the_dead               = {  2225, 2, 55620, 55623 },
    on_a_pale_horse                 = {  2039, 2, 49146, 51267 },
    outbreak                        = {  2008, 3, 49013, 55236, 55237 },
    rage_of_rivendare               = {  2036, 5, 50117, 50118, 50119, 50120, 50121 },
    ravenous_dead                   = {  1934, 3, 48965, 49571, 49572 },
    reaping                         = {  2001, 3, 49208, 56834, 56835 },
    rime                            = {  1992, 3, 49188, 56822, 59057 },
    rune_tap                        = {  1941, 1, 48982 },
    runic_power_mastery             = {  2020, 2, 49455, 50147 },
    scent_of_blood                  = {  1948, 3, 49004, 49508, 49509 },
    scourge_strike                  = {  2216, 1, 55090 },
    spell_deflection                = {  2018, 3, 49145, 49495, 49497 },
    subversion                      = {  1945, 3, 48997, 49490, 49491 },
    sudden_doom                     = {  1955, 3, 49018, 49529, 49530 },
    summon_gargoyle                 = {  2000, 1, 49206 },
    threat_of_thassarian            = {  2284, 3, 65661, 66191, 66192 },
    toughness                       = {  1968, 5, 49042, 49786, 49787, 49788, 49789 },
    tundra_stalker                  = {  1998, 5, 49202, 50127, 50128, 50129, 50130 },
    twohanded_weapon_specialization = {  2217, 2, 55107, 55108 },
    unbreakable_armor               = {  1979, 1, 51271 },
    unholy_blight                   = {  1996, 1, 49194 },
    unholy_command                  = {  2025, 2, 49588, 49589 },
    unholy_frenzy                   = {  1954, 1, 49016 },
    vampiric_blood                  = {  2019, 1, 55233 },
    vendetta                        = {  1953, 3, 49015, 50154, 55136 },
    veteran_of_the_third_war        = {  1950, 3, 49006, 49526, 50029 },
    vicious_strikes                 = {  2082, 2, 51745, 51746 },
    virulence                       = {  1932, 3, 48962, 49567, 49568 },
    wandering_plague                = {  2003, 3, 49217, 49654, 49655 },
    will_of_the_necropolis          = {  1959, 3, 49189, 50149, 50150 },
} )


-- Glyphs
spec:RegisterGlyphs( {
    [58623] = "antimagic_shell",
    [59332] = "blood_strike",
    [58640] = "blood_tap",
    [58673] = "bone_shield",
    [58620] = "chains_of_ice",
    [59307] = "corpse_explosion",
    [63330] = "dancing_rune_weapon",
    [58613] = "dark_command",
    [63333] = "dark_death",
    [58629] = "death_and_decay",
    [62259] = "death_grip",
    [59336] = "death_strike",
    [58677] = "deaths_embrace",
    [63334] = "disease",
    [58647] = "frost_strike",
    [58616] = "heart_strike",
    [58680] = "horn_of_winter",
    [63335] = "howling_blast",
    [63331] = "hungering_cold",
    [58625] = "icebound_fortitude",
    [58631] = "icy_touch",
    [58671] = "obliterate",
    [59309] = "pestilence",
    [58657] = "plague_strike",
    [58669] = "rune_strike",
    [59327] = "rune_tap",
    [58618] = "strangulate",
    [60200] = "raise_dead",  -- 亡者复生雕文 (法术ID，物品ID是43673)
    [58635] = "unbreakable_armor",
    [63332] = "unholy_blight",
    [58676] = "vampiric_blood",
} )


-- Auras
spec:RegisterAuras( {
    -- 新增恶意魔印buff不洁之力 by风雪20250413
    unholy_force = {
        id = 67383,
        duration = 20,
        max_stack = 1,
    },
    -- 泰坦服啜血buff - 下一次枯萎凋零不消耗鲜血和冰霜符文
    chuoxue = {
        id = 1282343,
        name = "啜血",
        duration = 10,
        max_stack = 1,
    },
    -- Spell damage reduced by $s1%.  Immune to magic debuffs.
    antimagic_shell = {
        id = 48707,
        duration = function() return glyph.antimagic_shell.enabled and 7 or 5 end,
        max_stack = 1,
    },
    antimagic_zone = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=51052)
        id = 51052,
        duration = 10,
        max_stack = 1,
    },
    army_of_the_dead = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=42651)
        id = 42651,
        duration = 40,
        max_stack = 1,
        copy = { 42651, 42650 },
    },
    -- $s1% less damage taken.
    blade_barrier = {
        id = 64859,
        duration = 10,
        max_stack = 1,
        copy = { 51789, 64855, 64856, 64858, 64859 },
    },
    -- Deals Shadow damage over $d.
    blood_plague = {
        id = 55078,
        duration = function () return 15 + ( 3 * talent.epidemic.rank ) end,
        tick_time = 3,
        max_stack = 1,
    },
    -- Damage increased by $48266s1%.  Healed by $50371s1% of non-periodic damage dealt.
    blood_presence = {
        id = 48266,
        duration = 3600,
        max_stack = 1,
    },
    -- Blood Rune converted to a Death Rune.
    blood_tap = {
        id = 45529,
        duration = 20,
        max_stack = 1,
    },
    bloodworm = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=50452)
        id = 50452,
        duration = 20,
        max_stack = 1,
    },
    -- Physical damage increased by $s1%.
    bloody_vengeance = {
        id = 50449,
        duration = 30,
        max_stack = 3,
        copy = { 50449, 50448, 50447 },
    },
    -- Damage reduced by $s1%.
    bone_shield = {
        id = 49222,
        duration = 300,
        max_stack = function () return glyph.bone_shield.enabled and 4 or 3 end,
    },
    -- Slowed by frozen chains.
    chains_of_ice = {
        id = 45524,
        duration = 10,
        max_stack = 1,
    },
    -- Increases disease damage taken.
    crypt_fever = {
        id = 50508,
        duration = 15,
        max_stack = 1,
        copy = { 50509, 50510 }
    },
    -- You have recently summoned a rune weapon.
    dancing_rune_weapon = {
        id = 49028,
        duration = function() return glyph.dancing_rune_weapon.enabled and 17 or 12 end,
        max_stack = 1,
    },
    -- Taunted.
    dark_command = {
        id = 56222,
        duration = 3,
        max_stack = 1,
    },
    -- $s1 Shadow damage inflicted every sec
    death_and_decay = {
        id = 49938,
        duration = 10,
        tick_time = 1,
        max_stack = 1,
        copy = { 43265, 49936, 49937, 49938 },
    },
    death_gate = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=50977)
        id = 50977,
        duration = 60,
        max_stack = 1,
    },
    -- Taunted.
    death_grip = {
        id = 49575,
        duration = 3,
        max_stack = 1
    },
    -- Your next Icy Touch, Howling Blast, Frost Strike or Obliterate has a 100% chance to critically hit.
    deathchill = {
        id = 49796,
        duration = 30,
        max_stack = 1,
    },
    -- Standing upon unholy ground.   Movement speed is reduced by $s1%.
    desecration = {
        id = 68766,
        duration = 20,
        max_stack = 1,
        copy = { 68766, 55741 },
    },
    -- Damage dealt is increased by $s1%.
    desolation = {
        id = 66803,
        duration = 20,
        max_stack = 1,
        copy = { 66803, 66802, 66801, 66800, 63583 },
    },
    -- Crypt Fever, improved by Ebon Plaguebringer.
    ebon_plague = {
        id = 51735,
        duration = 15,
        max_stack = 1,
        copy = { 51726, 51734 }
    },
    -- Your next Howling Blast will consume no runes.
    freezing_fog = {
        id = 59052,
        duration = 15,
        max_stack = 1,
        copy = "rime"
    },
    -- Deals Frost damage over $d.  Reduces melee and ranged attack speed.
    frost_fever = {
        id = 55095,
        duration = function () return 15 + ( 3 * talent.epidemic.rank ) end,
        tick_time = 3,
        max_stack = 1,
    },
    -- Stamina increased by $61261s1%.  Armor contribution from cloth, leather, mail and plate items increased by $48263s1%.  Damage taken reduced by $48263s3%.
    frost_presence = {
        id = 48263,
        duration = 3600,
        max_stack = 1,
    },
    -- Decreases the time between attacks by $s2% and heals $s1% every $t1 sec.
    ghoul_frenzy = {
        id = 63560,
        duration = 30,
        tick_time = 3,
        max_stack = 1,
        generate = function ( t )
            -- 尝试多个可能的 spell ID
            local name, _, count, _, duration, expires, caster = FindUnitBuffByID( "pet", 63560 )
            
            -- 如果找不到，尝试用名字搜索
            if not name then
                for i = 1, 40 do
                    local buffName, _, _, _, buffDuration, buffExpires, buffCaster, _, _, spellId = UnitBuff( "pet", i )
                    if not buffName then break end
                    -- 检查是否是食尸鬼狂乱 (Ghoul Frenzy)
                    if spellId == 63560 or buffName == "Ghoul Frenzy" or buffName == "食尸鬼狂乱" then
                        name = buffName
                        duration = buffDuration
                        expires = buffExpires
                        caster = buffCaster
                        break
                    end
                end
            end

            if name then
                t.name = name
                t.count = 1
                -- 修复：如果 duration 为 0 或 nil，使用默认的 30 秒
                if not duration or duration == 0 then
                    duration = 30
                end
                -- 修复：如果 expires 为 0 或 nil，使用当前时间 + duration
                if not expires or expires == 0 then
                    expires = GetTime() + duration
                end
                t.duration = duration
                t.expires = expires
                t.applied = expires - duration
                t.caster = caster
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    -- Stunned.
    glyph_of_death_grip = {
        id = 58628,
        duration = 1,
        max_stack = 1,
    },
    -- Snare.
    glyph_of_heart_strike = {
        id = 58617,
        duration = 10,
        max_stack = 1,
    },
    -- Damage taken reduced.  Immune to Stun effects.
    icebound_fortitude = {
        id = 48792,
        duration = function () return 12 + ( 3 * talent.guile_of_gorefiend.rank ) end,
        max_stack = 1,
    },
    -- Movement speed reduced by $s1%.
    icy_clutch = {
        id = 50436,
        duration = 10,
        max_stack = 1,
        copy = { 50436, 50435, 50434 },
    },
    -- Your next Icy Touch, Howling Blast or Frost Strike will be a critical strike.
    killing_machine = {
        id = 51124,
        duration = 30,
        max_stack = 1,
    },
    -- Immune to Charm, Fear and Sleep.  Undead.
    lichborne = {
        id = 49039,
        duration = 10,
        max_stack = 1,
    },
    -- Hits by this target restore $s2% health.
    mark_of_blood = {
        id = 49005,
        duration = 20,
        max_stack = 1,
    },
    mind_freeze = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=47528)
        id = 47528,
        duration = 4,
        max_stack = 1,
    },
    -- Grants the ability to walk across water.
    path_of_frost = {
        id = 3714,
        duration = 600,
        max_stack = 1,
    },
    -- Any presence is applied.
    presence = {
        alias = { "blood_presence", "frost_presence", "unholy_presence" },
        aliasMode = "first",
        aliasType = "buff",
    },
    rune_strike = {
        duration = function () return swings.mainhand_speed end,
        max_stack = 1,
    },
    rune_strike_usable = {
        duration = 5,
        max_stack = 1,
    },
    -- Successful attacks generate runic power.
    scent_of_blood = {
        id = 50421,
        duration = 20,
        max_stack = 3,
    },
    -- Silenced.
    strangulate = {
        id = 47476,
        duration = 5,
        max_stack = 1,
    },
    -- Runic Power is being fed to the Gargoyle.
    summon_gargoyle = {
        id = 61777,
        duration = 30,
        max_stack = 1,
        copy = { 61777, 50514, 49206 },
    },
    -- Armor increased by $s1%.  Strength increased by $s2%.
    unbreakable_armor = {
        id = 51271,
        duration = 20,
        max_stack = 1,
    },
    unholy_blight = {
        id = 49222,
        duration = 10,
        max_stack = 1,
    },
    -- Enraged.  Physical damage increased by $s1%.  Health equal to $s2% of maximum health lost every sec.
    unholy_frenzy = {
        id = 49016,
        duration = 30,
        max_stack = 1,
    },
    -- Attack speed increased $s1%.  Movement speed increased by $49772s1%.  Global cooldown on all abilities reduced by ${$m2/-1000}.1 sec.
    unholy_presence = {
        id = 48265,
        duration = 3600,
        max_stack = 1,
    },
    -- Healing improved by $s1%  Maximum health increased by $s2%
    vampiric_blood = {
        id = 55233,
        duration = function() return glyph.vampiric_blood.enabled and 15 or 10 end,
        max_stack = 1,
    },
    -- 啜血 - 下一次枯萎凋零不消耗鲜血和冰霜符文
    chuoxue = {
        id = 1282343,
        duration = 8,
        max_stack = 1,
    },

    -- Death Runes
    death_rune_1 = {
        duration = 30,
        max_stack = 1,
    },
    death_rune_2 = {
        duration = 30,
        max_stack = 1,
    },
    death_rune_3 = {
        duration = 30,
        max_stack = 1,
    },
    death_rune_4 = {
        duration = 30,
        max_stack = 1,
    },
    death_rune_5 = {
        duration = 30,
        max_stack = 1,
    },
    death_rune_6 = {
        duration = 30,
        max_stack = 1,
    },
    -- 狮心 - 人类种族技能buff
    lions_heart = {
        id = 20599,
        duration = 15,
        max_stack = 1,
    },
} )

local dodged_or_parried = 0
local playerGUID = nil

local misses = {
    DODGE = true,
    PARRY = true
}

spec:RegisterEvent( "COMBAT_LOG_EVENT_UNFILTERED", function()
    if not playerGUID then
        playerGUID = UnitGUID("player")
    end
    
    local _, subtype, _,  sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, missType = CombatLogGetCurrentEventInfo()

    -- 符文打击触发条件：死亡骑士躲闪或招架了敌人的攻击
    -- destGUID 是被攻击的目标（玩家），missType 是 DODGE 或 PARRY
    if destGUID == playerGUID and subtype:match( "_MISSED$" ) and misses[ missType ] then
        dodged_or_parried = GetTime()
    end
end )

local finish_rune_strike = setfenv( function()
    spend( 20, "runic_power" )
end, state )

spec:RegisterStateFunction( "start_rune_strike", function()
    removeBuff( "rune_strike_usable" )
    applyBuff( "rune_strike", swings.time_to_next_mainhand )
    state:QueueAuraExpiration( "rune_strike", finish_rune_strike, buff.rune_strike.expires )
end )

local GetRuneType, IsCurrentSpell = _G.GetRuneType, _G.IsCurrentSpell

-- ============================================================================
-- 泰坦服符文系统修复 by 风雪 20251228
-- WotLK 符文布局: 1-2=鲜血, 3-4=邪恶, 5-6=冰霜
-- 死亡符文类型: 通常为 4，但泰坦服可能不同
-- ============================================================================

-- 符文类型常量（兼容不同服务器）
local RUNE_TYPE_BLOOD = 1
local RUNE_TYPE_UNHOLY = 2  
local RUNE_TYPE_FROST = 3
local RUNE_TYPE_DEATH = 4

-- 检测死亡符文类型（泰坦服可能使用不同的值）
local function IsDeathRune( runeIndex )
    local runeType = GetRuneType( runeIndex )
    -- 死亡符文类型通常是 4，但也检查其他可能的值
    -- 如果符文类型与其原始类型不同，且不是 0/nil，可能是死亡符文
    if runeType == RUNE_TYPE_DEATH then
        return true
    end
    
    -- 备用检测：检查符文是否被转换
    -- 鲜血符文(1-2)原始类型应该是1，邪恶(3-4)是2，冰霜(5-6)是3
    local originalType
    if runeIndex <= 2 then
        originalType = RUNE_TYPE_BLOOD
    elseif runeIndex <= 4 then
        originalType = RUNE_TYPE_UNHOLY
    else
        originalType = RUNE_TYPE_FROST
    end
    
    -- 如果当前类型与原始类型不同，可能是死亡符文
    if runeType and runeType ~= originalType and runeType ~= 0 then
        return true
    end
    
    return false
end

-- 食尸鬼宠物注册 - 修复亡者复生有宠物仍显示问题 by 哑吡 20251226
-- 有"亡者大师"天赋时为永久宠物(3600秒)，无天赋时持续60秒
-- 食尸鬼NPC ID: 26125(普通), 可能还有其他变体
spec:RegisterPet( "ghoul", 26125, "raise_dead", 3600 )

-- 修复：添加食尸鬼状态检测钩子 by 哑吡 20251226
-- 直接使用游戏API检测宠物，不依赖NPC ID匹配
spec:RegisterStateExpr( "ghoul_active", function()
    return UnitExists("pet") and not UnitIsDead("pet")
end )

spec:RegisterHook( "reset_precast", function ()
    -- 修复：使用更健壮的死亡符文检测 by 风雪 20251228
    for i = 1, 6 do
        if IsDeathRune( i ) then
            applyBuff( "death_rune_" .. i )
        else
            removeBuff( "death_rune_" .. i )
        end
    end

    -- 符文打击检测：使用游戏API检测技能是否可用，并且符能>=20
    if IsCurrentSpell( class.abilities.rune_strike.id ) then
        start_rune_strike()
    elseif IsUsableSpell( class.abilities.rune_strike.id ) and UnitPower( "player", Enum.PowerType.RunicPower ) >= 20 then
        -- 游戏API显示技能可用且符能足够，直接应用buff
        applyBuff( "rune_strike_usable", 5 )
    elseif dodged_or_parried > 0 and now - dodged_or_parried < 5 then
        -- 备用检测：战斗日志检测到躲闪/招架
        applyBuff( "rune_strike_usable", dodged_or_parried + 5 - now )
    end
    
    -- 修复：强制更新食尸鬼宠物状态和亡者复生冷却 by 哑吡 20251230
    local petExists = UnitExists("pet") and not UnitIsDead("pet") and UnitHealth("pet") > 0
    
    -- 确保 pet.ghoul 表存在
    if not rawget( state.pet, "ghoul" ) then
        state.pet.ghoul = {}
    end
    
    if petExists then
        -- 有宠物存活，设置食尸鬼为激活状态
        local duration = talent.master_of_ghouls.enabled and 3600 or 60
        state.pet.ghoul.name = "ghoul"
        state.pet.ghoul.expires = state.now + duration
        state.pet.ghoul.virtual = true
        
        -- 关键修复：同步亡者复生的实际冷却时间
        local start, cdDuration = GetSpellCooldown( 46584 )
        if start and start > 0 and cdDuration and cdDuration > 0 then
            setCooldown( "raise_dead", start + cdDuration - state.now )
        end
    else
        -- 没有宠物，设置食尸鬼为未激活状态
        state.pet.ghoul.expires = 0
        state.pet.ghoul.virtual = false
    end
end )


-- ============================================================================
-- 泰坦重铸版修复：传染技能辅助函数（必须在 RegisterAbilities 之前定义）
-- ============================================================================
local LibRangeCheck = LibStub("LibRangeCheck-2.0")

-- 追踪传染使用时间，防止重复推荐
local lastPestilenceTime = 0
local PESTILENCE_INTERNAL_CD = 3.0 -- 传染内部冷却时间（秒）

-- 计算姓名板中所有进战斗怪物的总血量百分比
local function getNameplateEnemiesHealthPercent()
    local totalHealth = 0
    local totalMaxHealth = 0
    
    -- 遍历所有姓名板单位
    for i = 1, 40 do
        local unit = "nameplate" .. i
        if UnitExists(unit) and UnitCanAttack("player", unit) and UnitAffectingCombat(unit) then
            local health = UnitHealth(unit) or 0
            local maxHealth = UnitHealthMax(unit) or 1
            if maxHealth > 0 then
                totalHealth = totalHealth + health
                totalMaxHealth = totalMaxHealth + maxHealth
            end
        end
    end
    
    if totalMaxHealth > 0 then
        return (totalHealth / totalMaxHealth) * 100
    end
    return 100 -- 如果没有找到怪物，返回100%避免阻止技能
end

-- 检查单位是否缺少指定疾病
local function hasMissingDisease(unit, spellIDs)
    for i = 1, 40 do
        local _, _, _, _, _, _, source, _, _, spellId = UnitDebuff(unit, i)
        if source and UnitIsUnit(source, "player") then
            for _, id in pairs(spellIDs) do
                if spellId == id then return false end
            end
        end
    end
    return true
end

-- 计算10码内缺少疾病的敌人数量
local function countEnemiesMissingDisease()
    local diseaseIDs = {55095, 55078} -- 冰霜疫病和血之疫病
    local count = 0
    local plates = C_NamePlate.GetNamePlates()
    if not plates then return 0 end
    
    for _, plate in ipairs(plates) do
        local unit = plate.namePlateUnitToken
        if unit and UnitCanAttack("player", unit) and not UnitIsDead(unit) then
            local _, maxRange = LibRangeCheck:GetRange(unit)
            if maxRange and maxRange <= 10 and hasMissingDisease(unit, diseaseIDs) then
                count = count + 1
            end
        end
    end
    return count
end

-- 计算10码内有疾病的敌人数量（不缺少疾病）by 哑吡 20251225
local function countEnemiesWithDisease()
    local diseaseIDs = {55095, 55078} -- 冰霜疫病和血之疫病
    local count = 0
    local plates = C_NamePlate.GetNamePlates()
    if not plates then return 0 end
    
    for _, plate in ipairs(plates) do
        local unit = plate.namePlateUnitToken
        if unit and UnitCanAttack("player", unit) and not UnitIsDead(unit) then
            local _, maxRange = LibRangeCheck:GetRange(unit)
            if maxRange and maxRange <= 10 and not hasMissingDisease(unit, diseaseIDs) then
                count = count + 1
            end
        end
    end
    return count
end
-- ============================================================================


-- Abilities
spec:RegisterAbilities( {
    -- Surrounds the Death Knight in an Anti-Magic Shell, absorbing 75% of the damage dealt by harmful spells (up to a maximum of 50% of the Death Knight's health) and preventing application of harmful magical effects.  Damage absorbed by Anti-Magic Shell energizes the Death Knight with additional runic power.  Lasts 5 sec.
    antimagic_shell = {
        id = 48707,
        cast = 0,
        cooldown = 45,
        gcd = "off",

        spend = 20,
        spendType = "runic_power",

        startsCombat = false,
        texture = 136120,

        toggle = "defensives",

        handler = function ()
            applyBuff( "antimagic_shell" )
        end,
    },


    -- Places a large, stationary Anti-Magic Zone that reduces spell damage done to party or raid members inside it by 75%.  The Anti-Magic Zone lasts for 10 sec or until it absorbs 14308 spell damage.
    antimagic_zone = {
        id = 51052,
        cast = 0,
        cooldown = 120,
        gcd = "off",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            if unholy_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "unholy_runes",

        talent = "antimagic_zone",
        startsCombat = false,
        texture = 237510,

        toggle = "defensives",

        usable = function()
            if unholy_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            applyBuff( "antimagic_zone" )
            if unholy_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- Summons an entire legion of Ghouls to fight for the Death Knight.  The Ghouls will swarm the area, taunting and fighting anything they can.  While channelling Army of the Dead, the Death Knight takes less damage equal to her Dodge plus Parry chance.
    army_of_the_dead = {
        id = 42650,
        cast = 0,
        cooldown = function() return 600 - ( 120 * talent.night_of_the_dead.rank ) end,
        gcd = "spell",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            local hasUnholy = unholy_runes.current >= 1
            local hasFrost = frost_runes.current >= 1
            local hasBlood = blood_runes.current >= 1
            local missing = (hasUnholy and 0 or 1) + (hasFrost and 0 or 1) + (hasBlood and 0 or 1)
            if missing <= death_runes then
                return hasUnholy and 1 or 0
            end
            return 1
        end,
        spendType = "unholy_runes",
        spend2 = function()
            local hasUnholy = unholy_runes.current >= 1
            local hasFrost = frost_runes.current >= 1
            local hasBlood = blood_runes.current >= 1
            local missing = (hasUnholy and 0 or 1) + (hasFrost and 0 or 1) + (hasBlood and 0 or 1)
            if missing <= death_runes then
                return hasFrost and 1 or 0
            end
            return 1
        end,
        spend2Type = "frost_runes",
        spend3 = function()
            local hasUnholy = unholy_runes.current >= 1
            local hasFrost = frost_runes.current >= 1
            local hasBlood = blood_runes.current >= 1
            local missing = (hasUnholy and 0 or 1) + (hasFrost and 0 or 1) + (hasBlood and 0 or 1)
            if missing <= death_runes then
                return hasBlood and 1 or 0
            end
            return 1
        end,
        spend3Type = "blood_runes",

        gain = 15,
        gainType = "runic_power",

        startsCombat = true,
        texture = 237511,

        toggle = "cooldowns",

        usable = function()
            local hasUnholy = unholy_runes.current >= 1
            local hasFrost = frost_runes.current >= 1
            local hasBlood = blood_runes.current >= 1
            local missing = (hasUnholy and 0 or 1) + (hasFrost and 0 or 1) + (hasBlood and 0 or 1)
            if missing <= death_runes then return true end
            return false, "没有足够的符文"
        end,

        timeToReady = function()
            return max( blood_runes.time_to_1, frost_runes.time_to_1, unholy_runes.time_to_1 )
        end,

        start = function ()
            gain( 15, "runic_power" )
            applyBuff( "army_of_the_dead" )
            
            local hasUnholy = unholy_runes.current >= 1
            local hasFrost = frost_runes.current >= 1
            local hasBlood = blood_runes.current >= 1
            local deathRunesUsed = (hasUnholy and 0 or 1) + (hasFrost and 0 or 1) + (hasBlood and 0 or 1)
            for _ = 1, deathRunesUsed do
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- Boils the blood of all enemies within 10 yards, dealing 180 to 220 Shadow damage.  Deals additional damage to targets infected with Blood Plague or Frost Fever.
    blood_boil = {
        id = 49941,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        -- 血沸消耗鲜血符文 - 灵活版 by 哑吡 20250102
        spend = 1,
        spendType = function()
            -- 优先使用鲜血符文
            if blood_runes.current > 0 then return "blood_runes" end
            -- 有死亡符文时可以替代
            if death_runes > 0 then return "death_runes" end
            return "blood_runes"
        end,

        startsCombat = true,
        texture = 237513,

        -- 血液沸腾条件 - 灵活版 by 哑吡 20250102
        usable = function()
            -- 有鲜血符文或死亡符文就可以用
            if blood_runes.current == 0 and death_runes == 0 then
                return false, "没有可用符文"
            end
            return true
        end,

        handler = function ()
            -- 血液沸腾对所有10码内敌人造成暗影伤害
            -- 对有血之疫病或冰霜热疫的目标造成额外伤害
            active_dot.blood_boil = active_enemies
        end,

        copy = { 48721, 49939, 49940, 49941 } --补全各等级技能by风雪 20250901
    },


    -- Strengthens the Death Knight with the presence of blood, increasing damage by 15% and healing the Death Knight by 4% of non-periodic damage dealt. Only one Presence may be active at a time.
    blood_presence = {
        id = 48266,
        cast = 0,
        cooldown = 1,
        gcd = "off",

        -- 修复：添加死亡符文支持 by 哑吡20260103
        spend = function()
            if blood_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "blood_runes",

        startsCombat = false,
        texture = 135770,

        nobuff = "blood_presence",

        usable = function()
            if blood_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            removeBuff( "presence" )
            applyBuff( "blood_presence" )
            if blood_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- Instantly strike the enemy, causing 40% weapon damage plus 306, total damage increased by 12.5% for each of your diseases on the target.
    blood_strike = {
        id = 45902,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            if blood_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "blood_runes",

        gain = 10,
        gainType = "runic_power",

        startsCombat = true,
        texture = 135772,

        usable = function()
            if blood_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            if talent.reaping.rank == 3 then
                if blood_runes.current == 0 then applyBuff( "death_rune_1")
                else applyBuff( "death_rune_2" ) end
            end
            if talent.desolation.enabled then applyBuff( "desolation" ) end
            if blood_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,

        copy = { 49926, 49927, 49928, 49929, 49930 }
    },


    -- Immediately activates a Blood Rune and converts it into a Death Rune for the next 20 sec.  Death Runes count as a Blood, Frost or Unholy Rune.
    blood_tap = {
        id = 45529,
        cast = 0,
        cooldown = 60,
        gcd = "off",

        spend = 487,
        spendType = "health",

        startsCombat = true,
        texture = 237515,

        handler = function ()
            gain( 1, "blood_runes" )
            applyBuff( "blood_tap" )
        end,
    },


    -- The Death Knight is surrounded by 3 whirling bones.  While at least 1 bone remains, she takes 20% less damage from all sources and deals 2% more damage with all attacks, spells and abilities.  Each damaging attack that lands consumes 1 bone.  Lasts 5 min.
    bone_shield = {
        id = 49222,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        -- 修复：添加死亡符文支持 by 哑吡20260103
        spend = function()
            if unholy_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "unholy_runes",

        gain = 10,
        gainType = "runic_power",

        talent = "bone_shield",
        startsCombat = false,
        texture = 132728,

        -- toggle = "defensives", 先注释掉，确保白骨之盾在默认技能下，修改 by 风雪20250413

        usable = function()
            if unholy_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            applyBuff( "bone_shield", nil, glyph.bone_shield.enabled and 4 or 3 )
            if unholy_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- Shackles the target with frozen chains, reducing their movement by 95%, and infects them with Frost Fever.  The target regains 10% of their movement each second for 10 sec.
    chains_of_ice = {
        id = 45524,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        -- 修复：添加死亡符文支持 by 哑吡 20251228
        spend = function() 
            if frost_runes.current >= 1 then
                return 1
            elseif death_runes > 0 then
                return 0
            else
                return 1
            end
        end,
        spendType = "frost_runes",

        gain = function() return 10 + ( 2.5 * talent.chill_of_the_grave.rank ) end,
        gainType = "runic_power",

        startsCombat = true,
        texture = 135834,

        handler = function ()
            applyDebuff( "target", "frost_fever" )
            applyDebuff( "target", "chains_of_ice" )
            -- 修复：当使用死亡符文时，移除一个死亡符文buff by 哑吡 20251228
            if frost_runes.current == 0 and death_runes > 0 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- Cause a corpse to explode for 166 Shadow damage to all enemies within 10 yards.  Will use a nearby corpse if the target is not a corpse.  Does not affect mechanical or elemental corpses.
    corpse_explosion = {
        id = 49158,
        cast = 0,
        cooldown = 5,
        gcd = "spell",

        spend = 40,
        spendType = "runic_power",

        talent = "corpse_explosion",
        startsCombat = false,
        texture = 132099,

        -- TODO:  Determine if I can rely on the UI for usability of Corpse Explosion.

        handler = function ()
            -- 尸体爆炸对10码内所有敌人造成暗影伤害
            -- 需要附近有尸体
        end,
        copy = { 49158, 51325, 51326, 51327, 51328 } --补全各等级技能by风雪 20250901
        
    },


    -- Summons a second rune weapon that fights on its own for 12 sec, doing the same attacks as the Death Knight but for 50% reduced damage.
    dancing_rune_weapon = {
        id = 49028,
        cast = 0,
        cooldown = 90,
        gcd = "spell",

        spend = 60,
        spendType = "runic_power",

        talent = "dancing_rune_weapon",
        startsCombat = false,
        texture = 135277,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "dancing_rune_weapon" )
        end,
    },


    -- Commands the target to attack you, but has no effect if the target is already attacking you.
    dark_command = {
        id = 56222,
        cast = 0,
        cooldown = 8,
        gcd = "off",

        spend = 0,
        spendType = "rage",

        startsCombat = true,
        texture = 136088,

        handler = function ()
            applyDebuff( "target", "dark_command" )
        end,
    },


    -- Corrupts the ground targeted by the Death Knight, causing 62 Shadow damage every sec that targets remain in the area for 10 sec.  This ability produces a high amount of threat.
    death_and_decay = {
        id = 43265,
        cast = 0,
        cooldown = function () return 30 - ( 5 * talent.morbidity.rank ) end,
        gcd = "spell",

        -- 修复：添加死亡符文支持 by 哑吡20260103
        -- 需要3个符文：邪恶+鲜血+冰霜，死亡符文可以替代任意一个
        spend = function()
            -- 计算缺少的符文数量
            local hasUnholy = unholy_runes.current >= 1
            local hasBlood = blood_runes.current >= 1
            local hasFrost = frost_runes.current >= 1
            local missing = (hasUnholy and 0 or 1) + (hasBlood and 0 or 1) + (hasFrost and 0 or 1)
            
            -- 如果有足够的死亡符文补足缺口
            if missing <= death_runes then
                return hasUnholy and 1 or 0
            end
            return 1
        end,
        spendType = "unholy_runes",
        
        spend2 = function()
            local hasUnholy = unholy_runes.current >= 1
            local hasBlood = blood_runes.current >= 1
            local hasFrost = frost_runes.current >= 1
            local missing = (hasUnholy and 0 or 1) + (hasBlood and 0 or 1) + (hasFrost and 0 or 1)
            
            if missing <= death_runes then
                return hasBlood and 1 or 0
            end
            return 1
        end,
        spend2Type = "blood_runes",
        
        spend3 = function()
            local hasUnholy = unholy_runes.current >= 1
            local hasBlood = blood_runes.current >= 1
            local hasFrost = frost_runes.current >= 1
            local missing = (hasUnholy and 0 or 1) + (hasBlood and 0 or 1) + (hasFrost and 0 or 1)
            
            if missing <= death_runes then
                return hasFrost and 1 or 0
            end
            return 1
        end,
        spend3Type = "frost_runes",

        gain = 15,
        gainType = "runic_power",

        startsCombat = false,
        texture = 136144,

        -- 修复：添加 usable 检查，支持死亡符文替代 by 哑吡 20260103
        usable = function()
            local hasUnholy = unholy_runes.current >= 1
            local hasBlood = blood_runes.current >= 1
            local hasFrost = frost_runes.current >= 1
            local missing = (hasUnholy and 0 or 1) + (hasBlood and 0 or 1) + (hasFrost and 0 or 1)
            
            -- 缺少的符文数量 <= 死亡符文数量
            if missing <= death_runes then return true end
            return false, "没有足够的符文"
        end,

        handler = function ()
            applyBuff( "death_and_decay" )
            
            -- 修复：当使用死亡符文替代时，移除对应的死亡符文buff by 哑吡 20260103
            local hasUnholy = unholy_runes.current >= 1
            local hasBlood = blood_runes.current >= 1
            local hasFrost = frost_runes.current >= 1
            local deathRunesUsed = (hasUnholy and 0 or 1) + (hasBlood and 0 or 1) + (hasFrost and 0 or 1)
            
            for _ = 1, deathRunesUsed do
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,

        copy = { 49936, 49937, 49938 }
    },


    -- Fire a blast of unholy energy, causing 443 Shadow damage to an enemy target or healing 665 damage from a friendly Undead target.
    death_coil = {
        id = 47541,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 40,
        spendType = "runic_power",

        startsCombat = true,
        texture = 136145,

        handler = function ()
            if talent.unholy_blight.enabled then applyDebuff( "target", "unholy_blight" ) end
        end,

        copy = { 49892, 49893, 49894, 49895 }
    },


    -- Opens a gate which the Death Knight can use to return to Ebon Hold.
    death_gate = {
        id = 50977,
        cast = 10,
        cooldown = 60,
        gcd = "spell",

        -- 修复：添加死亡符文支持 by 哑吡20260103
        spend = function()
            if unholy_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "unholy_runes",

        startsCombat = false,
        texture = 135766,

        toggle = "cooldowns",

        usable = function()
            if unholy_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            -- 死亡之门，传送到黑锋要塞
            if unholy_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- Harness the unholy energy that surrounds and binds all matter, drawing the target toward the death knight and forcing the enemy to attack the death knight for 3 sec.
    death_grip = {
        id = 49576,
        cast = 0,
        cooldown = function () return 35 - ( 5 * talent.unholy_command.rank ) end,
        gcd = "off",

        startsCombat = true,
        texture = 237532,

        toggle = "interrupts",

        handler = function ()
            applyDebuff( "target", "death_grip" )
        end,
    },


    -- Sacrifices an undead minion, healing the Death Knight for 40% of her maximum health.  This heal cannot be a critical.
    death_pact = {
        id = 48743,
        cast = 0,
        cooldown = 120,
        gcd = "spell",

        spend = 40,
        spendType = "runic_power",

        startsCombat = false,
        texture = 136146,

        toggle = "cooldowns",

        handler = function ()
            dismissPet( "ghoul" )
            gain( 0.4 * health.max, "health" )
        end,
    },


    -- 灵界打击A deadly attack that deals 75% weapon damage plus 223 and heals the Death Knight for 5% of her maximum health for each of her diseases on the target.
    death_strike = {
        id = 49998,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        -- 修复：添加死亡符文支持，与 obliterate 保持一致 by 哑吡 20260103
        -- 第一优先级：冰霜≥1 且 邪恶≥1 → 返回 1
        -- 第二优先级：冰霜≥1 且 邪恶=0 且 死亡≥1 → 返回 1
        -- 第三优先级：冰霜=0 且 邪恶≥1 且 死亡≥1 → 返回 0
        -- 第四优先级：冰霜=0 且 邪恶=0 且 死亡≥2 → 返回 0
        spend = function()
            return (frost_runes.current >= 1 and unholy_runes.current >= 1) and 1 or
            (frost_runes.current >= 1 and unholy_runes.current == 0 and death_runes >= 1) and 1 or
            (frost_runes.current == 0 and unholy_runes.current >= 1 and death_runes >= 1) and 0 or
            (frost_runes.current == 0 and unholy_runes.current == 0 and death_runes >= 2) and 0 or 1
        end,
        spendType = "frost_runes",

        spend2 = function()
            return (frost_runes.current >= 1 and unholy_runes.current >= 1) and 1 or
            (frost_runes.current >= 1 and unholy_runes.current == 0 and death_runes >= 1) and 0 or
            (frost_runes.current == 0 and unholy_runes.current >= 1 and death_runes >= 1) and 1 or
            (frost_runes.current == 0 and unholy_runes.current == 0 and death_runes >= 2) and 0 or 1
        end,
        spend2Type = "unholy_runes",

        gain = function() return 15 + ( 2.5 * talent.dirge.rank ) end,
        gainType = "runic_power",

        startsCombat = true,
        texture = 237517,

        -- 修复：添加 usable 检查，支持死亡符文替代 by 哑吡 20260103
        usable = function()
            -- 有冰霜+邪恶符文
            if frost_runes.current >= 1 and unholy_runes.current >= 1 then return true end
            -- 有冰霜+死亡符文
            if frost_runes.current >= 1 and death_runes >= 1 then return true end
            -- 有邪恶+死亡符文
            if unholy_runes.current >= 1 and death_runes >= 1 then return true end
            -- 有2个死亡符文
            if death_runes >= 2 then return true end
            return false, "没有足够的符文"
        end,

        healing = function()
            local base = ( 0.05 + ( 0.0125 * talent.improved_death_strike.rank ) ) * health.max
            local amt = 0
            if dot.frost_fever.ticking then amt = amt + base end
            if dot.blood_plague.ticking then amt = amt + base end
            if dot.crypt_fever.ticking then amt = amt + base end
            return amt
        end,

        handler = function ()
            health.current = min( health.max, health.current + action.death_strike.healing )
            -- 修复：当使用死亡符文替代冰霜或邪恶符文时，移除对应的死亡符文buff by 哑吡 20260103
            local deathRunesUsed = 0
            if frost_runes.current == 0 and unholy_runes.current >= 1 and death_runes >= 1 then
                deathRunesUsed = 1
            elseif frost_runes.current >= 1 and unholy_runes.current == 0 and death_runes >= 1 then
                deathRunesUsed = 1
            elseif frost_runes.current == 0 and unholy_runes.current == 0 and death_runes >= 2 then
                deathRunesUsed = 2
            end
            for _ = 1, deathRunesUsed do
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
        copy = { 49999, 45463, 49923, 49924 }
    },


    -- When activated, makes your next Icy Touch, Howling Blast, Frost Strike or Obliterate a critical hit if used within 30 sec.
    deathchill = {
        id = 49796,
        cast = 0,
        cooldown = 120,
        gcd = "off",

        talent = "deathchill",
        startsCombat = false,
        texture = 136213,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "deathchill" )
        end,
    },


    -- Empower your rune weapon, immediately activating all your runes and generating 25 runic power.
    empower_rune_weapon = {
        id = 47568,
        cast = 0,
        cooldown = 300,
        gcd = "off",

        spend = -25,
        spendType = "runic_power",

        startsCombat = false,
        texture = 135372,

        toggle = "cooldowns",

        handler = function ()
            gain( 2, "blood_runes" )
            gain( 2, "frost_runes" )
            gain( 2, "unholy_runes" )
        end,
    },


    -- The death knight takes on the presence of frost, increasing Stamina by 8%, armor contribution from cloth, leather, mail and plate items by 60%, and reducing damage taken by 8%.  Increases threat generated.  Only one Presence may be active at a time.
    frost_presence = {
        id = 48263,
        cast = 0,
        cooldown = 1,
        gcd = "off",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            if frost_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "frost_runes",

        startsCombat = false,
        texture = 135773,

        nobuff = "frost_presence",

        usable = function()
            if frost_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            removeBuff( "presence" )
            applyBuff( "frost_presence" )
            if frost_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- Instantly strike the enemy, causing 55% weapon damage plus 48 as Frost damage.
    frost_strike = {
        id = 49143,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return glyph.frost_strike.enabled and 32 or 40 end,
        spendType = "runic_power",

        talent = "frost_strike",
        startsCombat = true,
        texture = 237520,

        handler = function ()
            removeStack( "killing_machine" )
            removeBuff( "deathchill" )
        end,
        copy = { 49143, 51416, 51417, 51418, 51419, 55268 } --补全各等级技能by风雪 20250901
    },


    -- Grants your pet 25% haste for 30 sec and  heals it for 60% of its health over the duration.
    ghoul_frenzy = {
        id = 63560,
        cast = 0,
        cooldown = 10,
        gcd = "spell",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            if unholy_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "unholy_runes",

        gain = 10,
        gainType = "runic_power",

        talent = "ghoul_frenzy",
        startsCombat = false,
        texture = 132152,

        usable = function()
            if pet.ghoul.down then return false, "requires a living ghoul" end
            if unholy_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            applyBuff( "ghoul_frenzy" )
            if unholy_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- Instantly strike the target and his nearest ally, causing 50% weapon damage plus 125 on the primary target, and 25% weapon damage plus 63 on the secondary target.  Each target takes 10% additional damage for each of your diseases active on that target.
    heart_strike = {
        id = 55050,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        -- 心脏打击消耗鲜血符文 - 灵活版 by 哑吡 20250102
        spend = 1,
        spendType = function()
            -- 优先使用鲜血符文
            if blood_runes.current > 0 then return "blood_runes" end
            -- 有死亡符文时可以替代
            if death_runes > 0 then return "death_runes" end
            return "blood_runes"
        end,

        gain = 10,
        gainType = "runic_power",

        talent = "heart_strike",
        startsCombat = true,
        texture = 135675,

        -- 心脏打击 - 灵活版 by 哑吡 20250102
        usable = function()
            -- 有鲜血符文或死亡符文就可以用
            if blood_runes.current == 0 and death_runes == 0 then
                return false, "没有可用符文"
            end
            return true
        end,

        handler = function ()
            if glyph.heart_strike.enabled then applyDebuff( "target", "glyph_of_heart_strike" ) end
        end,
        copy = { 55050, 55258, 55259, 55260, 55261, 55262 } --补全各等级技能by风雪 20250901

    },


    -- The Death Knight blows the Horn of Winter, which generates 10 runic power and increases total Strength and Agility of all party or raid members within 30 yards by 155.  Lasts 2 min.
    horn_of_winter = {
        id = 57623,
        cast = 0,
        cooldown = 20,
        gcd = "spell",

        spend = -10,
        spendType = "runic_power",

        startsCombat = false,
        texture = 134228,

        handler = function ()
            applyBuff( "horn_of_winter" )
        end,
        copy = { 57330, 57623 } --补全各等级技能by风雪 20250901
    },


    -- Blast the target with a frigid wind dealing 198 to 214 Frost damage to all enemies within 10 yards.
    howling_blast = {
        id = 49184,
        cast = 0,
        cooldown = 8,
        gcd = "spell",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            if buff.freezing_fog.up then return 0 end
            -- 有冰霜符文优先用冰霜
            if frost_runes.current >= 1 and unholy_runes.current >= 1 then return 1 end
            if frost_runes.current >= 1 and death_runes >= 1 then return 1 end
            if unholy_runes.current >= 1 and death_runes >= 1 then return 0 end
            if death_runes >= 2 then return 0 end
            return 1
        end,
        spendType = "frost_runes",
        spend2 = function()
            if buff.freezing_fog.up then return 0 end
            if frost_runes.current >= 1 and unholy_runes.current >= 1 then return 1 end
            if frost_runes.current >= 1 and death_runes >= 1 then return 0 end
            if unholy_runes.current >= 1 and death_runes >= 1 then return 1 end
            if death_runes >= 2 then return 0 end
            return 1
        end,
        spend2Type = "unholy_runes",

        gain = function() return 15 + ( 2.5 * talent.chill_of_the_grave.rank ) end,
        gainType = "runic_power",

        talent = "howling_blast",
        startsCombat = true,
        texture = 135833,

        -- 修复：添加 usable 检查，支持死亡符文替代 by 哑吡 20260103
        usable = function()
            if buff.freezing_fog.up then return true end
            if frost_runes.current >= 1 and unholy_runes.current >= 1 then return true end
            if frost_runes.current >= 1 and death_runes >= 1 then return true end
            if unholy_runes.current >= 1 and death_runes >= 1 then return true end
            if death_runes >= 2 then return true end
            return false, "没有足够的符文"
        end,

        handler = function ()
            removeBuff( "deathchill" )
            removeBuff( "freezing_fog" )
            removeStack( "killing_machine" )

            if glyph.howling_blast.enabled then
                applyDebuff( "target", "frost_fever" )
                active_dot.frost_fever = active_enemies
            end
            
            -- 修复：当使用死亡符文替代时，移除对应的死亡符文buff by 哑吡 20260103
            if not buff.freezing_fog.up then
                local deathRunesUsed = 0
                if frost_runes.current == 0 and unholy_runes.current >= 1 and death_runes >= 1 then
                    deathRunesUsed = 1
                elseif frost_runes.current >= 1 and unholy_runes.current == 0 and death_runes >= 1 then
                    deathRunesUsed = 1
                elseif frost_runes.current == 0 and unholy_runes.current == 0 and death_runes >= 2 then
                    deathRunesUsed = 2
                end
                for _ = 1, deathRunesUsed do
                    for i = 1, 6 do
                        if buff[ "death_rune_" .. i ].up then
                            removeBuff( "death_rune_" .. i )
                            break
                        end
                    end
                end
            end
        end,
        copy = { 49184, 51409, 51410, 51411 } --补全各等级技能by风雪 20250901

    },


    -- Purges the earth around the Death Knight of all heat.  Enemies within 10 yards are trapped in ice, preventing them from performing any action for 10 sec and infecting them with Frost Fever.  Enemies are considered Frozen, but any damage other than diseases will break the ice.
    hungering_cold = {
        id = 49203,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        spend = function() return glyph.hungering_cold.enabled and 0 or 40 end,
        spendType = "runic_power",

        talent = "hungering_cold",
        startsCombat = true,
        texture = 135152,

        toggle = "cooldowns",

        handler = function ()
            applyDebuff( "frost_fever" )
            active_dot.frost_fever = active_enemies
        end,
    },


    -- The Death Knight freezes her blood to become immune to Stun effects and reduce all damage taken by 30% plus additional damage reduction based on Defense for 12 sec.
    icebound_fortitude = {
        id = 48792,
        cast = 0,
        cooldown = 120,
        gcd = "off",

        spend = 20,
        spendType = "runic_power",

        startsCombat = false,
        texture = 237525,

        toggle = "defensives",

        handler = function ()
            applyBuff( "icebound_fortitude" )
        end,
    },


    -- Chills the target for 227 to 245 Frost damage and  infects them with Frost Fever, a disease that deals periodic damage and reduces melee and ranged attack speed by 14% for 15 sec.  Very high threat when in Frost Presence.
    icy_touch = {
        id = 45477,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        -- 修复：只有当没有冰霜符文时才使用死亡符文 by 哑吡 20251228
        -- 原逻辑：death_runes > 0 就返回 0，这会导致优先使用死亡符文
        -- 新逻辑：只有当 frost_runes.current == 0 且 death_runes > 0 时才返回 0
        spend = function() 
            if frost_runes.current >= 1 then
                return 1  -- 有冰霜符文，消耗冰霜符文
            elseif death_runes > 0 then
                return 0  -- 没有冰霜符文但有死亡符文，不消耗冰霜符文（在handler中消耗死亡符文）
            else
                return 1  -- 没有任何可用符文，返回1（技能不可用）
            end
        end,
        spendType = "frost_runes",   

        gain = function() return 10 + ( 2.5 * talent.chill_of_the_grave.rank ) end,
        gainType = "runic_power",

        startsCombat = true,
        texture = 237526,

        -- 修复：添加usable检查，防止重复推荐 by 哑吡 20251228
        usable = function()
            if frost_runes.current >= 1 then return true end
            if death_runes > 0 then return true end
            return false, "没有可用的冰霜符文或死亡符文"
        end,

        handler = function ()
            removeStack( "killing_machine" )
            applyDebuff( "target", "frost_fever" )
            -- 修复：当使用死亡符文时，移除一个死亡符文buff by 哑吡 20251228
            if frost_runes.current == 0 and death_runes > 0 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,

        copy = { 49896, 49903, 49904, 49909 }
    },


    -- Draw upon unholy energy to become undead for 10 sec.  While undead, you are immune to Charm, Fear and Sleep effects.
    lichborne = {
        id = 49039,
        cast = 0,
        cooldown = 120,
        gcd = "off",


        talent = "lichborne",
        startsCombat = true,
        texture = 136187,

        toggle = "defensives",

        handler = function ()
            applyBuff( "lichborne" )
        end,
    },


    -- Place a Mark of Blood on an enemy.  Whenever the marked enemy deals damage to a target, that target is healed for 4% of its maximum health.  Lasts for 20 sec or up to 20 hits.
    mark_of_blood = {
        id = 49005,
        cast = 0,
        cooldown = 180,
        gcd = "spell",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            if blood_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "blood_runes",

        talent = "mark_of_blood",
        startsCombat = true,
        texture = 132205,

        toggle = "defensives",

        usable = function()
            if blood_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            applyDebuff( "target", "mark_of_blood", nil, 20 )
            if blood_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- Smash the target's mind with cold, interrupting spellcasting and preventing any spell in that school from being cast for 4 sec.
    mind_freeze = {
        id = 47528,
        cast = 0,
        cooldown = 10,
        gcd = "off",

        spend = function () return 20 - ( 10 * talent.endless_winter.rank ) end,
        spendType = "runic_power",

        startsCombat = true,
        texture = 237527,

        timeToReady = state.timeToInterrupt,
        debuff = "casting",

        toggle = "interrupts",

        handler = function ()
            interrupt()
        end,
    },


    -- 湮没A brutal instant attack that deals 80% weapon damage plus 467, total damage increased 12.5% per each of your diseases on the target, but consumes the diseases.
    obliterate = {
        id = 49020,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        -- spend = 1,
        --修改湮灭条件：第一优先级：冰霜≥1 且 邪恶≥1 → 返回 1；第二优先级：冰霜≥1 且 邪恶=0 且 死亡≥1 → 返回 1；第三优先级：冰霜=0 且 邪恶≥1 且 死亡≥1 → 返回 0；第四优先级：冰霜=0 且 邪恶=0 且 死亡≥2 → 返回 0；默认情况：返回 1  by风雪20250724
        spend = function()
            return (frost_runes.current >= 1 and unholy_runes.current >= 1) and 1 or
            (frost_runes.current >= 1 and unholy_runes.current == 0 and death_runes >= 1) and 1 or
            (frost_runes.current == 0 and unholy_runes.current >= 1 and death_runes >= 1) and 0 or
            (frost_runes.current == 0 and unholy_runes.current == 0 and death_runes >= 2) and 0 or 1
        end,

        spendType = "frost_runes",
        -- spend2 = 1,
        --修改湮灭条件：第一优先级：冰霜≥1 且 邪恶≥1 → 返回 1；第二优先级：冰霜≥1 且 邪恶=0 且 死亡≥1 → 返回 0；第三优先级：冰霜=0 且 邪恶≥1 且 死亡≥1 → 返回 1；第四优先级：冰霜=0 且 邪恶=0 且 死亡≥2 → 返回 0；默认情况：返回 1  by风雪20250724        
        spend2 = function()
            return (frost_runes.current >= 1 and unholy_runes.current >= 1) and 1 or
            (frost_runes.current >= 1 and unholy_runes.current == 0 and death_runes >= 1) and 0 or
            (frost_runes.current == 0 and unholy_runes.current >= 1 and death_runes >= 1) and 1 or
            (frost_runes.current == 0 and unholy_runes.current == 0 and death_runes >= 2) and 0 or 1
        end,      
        
        spend2Type = "unholy_runes",

        gain = function() return 15 + ( 2.5 * talent.chill_of_the_grave.rank ) end,
        gainType = "runic_power",

        startsCombat = true,
        texture = 135771,

        handler = function ()
            removeBuff( "deathchill" )
            if talent.annihilation.rank < 3 then
                removeDebuff( "target", "frost_fever" )
                removeDebuff( "target", "blood_plague" )
                removeDebuff( "target", "crypt_fever" )
            end
            -- 修复：当使用死亡符文替代冰霜或邪恶符文时，移除对应的死亡符文buff by 哑吡 20251228
            local deathRunesUsed = 0
            -- 计算需要消耗的死亡符文数量
            if frost_runes.current == 0 and unholy_runes.current >= 1 and death_runes >= 1 then
                deathRunesUsed = 1  -- 死亡符文替代冰霜符文
            elseif frost_runes.current >= 1 and unholy_runes.current == 0 and death_runes >= 1 then
                deathRunesUsed = 1  -- 死亡符文替代邪恶符文
            elseif frost_runes.current == 0 and unholy_runes.current == 0 and death_runes >= 2 then
                deathRunesUsed = 2  -- 死亡符文替代两个符文
            end
            -- 移除对应数量的死亡符文buff
            for _ = 1, deathRunesUsed do
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,

        copy = { 51423, 51424, 51425 }
    },


    -- The Death Knight's freezing aura creates ice beneath her feet, allowing her and her party or raid to walk on water for 10 min.  Works while mounted.  Any damage will cancel the effect.
    path_of_frost = {
        id = 3714,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            if frost_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "frost_runes",

        startsCombat = false,
        texture = 237528,

        usable = function()
            if frost_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            applyBuff( "path_of_frost" )
            if frost_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- Spreads existing Blood Plague and Frost Fever infections from your target to all other enemies within 10 yards.
    pestilence = {
        id = 50842,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        -- 传染消耗鲜血符文，死亡符文可以替代 by 哑吡 20251225
        spend = 1,
        spendType = function()
            -- 优先使用鲜血符文
            if blood_runes.current > 0 then return "blood_runes" end
            -- 死亡符文可以替代鲜血符文
            if death_runes > 0 then return "death_runes" end
            return "blood_runes"
        end,

        gain = 10,
        gainType = "runic_power",

        startsCombat = true,
        texture = 136182,

        -- 泰坦重铸版修复：添加 usable 检查，防止重复推荐传染
        usable = function()
            -- 检查是否有可用符文（鲜血或死亡）by 哑吡 20251225
            if blood_runes.current == 0 and death_runes == 0 then
                return false, "没有可用符文"
            end
            -- 必须有疾病才能传染
            if not ( dot.frost_fever.ticking and dot.blood_plague.ticking ) then
                return false, "目标没有疾病"
            end
            
            -- 疾病雕文检查：有雕文时可以刷新主目标疾病 by 哑吡 20260101
            if glyph.disease.enabled then
                -- 有疾病雕文：检查主目标疾病是否需要刷新（剩余时间<6秒）
                local needRefresh = dot.frost_fever.remains < 6 or dot.blood_plague.remains < 6
                if needRefresh then
                    return true
                end
            end
            
            -- 使用实时检查：计算缺少疾病的敌人数量
            local missingCount = countEnemiesMissingDisease()
            if missingCount == 0 then
                return false, "所有敌人都有疾病"
            end
            return true
        end,

        handler = function ()
            -- 泰坦重铸版修复：记录传染使用时间
            lastPestilenceTime = GetTime()
            
            if dot.frost_fever.ticking then
                active_dot.frost_fever = active_enemies
                if glyph.disease.enabled then applyDebuff( "target", "frost_fever" ) end
            end
            if dot.blood_plague.ticking then
                active_dot.blood_plague = active_enemies
                if glyph.disease.enabled then applyDebuff( "target", "blood_plague" ) end
            end

            if talent.reaping.rank == 3 then
                if blood_runes.current == 0 then applyBuff( "death_rune_1" )
                else applyBuff( "death_rune_2" ) end
            end
        end,
    },


    -- A vicious strike that deals 50% weapon damage plus 189 and infects the target with Blood Plague, a disease dealing Shadow damage over time.
    plague_strike = {
        id = 45462,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        -- 修复：添加死亡符文支持 by 哑吡 20251228
        -- 只有当没有邪恶符文时才使用死亡符文
        spend = function() 
            if unholy_runes.current >= 1 then
                return 1  -- 有邪恶符文，消耗邪恶符文
            elseif death_runes > 0 then
                return 0  -- 没有邪恶符文但有死亡符文，不消耗邪恶符文（在handler中消耗死亡符文）
            else
                return 1  -- 没有任何可用符文，返回1（技能不可用）
            end
        end,
        spendType = "unholy_runes",

        gain = function() return 10 + ( 2.5 * talent.dirge.rank ) end,
        gainType = "runic_power",

        startsCombat = true,
        texture = 237519,

        -- 修复：添加usable检查，防止重复推荐 by 哑吡 20251228
        usable = function()
            if unholy_runes.current >= 1 then return true end
            if death_runes > 0 then return true end
            return false, "没有可用的邪恶符文或死亡符文"
        end,

        handler = function ()
            applyDebuff( "target", "blood_plague" )
            -- 修复：当使用死亡符文时，移除一个死亡符文buff by 哑吡 20251228
            if unholy_runes.current == 0 and death_runes > 0 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
            -- TODO: talent.desecration effect?
        end,

        copy = { 49917, 49918, 49919, 49920, 49921 }
    },


    -- Raises the corpse of a raid or party member to fight by your side.  The player will have control over the Ghoul for 5 min.
    raise_ally = {
        id = 61999,
        cast = 0,
        cooldown = 600,
        gcd = "spell",

        startsCombat = false,
        texture = 136143,

        handler = function ()
            -- 复活盟友，将死亡的队友复活为食尸鬼
        end,
    },


    -- Raises a Ghoul to fight by your side.
    -- 修复：亡者复生技能ID改回46584 by 哑吡 20251230
    raise_dead = {
        id = 46584,
        cast = 0,
        cooldown = function() return 180 - ( 45 * talent.night_of_the_dead.rank ) - ( 60 * talent.master_of_ghouls.rank ) end,
        gcd = "spell",

        essential = true,

        startsCombat = false,
        texture = 136119,

        -- 修复：有食尸鬼时不推荐亡者复生 by 哑吡 20251230
        -- 修复：没有雕文时需要检查尸尘材料 by 哑吡 20251231
        -- 尸尘物品ID: 37201, 亡者复生雕文spellID: 60200
        usable = function() 
            if pet.ghoul.active then
                return false, "already have a ghoul"
            end
            -- 如果没有亡者复生雕文，需要检查尸尘材料
            local has_glyph = glyph.raise_dead and glyph.raise_dead.enabled
            if not has_glyph then
                local corpse_dust_count = GetItemCount( 37201 )
                if corpse_dust_count == 0 then
                    return false, "需要尸尘材料（没有亡者复生雕文）"
                end
            end
            return true
        end,

        -- 修复：根据天赋动态设置食尸鬼持续时间 by 哑吡 20251226
        -- 有"亡者大师"天赋(52143)时为永久宠物，无天赋时持续60秒
        handler = function ()
            local duration = talent.master_of_ghouls.enabled and 3600 or 60
            summonPet( "ghoul", duration )
        end,
    },


    -- On next attack..
    rune_strike = {
        id = 56815,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 20,
        spendType = "runic_power",

        startsCombat = true,
        texture = 237518,

        buff = "rune_strike_usable",
        nobuff = "rune_strike",

        handler = function()
            start_rune_strike()
        end
    },


    -- Converts 1 Blood Rune into 10% of your maximum health.
    rune_tap = {
        id = 48982,
        cast = 0,
        cooldown = function () return 60 - ( talent.improved_rune_tap.rank * 10 ) end,
        gcd = "off",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            if blood_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "blood_runes",

        talent = "rune_tap",
        startsCombat = true,
        texture = 237529,

        toggle = "cooldowns",

        usable = function()
            if blood_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            gain( ( 0.1 + 0.33 * talent.improved_rune_tap.rank ) * health.max, "health" )
            if blood_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- An unholy strike that deals 70% of weapon damage as Physical damage plus 380.  In addition, for each of your diseases on your target, you deal an additional 12% of the Physical damage done as Shadow damage.
    scourge_strike = {
        id = 55090,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        -- 修复：添加死亡符文支持，与 obliterate/death_strike 保持一致 by 哑吡 20260103
        spend = function()
            return (frost_runes.current >= 1 and unholy_runes.current >= 1) and 1 or
            (frost_runes.current >= 1 and unholy_runes.current == 0 and death_runes >= 1) and 1 or
            (frost_runes.current == 0 and unholy_runes.current >= 1 and death_runes >= 1) and 0 or
            (frost_runes.current == 0 and unholy_runes.current == 0 and death_runes >= 2) and 0 or 1
        end,
        spendType = "frost_runes",

        spend2 = function()
            return (frost_runes.current >= 1 and unholy_runes.current >= 1) and 1 or
            (frost_runes.current >= 1 and unholy_runes.current == 0 and death_runes >= 1) and 0 or
            (frost_runes.current == 0 and unholy_runes.current >= 1 and death_runes >= 1) and 1 or
            (frost_runes.current == 0 and unholy_runes.current == 0 and death_runes >= 2) and 0 or 1
        end,
        spend2Type = "unholy_runes",

        gain = function() return 15 + ( 2.5 * talent.dirge.rank ) end,
        gainType = "runic_power",

        talent = "scourge_strike",
        startsCombat = true,
        texture = 237530,

        -- 修复：添加 usable 检查，支持死亡符文替代 by 哑吡 20260103
        usable = function()
            if frost_runes.current >= 1 and unholy_runes.current >= 1 then return true end
            if frost_runes.current >= 1 and death_runes >= 1 then return true end
            if unholy_runes.current >= 1 and death_runes >= 1 then return true end
            if death_runes >= 2 then return true end
            return false, "没有足够的符文"
        end,

        handler = function ()
            -- 修复：当使用死亡符文替代时，移除对应的死亡符文buff by 哑吡 20260103
            local deathRunesUsed = 0
            if frost_runes.current == 0 and unholy_runes.current >= 1 and death_runes >= 1 then
                deathRunesUsed = 1
            elseif frost_runes.current >= 1 and unholy_runes.current == 0 and death_runes >= 1 then
                deathRunesUsed = 1
            elseif frost_runes.current == 0 and unholy_runes.current == 0 and death_runes >= 2 then
                deathRunesUsed = 2
            end
            for _ = 1, deathRunesUsed do
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,

        copy = { 55090, 55265, 55270, 55271 } --添加高等级技能，by风雪 20250731
    },


    -- Strangulates an enemy, silencing them for 5 sec.  Non-player victim spellcasting is also interrupted for 3 sec.
    strangulate = {
        id = 47476,
        cast = 0,
        cooldown = function() return glyph.strangulate.enabled and 100 or 120 end,
        gcd = "spell",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            if blood_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "blood_runes",

        gain = 1,
        gainType = "runic_power",

        startsCombat = true,
        texture = 136214,

        toggle = "interrupts",

        timeToReady = state.timeToInterrupt,

        usable = function()
            if blood_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            interrupt()
            if blood_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- A Gargoyle flies into the area and bombards the target with Nature damage modified by the Death Knight's attack power.  Persists for 30 sec.
    summon_gargoyle = {
        id = 49206,
        cast = 0,
        cooldown = 180,
        gcd = "spell",

        spend = 60,
        spendType = "runic_power",

        talent = "summon_gargoyle",
        startsCombat = false,
        texture = 132182,

        toggle = "cooldowns",

        handler = function ()
            summonPet( "gargoyle" )
            applyBuff( "summon_gargoyle" )
        end,
    },


    -- Reinforces your armor with a thick coat of ice, increasing your armor by 25% and increasing your Strength by 20% for 20 sec.
    unbreakable_armor = {
        id = 51271,
        cast = 0,
        cooldown = 60,
        gcd = "off",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            if frost_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "frost_runes",

        gain = 10,
        gainType = "runic_power",

        talent = "unbreakable_armor",
        startsCombat = false,
        texture = 132388,

        -- toggle = "cooldowns", 取消加入爆发循环组，改为默认循环组 by风雪 20250803

        usable = function()
            if frost_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            applyBuff( "unbreakable_armor" )
            if frost_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- Induces a friendly unit into a killing frenzy for 30 sec.  The target is Enraged, which increases their physical damage by 20%, but causes them to lose health equal to 1% of their maximum health every second.
    -- 狂热/邪恶狂热 - Hysteria/Unholy Frenzy 是同一个技能
    unholy_frenzy = {
        id = 49016,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        talent = "unholy_frenzy",
        startsCombat = false,
        texture = 237512,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "unholy_frenzy" )
        end,

        copy = "hysteria",  -- 添加别名，让APL中的hysteria也能识别
    },


    -- Infuses the death knight with unholy fury, increasing attack speed by 15%, movement speed by 15% and reducing the global cooldown on all abilities by 0.5 sec.  Only one Presence may be active at a time.
    unholy_presence = {
        id = 48265,
        cast = 0,
        cooldown = 1,
        gcd = "off",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            if unholy_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "unholy_runes",

        startsCombat = false,
        texture = 135775,

        nobuff = "unholy_presence",

        usable = function()
            if unholy_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            removeBuff( "presence" )
            applyBuff( "unholy_presence" )
            if unholy_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },


    -- Temporarily grants the Death Knight 15% of maximum health and increases the amount of health generated through spells and effects by 35% for 10 sec.  After the effect expires, the health is lost.
    vampiric_blood = {
        id = 55233,
        cast = 0,
        cooldown = 60,
        gcd = "off",

        -- 修复：添加死亡符文支持 by 哑吡 20260103
        spend = function()
            if blood_runes.current >= 1 then return 1 end
            if death_runes >= 1 then return 0 end
            return 1
        end,
        spendType = "blood_runes",

        gain = 10,
        gainType = "runic_power",

        talent = "vampiric_blood",
        startsCombat = true,
        texture = 136168,

        toggle = "defensives",

        usable = function()
            if blood_runes.current >= 1 then return true end
            if death_runes >= 1 then return true end
            return false, "没有可用符文"
        end,

        handler = function ()
            applyBuff( "vampiric_blood" )
            health.max = health.max * 1.15
            if blood_runes.current == 0 and death_runes >= 1 then
                for i = 1, 6 do
                    if buff[ "death_rune_" .. i ].up then
                        removeBuff( "death_rune_" .. i )
                        break
                    end
                end
            end
        end,
    },

    -- 自动攻击 - 后备技能（只在没有其他技能可用时由APL推荐）
    auto_attack = {
        id = 6603,
        cast = 0,
        cooldown = 0,
        gcd = "off",

        startsCombat = true,
        texture = function()
            return GetInventoryItemTexture("player", 16) or 135641
        end,

        handler = function()
        end
    },

    -- 啃咬 - 食尸鬼宠物技能，晕眩目标
    -- PVP 打断/控制技能
    gnaw = {
        id = 47481,
        cast = 0,
        cooldown = 60,
        gcd = "off",

        startsCombat = true,
        texture = 237524,

        toggle = "interrupts",

        usable = function()
            return pet.ghoul.active, "requires active ghoul"
        end,

        handler = function()
            -- 晕眩效果由宠物处理
        end,
    },

    -- 狮心 - 人类种族技能
    -- 使你的爆击几率提高15%，持续15秒。3分钟冷却
    lions_heart = {
        id = 20599,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        startsCombat = false,
        texture = 304711,

        toggle = "cooldowns",

        usable = function()
            return IsSpellKnown(20599), "requires human race"
        end,

        handler = function()
            applyBuff( "lions_heart" )
        end,
    },

    -- 狂热 - 血DK天赋技能
    -- 使友方目标进入狂热状态，物理伤害提高20%，但每秒损失1%最大生命值，持续30秒
    hysteria = {
        id = 49016,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        talent = "unholy_frenzy",
        startsCombat = false,
        texture = 237512,

        toggle = "cooldowns",

        handler = function()
            applyBuff( "unholy_frenzy" )
        end,
    },
} )

spec:RegisterOptions( {
    enabled = true,

    aoe = 3,

    gcd = 47541,

    nameplates = true,
    nameplateRange = 8,

    damage = true,
    damageExpiration = 6,

    potion = "speed",

    package = "血冰(黑科研)",
    usePackSelector = true
} )

-- ============================================================================
-- 死亡骑士 - 核心 - 特殊选项
-- ============================================================================
spec:RegisterSetting("dk_special_header", nil, {
    type = "header",
    name = "特殊选项"
})

spec:RegisterSetting("dk_special_description", nil, {
    type = "description",
    name = "以下是死亡骑士的特殊功能设置。\n\n"
})

spec:RegisterSetting("pestilence_hp_check_enabled", false, {
    type = "toggle",
    name = "启用枯萎凋零血量检查",
    desc = "启用后，将根据下方设置的血量阈值来决定是否推荐枯萎凋零。\n\n" ..
           "关闭此选项则不检查血量，正常推荐枯萎凋零。",
    width = "full",
})

spec:RegisterSetting("pestilence_hp_skip_boss", true, {
    type = "toggle",
    name = "BOSS目标除外",
    desc = "启用后，当目标是BOSS时将跳过血量检查，始终正常推荐枯萎凋零。\n\n" ..
           "这样可以确保在打BOSS时不会因为血量检查而错过传染机会。",
    width = "full",
})

spec:RegisterSetting("pestilence_hp_threshold", 50, {
    type = "range",
    name = "枯萎凋零血量阈值",
    desc = "设置释放枯萎凋零时，姓名板中所有进战斗怪物的总血量百分比阈值。\n\n" ..
           "例如设置为50，则只有当所有怪物总血量高于50%时才会推荐枯萎凋零，避免在怪物快死时浪费符文。\n\n" ..
           "需要先启用上方的\"启用枯萎凋零血量检查\"选项。",
    min = 10,
    max = 100,
    step = 5,
    width = "full",
})

spec:RegisterSetting("pestilence_min_targets", 2, {
    type = "range",
    name = "枯萎凋零最少目标数",
    desc = "设置释放枯萎凋零所需的最少敌人数量。\n\n" ..
           "例如设置为3，则只有当战斗中有3个或更多敌人时才会推荐枯萎凋零。\n\n" ..
           "默认值为2（至少2个目标才推荐传染）。",
    min = 2,
    max = 10,
    step = 1,
    width = "full",
})

spec:RegisterSetting("blood_boil_min_targets", 2, {
    type = "range",
    name = "血液沸腾最少目标数",
    desc = "设置释放血液沸腾所需的最少敌人数量。\n\n" ..
           "例如设置为3，则只有当战斗中有3个或更多敌人时才会推荐血液沸腾。\n\n" ..
           "默认值为2（至少2个目标才推荐血液沸腾）。\n\n" ..
           "注意：血液沸腾还需要目标有疾病才会推荐。",
    min = 2,
    max = 10,
    step = 1,
    width = "full",
})

spec:RegisterSetting("dk_special_footer", nil, {
    type = "description",
    name = "\n\n"
})

spec:RegisterPack( "冰DK(黑科研)", 20260118, [[Hekili:TR1wVrT1w4FlNxQse64oZqiqrapuHQAds5LPh13S9ES3tSv8yB5lz0uHSsAk5cGkxsoe1cNgOCOnqfTiUucKu6)L2y7mpXFHU2EpoJNzSD8omaTvmpeLyV2FR1AVxx(w7m8L5)u(QYihm)Kvkvz8sLlFmUYLh7OLRWx1PLjMVQjsAA0uWVOJAa)0FHhC6Zms7TUs4pCLWBU6OebAPzGKjazB4AjbcXxTMRQMZNOZxRp0pkiKjwIFYX5RQOklJPIGTL4REYc(XBItJrokEINrxDkfNJ7j(rwg2oEI)hD1zWw2inpX)TNiyPTVXno9z8p3gbpzUGh)I2Z(nHRUr4Yl5nrWJEG))77dw7xcV7Zdx(z(l9JKhlcg5rIwBWx)8DN)x9))3D3NCH3p4(FV)xVrWTNn4jxi8rBfU16aax)Xbx7bbRDNGBS(XJwi4DLg3BI9Z4J)aqePJKWECVjaDRAli7I0eAQI1K9e)9fUk4lx6IbxCUKgsSOonneuq6Y4KIU8fgquhKgw3HZrXc27emQl4OGSTrwQiDoSoQMwxa2yUDNFUDE2f8V1Q7E5nAV4f9)PLPBfVC7L6yj3Ct)FB(xU9YjXwhBnd2MGTKHMSGTdgR1p2l8a)fEA7R(DTxHOHW78THBDP9qDNnxj8HVOpuvmAQPQpLqnnKTt)WT41BF7VYFHh6V4wulmALtP1YuHtw1gJSX9TKWR9IW1ox7R)FdU2IGI3z7BgS(k(l9u40K(Qy1tbPOAFpa3DX75F(n2zZZtd)cN)(XyUFreXFGiJv)zy3i8B(sAClewuMlogGcRN4iDI5p9NnknApTtny9EtuHloOO)1w5JPRn4z)u4C3ps49Z4I)Wxvt12XokPh2F0WWVnzuXKo7r8FiFvjlvhmeHXx9F5jkB4WvNOxH6yilLZrvAAyL8vrsoQg68vvLAj4y4kPW7aLl2pOQPzyilyQHMYfpiw0NdHGwQtJj4D4mXlJGL3Ztesqe68C7OhmYGEHfUbsvhE9j8ehZt8SNnfRRpzgnglQqwU6yBojxlliA3t8uN0tSChGiv5OVFVNpAcFeB7OcPisro4y5THLTpUp(tksK)52ro4MrE7zPjY(FOpEMgZahT1CRxNBAvTOK9gijfvDmNRz07GtavjbtJMyl65WyL6Qu6wtxDEug1zDlm(ZjkTUXuXkmVkFD1CpVMO6JvCvNWLemGt16AgnZ2N(GdeWDIzlLZMv5sfc5Ua4AJfajAyhT6SR3K(QRbKdWwrbnKLNDnMmwEu0xDxRwrlp7skPFs7Qxd69onrEbKvddlozJM6j8T(FFKwYoVEaTq3DtVEc8AxDfdTwP((UgHrnnc(ekBeTND6mRAFWIzzQugsBZXNyvRmK4oaQvYevgYjZRDaTHr2LqJ77KAP8t5joEpDoOAkrA4Rsc(yLIFoW9dndsvJaJNi8QCY8RuSm)0v5XYd4IvuiDGhpdF5e9g5mGolwLKiS7JD)7vqM5PBT5yszxDAK4OiAyGdYS34ifmsZrHZuYHg6ukMYsQbONizaQKbq8hkQXrZqGXseKXsOwqSisUff(CKjoEnQTrkrSGPg5Bzxtmvt8qzuC6qzv)a4CC4U6g3G2NKiKqtmYeEiXkYLQJj2HBkfdxnocmZGJ2H2Z1Tqqib42iz6otxL19nr6i7sH9enCcsorrsdvmS0jHynv1bC4j0gGHVRJC1C2JaFSSnuHJMi6j4K2qhY5rY60JXT3HLbSrzRqcW75SH0eSxdG2bSd98CqSpZUGGMtRZeH4Kd7JKKJaeOqEpHALPr0dtHxBS4sinnb6FiqMikPwON8cyDCd1eDkiIjqVmfKrQ8ulc41CTayapg8wAIvgKmCn7rLrRlnIQzR0eRUZSErXnMwyjJg1qDJCspLKywGS2Kjv6JYth(8DEjFUZ9L5jD2b35m13Wkf1HEi(UHFF3WV)9D4x2MgKbIYPwb81seal8ShwJ6ZaR5H9O(fCW59vfXNf5n8wbolg0(yGfEYozDHS3j9zGGD6W13O)mn7EQ417DbWWu6Vc3fadtJxOH97JbEKoyOSXRH7BGHAldV7BGHAhdX7BGHQhf)(gyzS63E33WR0m6hW7BGHkiSDFd)tFq74XYILakh1IElfDibNW5DYDS43KdNNDzSHfZ)jRKDXQH3W50X1(R)4fmgLuS(LzWgGH2GJ0PFBKhP5ceFi8UYDA5EjzU3fauS(Izr4Oy91YIErXAqLiqQLjODtmwggKxcRrAp0XnyORZRarfw6cnSyJZgLZHmD8dw3LcmSflmvFnWhRy5Pfr7mWmIH87HiFSILGZiFmwi0(2JpglmGhiNmV)le5qY9nhzGO(OKVxyezs89qRjYshYIH6MblDz)ZVU)pVT)5UZopFHJSZM3l48Zs(cGT0A7ERn(Jz)cVjaT46aDO5R6VYv8V8Ti3)PrDvnY32nIg4)Zd]] )


spec:RegisterPack( "邪DK(黑科研)", 20260118, [[Hekili:TRvBVnTrC8pl7niQMwij0w6qaVyQVyRiXBYM27S9f7ljw4yBzFMOGqwTWaAxrcy0rfpmvQ4HvyfbJh6G2c77YwTtZR2xHD(U4eBhFNtBthinYl26YD3)73D))D)()WIqbHVvOKcabfovX8fhpFHctKRqHrlM)icLqnnHcLmbYNguf)h6G64)z7Z)Kjp5bBVX1B9RxV19wyKGj0uZaOeyiBdhlz8Kekv2rvd9n6cLty9XXtYeklCk8FutvrbsNc0wwO0XhWpUtnjeGQ5kDsD1Q1qh1v670RzO1m4FREgOLnqZv6lCLWq1FM1M8KExCf)xpJ)REF7PVDRfwP1CZ6oL)lFU3V8i)fxR1JxV1CV1B2Fl4RLWOCmYA9V16BFH359GhV9RN)q(p9rE3Af)7pT)RNV1l3O1glHnWDEL)nFU)Ip0)UlDuYcXhV8J7ovwOp8d2eK9iQzpQ7u49w1wuXbOj2qfQP4k9xx6NCL8U6v8VYmrbs4urnmeRb0vGrN6CZ33uranOokNTm2hvfkAJSupnmhuhuwR3sFWJBnZ79N7gExEd6z)F2C2o27EVX7pVW)S5CrnMfeyQQxnHv8xynV5Er313(f3D7LNMA0TF3Q(pDJTwF5wR(i)BE5eMRAndhnXkwq9Z2mHnBF)L8E(BAV6MTM)8B92FNA8yNlN61n0fRcSQA0uRVd2vx1BHh0APx6DHRInsKLxvRPzTCkQ2qGDYv16MVV1IxS9D(zcuNDRnVN)s3WB2)a74PdrWFwo6Wpyh(cpd7eBD7FGshXE7c5c9xuYQR0bd5Yf)6rimXO(e86CNQyUq6qFRzYVNUg6DS3LNV9Dw7qu3bzPzbXWpcL0uTr2KN0y)Rge)xNIiv05cs4RekjBPIGwQaHsFMRKIbkxfldBKyfi(jyoKQ8PXRuOeqgPAOlusvUPiYWrUMaclgKLPkRzyOiAQbQ6a73w0VVdfoWEhMP9y4EpGRuna(zg97TjFXb7)uybRdu1XdFmxPrDLo35sbDjMZiH2IojlhDODozhlmPg5kDIJ7kvOJHc0WOJ397hjYzeAJuXmBzYbCuExySpJzCEszg89BJT7HbV7S0Ms2o9Xzcg8LQQSOPrdOLOb(uvrZOrpdrV4Lnu1cSYryAf7a1ifSuCDtXiwKLHMGPH6XeeBaWEv9QKJCzNkvYHJ8zObcSxofJg6HKh2xNHCWuDRNWvA8ySi6w37o7lzcYmcpqHfDtJFscaKdr)jXa0xc9ws)pdoqSvMC8ENI4Gk4CuippM4hZNfkPbhVwubkdAsomSvw)qWrkWwDo7l2HXvukUB2c87zi1VomxKWwjoBKW50VBGcB14SHsFBvrUBfBT2b652WGvK2dh2I3ddyXZDKgAyhbyGqZEHDKgCyR1pqWHhdjLTRiBfzEzcLsCWOjhui)(TAxroIVSWDX9DqXwcosMiuWmk9kIatrWzaQAbRYvcpuEw5QuKTEAF2Fc2wHTwyFwzCgO8yPXJ7UbCZ30e2PIXCbR(mqYgiByOfeKmNfa7sW0tGsqvQkn7Th9gHShSL24wv6byaacBo2sIYNpCwV07bZO2Gau2IDP67dVV75hcs2oFsshcysSoN0xdorjlVUBIiKr7K5Uf0oOGfYGj3NWbjBgBPPKaEIbIDxZWsx0OIydvDSDWBbkGkvb4OH6w5A4CRRILTWxRWZcJIHovLsMlkg4ySjjVHIpm9oOtPPCmAzdCAM21c60tFwmYyDn3O8nxeUD)pwaAysQa3Y4QbbAOA5mLru66yrqkUGuXGXXjeJDqKVmLQWcNUmqttK(Fig0mHO7c95Iiuhwxnm6YHP9CqK2LrGbbOjP8dIXl7yHnd2lGVYO6WD1essIjcd05Kkj3XmgOiwwiLs9ydRiRUtJuiCt8JbzJ6Lb9yNSF5X4vvhnKypR4BO0iOSFbXPNkPsojpt7OygDSqlKkJhXRZgdO8AYnpn5A2QQ7)ryqu28NAG2NAG2)ZAGwFeK009lUV4UzNnZ(uPOSZOzhwhfNoBfnYwKabyPg8mQBtwnVGjPT6YqlBOfHOG426hglN40Q4yrXoVygPT8AnnX7VjeQGdBkd1GwGW8k40OLukUONjtedNyQ9sJsgg8LDudvYgs7WE3KzhUPoXY43Z0qS8lxFOx2B5ocjC6FcJoONweO9jSX(9nZw0(F99yK2hWwdz40(a2Qm7K2hWnjMHsUx8A0Xhzv3ZvUBpxDpBfWDN1H1PjhqFscbMurBontj9aaaR6ndk7avlIpJBJogsDhGwlxNKY5uqDYYSItsj0Hetbx1y3KDm6VMtKADS6SkEIukt(mtNpToS0zp61ix16Mw4m1uetIMOu6basNGaPeSOOfzY(b1oUigU5KVlYNLnjNtha696nsuu2T3yNAZm6UqQjXXM)pu3Z4P(Xo47WDtJLWi7OQd1nLxAMSdvYpNs2HazvlZNZizYpNviJrOkezQ6UN(FylJlV9ZCFZmM8UeU7W8I5k)SRrsYSDIxChBjkEhSpCzsYPofEaoLSmzLfiNYt4ELK2yXoxCtYGKdqWpv0Gje53MAdGLowq0wOK)SxZ7hxY7zB6DXhU16xASTEZt8)XPd(nHo7IBV8k)90N3DkSPDq4Slek5DJR7DTLdASRrfvTGFbSb7GW)(]] )

spec:RegisterPack( "血DK(黑科研)", 20260118, [[Hekili:TZ1xVTTrs8pl9LIyuC6SSKDsdsZd9YlNkqXbOEVsjkQvweHMuGIk(CrbHttSTSDsSZL)4RjPjXxRtD7L2A0uNQ4)K8D5QiL8t5RWTCxrjksn7ssj57oGOhmK4YDMF7SZ(BgoJKfsk8zczlkAGe(0PMCQzMmzYZLizY0PsNuiRXcvqczRikDzXzXVrvCo8FBV9Ix6toZjhE7wF3TB907oHZnSGIMyrhbvvRMUe(MeYwOMSIXFwvOGpPFwHSI1mkRPlK16o32AZTfYwwUyre9orvLeY(rH8LzMlHenkBM)tuLNTSX5nZ)XkAAfnZ)xvLVcsVQOIz()Gz(t(LhrWS1s7AV)vT)1xFYIpO1D3T1Q1nZy)I9S(6NzV1lB99h0A1xzv)F5C58ySonzU2F1bTV2XwF733E)1)J2)4ZS(QDT)MfT3F9wV4Wwh(eSaE4VAF)9S3Ah7h9KZtMiEro5mMz4bE3xyrq0HxXEEZmyDBiQGunsCfX5QiRllLRGZIlbsvSGccVi)3l)3nZBTzd8A7KNFuZxTo(nuG(2JQJxuwlTU9tBy9MR92Jw1R8kkQkjRoBo9AQOCZJeROP6tOTR)yR12T1ZFM99xHUM7k3w1x2AJB7tILrI6g5QAOlFzKF89MR1(6ByV6DSw5qQqitCwLfQuorr5QiXQ(NsR7)6wBT0jp8EyTJ1yZJEQ9tUJv9FdBMPdr0opZQ7lZmw38Enp(oT3)3SxDDSH1A59A)DpZDLU)EnBSM1To0(bBHbP7v3Er7FPH7kyL1p5HVS3YP3TzvFzS)KlQV6(oJKH(bIvYDeID0Av3p3XI(pFS99Q3Ny)BPmZ066V0AZB16rRBFTLSwE)2BVJ1g3aVM)9fVkvd43qHh(nDGweSfTE93grBb18ZWWKjDRh(t2pDLMhUtZgyxKhqxmV9OBG)yZgl2(4FcRMt(YFW5ixhJ00EMYA4PqLlZPWBT5(cVOE1lAT7lihhDC1S)XVXQrdhd5ohJnKKRr1hDb0SXnXQP9BwP5b3Y6MB)NUKdmoEzR9o(Kv2GoToY5WMhSnDZepb7VEhhVAQ)GZ4uGshP9XpNUaS24FyxFtVtnkRe77(Z234QTEW1P0w41tYeeWJ5YiNVnZFgcJ3NjQE5jmZmL7OTFn(82bUJEP)s2jcVAfYQix1OkHmhttOGWV7tjbj6Cmv4JfYkPlBG0LffY(EM5lQzKOKUwvJCLqyA3egYsxgptmpVKHSMQqwzPfYzOvtQSGbomaprrO5YvrrC2AOGYIE9oKnoYlfO8aizEFZ8LfRMRZ1RsUG)LGoAorzv8yxWmFQU3rFil4TCgZ807WHzTAcPA66y2rZ8x8JmZN0m)x8fyP4eVIoE3RpHNfhQQHmMsvISYsZYsbV4yTwspW7G9g20XhgGgS0d(w4VBpJR3OrFyY9(jX06C3Eak(Y44Nv0MhPtn7PM0ryNfCLXj0lg7EezonSrSKI28dghyfDoqfXwmu3fjnzfhP8HdbCXHOvmkNOIe2F8cydW0t6xl9qBYjzTJZxxsAAkf1MxDGzAOJelUqpDxRkkhw4ZvLOyM0mJyfRwwtzHCLWhr)8fikNjXeFLxOwPsduX1Q0tRfWzLI0j(4oQeM7AeQsYbSs10PRsMKk8vzGtsZ41rkiui6eMbHVcluthZtnVSArVhm63TzMHq(dybXqVqRqUmjdofz27H0XbJO0dvEfoboW8nVhNK2hriIEpEqexURydNGHuHnmtfgMTXcs8BqMcMQRhlgrEIQfZvejjUaLbJOjAW7bNMbE4oCBS3I8jDcOGPahEqXY6miSaZngcSWWcelWaZAgcWeqztXwzW0LbYBf8S4u(D9k0jjIPGjlzi9CZlIZm1BMz(KA8jaJ053HIylsNphcclW9eYW4NsaoVzYZiaL)(fXbN67Xf8BEsnC0BNA42VXofmzy4bTRl6OgSbmYHjpX)lI3agxyI0Wd2bsIocbDaJCyst9)bWDaJnm3D8Jz7c6yI409Hy)pSxk44broG(4fOWHy4z7InshC9l4dv4Wu8ZfWJy4gdkkpxtQjblprA44gbeZ5cu4a3YtKgMfNxMZb0sAyTat)gqkDEuoI1oN4veLvCMfTaibs4RRcG5lhamhScWdbVaGP2cHzILEqZrRJKNzsuimN0afyWDKl0)gc9uHHyfI0H5pGQh6ha8ScFael4e0ISYFLctrGj8RGmsmBzTAkjCeZvqK1z3031fXKa4KWfl6Vsr9gHOJqvlpcGpBO8okRPRMtRKtPgWYbRcdhpMsI1umeCR8U79oNm(bfkPJqFoYlgmyvv9(Q8h2koTNnseEtWzCh)TkAKlAWQI68PD8xNX0(zDCDBgH6WlZMSeQGwnhRKMUHSrTIecUHPaub0Mhdy)tZrtWNgihUlO5q8wwgPumHJBhrdDWG3XCLqVTQEd6OMZkWSm4(8P8JI(hMaehHc7zZ3kziphI4FfiE2S6YKD8pKnK9gsInNUJWcuIAxXijQOKJ(HCo9XYRSOh7ZHurZj7g(nfTDx5OF1ge1OvRYFKSWi9qv(0UMPKt3NI1QGrLor3(pjdRBpZVtN6iKhv0rsAZvqSh9rm3tj(kyPv1PHuuVKUOHsG7oiBgOqzzyPSoPH5rzWuuGo4WeUmiJgPhAz2iTrs0jdQl87Ay77)Ug2glyaAWExdBdISHOHTb8NhuSPPgloPm6UB8lrHFlqFf0MrBDJCjgyRiyQQOxIa2AcMeJ)t43VKgLzcZSR(Ctco2n(YVZljXF6mb9C9ep2F3l5KdDeaYfDXr4BCsGEc42IJXypEHTFrP5im66BubaSDJFpu6AVGz)ghQJrRDdV6a9kgtTaPl4HziJd4hVTwOlOHzBJdOpDkvFxWZTihGNMhnNwz0s5q0Hd(Nl8OP4t8hdI9r(jLago4WdHWWD6H7aBdXp(ry2ggxN5hTTGF8J3aMDUnrzOm7JBwRtPw8pYXT)TbgT4p(p1HlOJjI50ep4WBr(PwgVafougpBxSr6GRtaFOch0J)Jn5rmCJOfU6ay6wAbOYaWO54bedCJrz056asjwTSKr)MdOG40YsgnIEGYjODMzheHP0o97GiZ6MosQrBO7G9q1bXonu4)xReCeEobOm8HPAIFah)hq6RsoX(R(teR9emNu0P7zQiyAl(K19jiUnwmgjSaNIemz1qLHeCUnmQO6W9lszCKZeCuvgvpDODG9OLrz2kmuZOjtdgfnnsBTH8NRsuKzVVVgmQmzueOVFBsWhAJKqjNv6(RpIzIebA0FVTLb)ZUHrn)4vXZaHuVq)oca5hWOqDCzwgb)SAc8W4HPP7Jvef4XTJFD14bNtVQRnmijcvFtpcTsKrvV4H2aNSa)YvsYCedKQod55)xhZlQRIfEvHS2130ATNy9ZhzT0onpy5PB24hSxBrN)dzuFR2BV7VV4xAMX5BGIwjzfY)fqQwbj5KYIJOf(p]] )

spec:RegisterPack( "双持邪(哑吡)", 20260118, [[Hekili:TVvZlUTrB8)wwcy8scUsX76UbS9H3Bnh2lUNL8yPX2IiRXOp291bJjnLwcHanLE494l5qHsU0RLs7FnnBi9)I(mAS(A0mAKL8MpOHaztKEMNVMNp(9mJwdDJV2yInkeBC591U)anD9h0t7bN3)SZnMeUzn2yYAK1JqlG)HhAf8338dV4TV4B(7N(6U38t)4nV8vNsPyJlbzt5uajY3cOYyYSih3WVYZygh7haeTgBzCj8pw6yBJzKGdSORY1jimGYixN5y4NxgRFiRqhINXehl8msKNT5CIFOtyKnijShAMl224)yecYGsD2tMy57eI9Dqgtoz3014WEixNRWzm0h5eGnTXGYdRUV0vlyPWIcxAcoNqd6FG))CuKByjDELdvF9X4hFqk7SO5Z7f5TK4UXCTpoa7zH7fTE30o7MYyDVGOvRiEMlq(liBCX9cDwHndCac3nD4UP91YucogvTXMi9zUeIDjHdVne5I9c75SATp5kSTjVAUNR1vxhxuxlkwQQEMuvnwpxs89mjZnV2XdECpBY1EzCR4lPC78Q52mIhOzlDWU2CSk3BO8zqRI1(sUvNqLfY11K9FmPjd557smYnCzV1wHXBWNPXYxmzjMXzmaNVqcN9J8KXy6JVcBI9WRCWb7MoA3u9c8oGgIF5dApNhZZzejwP11ssCcZ4lkkKyIcdHcqftDaAG4dlYQzOSeUB1y5QcpLNh3KWt55L7v1vOa4b0fTyjjYnOSkwmstr2tTJ3LN3uN49b5RjUMW(j3EknwGV8zeWdqoRcev8Sk(vDboBsysmHlAreTGK1JC8wehw0D309HbqKnoGvSccfxH(VqIhKCyriUuFvpwtaeuH3gBH20ZhVc54bX5NMt5IfGzqOVZJuuoBVIn3Na5hZXxbHlC6f7vhd1YXAdS4iRLvV3wL(OYjUV2)ACqOJBC2uHY(0QmNb6uc5mwDmSTmjwDHAqOlC3SE5ERieToR312T7MMVGlu5AGwI2MxvTI89H8sMAQNymvOVi7nm2R2MI9rAfSTuvvuxKcHsRixLSzec9DHmuBOUlIHpGvIViyMufquBKcET4khaMnIlkElMAfmBI)nPMcvI9z0m3zXsiio9n7MEXTsyaJtzjE89VYvju0(5DlMUL)5fkpKfaawyM0XRwtUgkutjY8AmAn8WKoDh)CT261I5JA6Idi7DoVpEgXXn24ku7Ejm)Gpa2hARISSWUyFKG606fkLZbuKNw5f17YANtwSaGxMyibXMf4vCSmJ3nY2SOir0yj00yYUswBQlHhb7(84QyVUA2Fs7KGMwl26yuALS1jVTuL9Dk3YIlO6i01QgDLfKHCqR)aue10vYvhybZfVipia963YTqj0lu7tRJg2ylPaSbD5TwLVBKzfvUDQw3uXH4wrXyKPZF794Ilvn)lz7LqYPlV)Bk75G)NLuxBf4WOUQzl0L3uxwTt1YDFJ9ArB11GcJh089XeaSMfY7PslzxDeC)JzzLgnSqMnieZqIjiTss)Jyb6dESIwHH8ObvSPrT8al)OCcJpuZmupKCYXI3vIXFWWXpT9iYt9Xi)vBO1sdxYosJEIgJtarjrq0Tw1aJlHGMNJcHolEIMsn)y5xhPkwnnZjVgPaqFJNgsEvHkkT0PI3rTIbkzTAVrZCzCtyPQHWNNaQ(UwUjGQSD1T1eq1rXRdsJ2oau91d10vN5FQE0HprM)rEV0)Dm)J85joIZ)u5enYXr8XWenxEF5ylQOd9(B6PWltHnQmt(2OdEwdsXbuXyd1K2NpE2oixoG(YCFjaxJ89G22WODV9zV8MN))V5x)JB(UF(n)(3F(B(Tx)2N)K39T)5np7)9Ux9l)1tE6UhAqVrqigWyc7tpGElGK5oUPx6uqV0Rf8UJ(II3u39CMp6eX3fyNtQ5TaU7HIKtXOsQCKDVFIxF2fLrxRIB5tmlYDvDPYN)I9QJWpj9E8etnBm7Dpm9TWZY9boK)XCUWm3F5pQHoSvvXhjWW(A559XFNvTkmUOk0Gn9dDFQo7oan8FXa3JEX6JOFna01KnG5WZkya(fV0E2QGFcRH(4SlTFKUYLHi4YRBSEU4KEb0WN0JYH75jHvfFy(Unu239ezW(3Uvw72HJ6FANUYkwoCKQcGNYPuPT)ZuibZOW0hbyyyQJeOlhU2K)CiIvirNPY2TsgSHPmsgPPgkthvumEeTZHivoeTowFLC2iB3Mf2oEG2PDeCGadhP3PB1NbcV7IJO4uk2bE0H7WogMlONTwUcdCVvWjlW2pkR33vWHyCxrhGXPd7ZjfjhBavskoOITBvEifGFMtC8uY968T4tlMvcptRs(QBe2DUtYhBGKedj5PDKvqrEAHKCPoFqsJOhkqJmVd26e)8XJgiLvQSQgz2zGRz1FR7HDmwxtl5CioIhYXyD9Qz7jnLVG62ihuXbTJDsY62iPfvf9NuPqv1Pvwd6QwJA5PIcrUOcTWL2N(I24gurHi1QeCh5qAUOtJDzYxP0H7AK1ugECkxeDGansgflguQwGsEc4FusZE5MjzaQRyGSSxWJKD)t53BLIKTvTl5fBHiDzyvpoWr3BNPF3DnQRuxg3e)bdc7eN1k4Q8k77tKO5WFjpqtRKk2gaR1eEwfh1uRIfRxMvhPvDadst8owlg3z72cF6HdV4OgqjziG2mdq(raY7dAmWVwyU1BhLxFLmZcpzshVkFIWNX9j3pFRc8RgbhhxKF1qGQOqOx6JpSFsai8Pk4V9j93gO)Qhvvx549eir6HVghTX)RRyjsuEaVjeYen9x3qkHz)62qVzfJ)5p]] )



-- 简化专精选择器：只保留 血DK、冰DK、邪DK by 哑吡 20260103
spec:RegisterPackSelector( "blood", "血DK(黑科研)", "|T135770:0|t 血DK",
    "如果你在|T135770:0|t鲜血天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    function( tab1, tab2, tab3 )
        return tab1 > max( tab2, tab3 )
    end )

spec:RegisterPackSelector( "frost", "冰DK(黑科研)", "|T135773:0|t 冰DK",
    "如果你在|T135773:0|t冰霜天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    function( tab1, tab2, tab3 )
        return tab2 > max( tab1, tab3 )
    end )

spec:RegisterPackSelector( "unholy", "邪DK(黑科研)", "|T135775:0|t 邪DK",
    "如果你在|T135775:0|t邪恶天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    function( tab1, tab2, tab3 )
        return tab3 > max( tab1, tab2 )
    end )

-- 增加shouldPestilence函数，判断传染逻辑。by 风雪20250410
-- 泰坦重铸版修复：使用内部冷却和实时检查，避免重复推荐传染

-- 注册传染内部冷却的状态表达式
spec:RegisterStateExpr("pestilence_ready", function()
    -- 检查是否在内部冷却中
    local now = GetTime()
    if now - lastPestilenceTime < PESTILENCE_INTERNAL_CD then
        return false
    end
    -- 检查是否有可用符文（鲜血或死亡）by 哑吡 20251225
    if blood_runes.current == 0 and death_runes == 0 then
        return false
    end
    return true
end)

spec:RegisterStateExpr("shouldPestilence", function()
    -- 检查目标是否有疾病（必须有疾病才能传染）
    if not ( dot.frost_fever.ticking and dot.blood_plague.ticking ) then
        return false
    end
    
    -- 检查是否有可用符文（鲜血或死亡）by 哑吡 20251225
    if blood_runes.current == 0 and death_runes == 0 then
        return false
    end
    
    -- 泰坦重铸版修复：检查内部冷却（缩短到1.5秒，更积极传染）
    local now = GetTime()
    if now - lastPestilenceTime < 1.5 then
        return false
    end
    
    -- 疾病雕文检查：有雕文时可以刷新主目标疾病（即使单目标）by 哑吡 20260101
    if glyph.disease.enabled then
        -- 有疾病雕文：检查主目标疾病是否需要刷新（剩余时间<6秒）
        local needRefresh = dot.frost_fever.remains < 6 or dot.blood_plague.remains < 6
        if needRefresh then
            return true
        end
    end
    
    -- 单目标且没有疾病雕文时不需要传染
    local enemies = active_enemies or 1
    if enemies <= 1 then
        return false
    end
    
    -- 使用实时检查：计算缺少疾病的敌人数量
    local missingCount = countEnemiesMissingDisease()
    
    -- 如果有敌人缺少疾病，需要传染
    if missingCount > 0 then
        return true
    end
    
    -- 备用逻辑：如果 NamePlate 检测失败，但有多个敌人且最近没传染过
    -- 每8秒允许一次传染刷新（确保疾病不会掉）
    if enemies >= 2 and (now - lastPestilenceTime) > 8 then
        return true
    end
    
    return false
end)

-- 判断传染逻辑结束。

-- 新增death_runes函数，对可用死亡符文计数，不是通用的death_runes.current等函数。by 风雪20250411
-- 修复：使用状态预测系统中的buff来计算死亡符文，而不是直接调用游戏API by 哑吡 20251228
-- 这样可以确保在APL模拟执行技能后，死亡符文数量能正确更新

spec:RegisterStateExpr("death_runes", function()
    local count = 0
    -- 使用状态预测系统中的buff来计算死亡符文
    for i = 1, 6 do
        if buff[ "death_rune_" .. i ].up then
            count = count + 1
        end
    end
    return count
end)

-- 血沸和心脏打击的符文条件检查 - 灵活版 by 哑吡 20250102
spec:RegisterStateExpr("can_use_blood_ability", function()
    -- 有鲜血符文可用
    if blood_runes.current > 0 then return true end
    -- 有死亡符文时可以替代
    if death_runes > 0 then return true end
    return false
end)

-- 血沸的使用条件 - 灵活版 by 哑吡 20250102
spec:RegisterStateExpr("should_blood_boil", function()
    -- 检查符文条件：有鲜血或死亡符文就行
    if blood_runes.current == 0 and death_runes == 0 then return false end
    return true
end)


-- ==================== 泰坦重铸版APL支持 ====================
-- 新增状态表达式支持APL条件判断 by 泰坦优化版

-- 检测是否双持武器
spec:RegisterStateExpr("is_dual_wield", function()
    -- 检查副手是否有武器
    return off_hand.size > 0
end)

-- 检测是否双手武器
spec:RegisterStateExpr("is_two_handed", function()
    return main_hand.two_handed
end)

-- 检查宠物是否存活 - 使用直接API检测，避免NPC ID不匹配问题 by 哑吡 20250107
spec:RegisterStateExpr("pet_active", function()
    return UnitExists("pet") and not UnitIsDead("pet")
end)

-- 检测是否装备了疾病雕文 (Glyph of Disease, spellID: 63334) by 哑吡 20250107
spec:RegisterStateExpr("has_disease_glyph", function()
    return glyph.disease.enabled
end)

-- 检测是否可以召唤亡者（宠物不存在时可以召唤）by 哑吡 20250107
-- 使用 UnitExists("pet") 直接检测，避免NPC ID不匹配问题
spec:RegisterStateExpr("can_raise_dead", function()
    return not UnitExists("pet") or UnitIsDead("pet")
end)

-- 宠物身上的食尸鬼狂乱buff剩余时间
spec:RegisterStateExpr("pet_ghoul_frenzy_remains", function()
    -- 检查宠物是否存在
    if not UnitExists("pet") or UnitIsDead("pet") then
        return 0
    end
    
    -- 在宠物身上搜索食尸鬼狂乱buff
    for i = 1, 40 do
        local buffName, _, _, _, buffDuration, buffExpires, buffCaster, _, _, spellId = UnitBuff("pet", i)
        if not buffName then break end
        -- 检查是否是食尸鬼狂乱 (Ghoul Frenzy) - spell ID 63560
        if spellId == 63560 or buffName == "Ghoul Frenzy" or buffName == "食尸鬼狂乱" then
            if buffExpires and buffExpires > 0 then
                return max(0, buffExpires - GetTime())
            else
                -- 如果expires为0但有buff，返回默认30秒
                return 30
            end
        end
    end
    
    return 0
end)

-- 符文总数
spec:RegisterStateExpr("runes_available", function()
    return blood_runes.current + frost_runes.current + unholy_runes.current + death_runes
end)

-- 是否有任何疫病
spec:RegisterStateExpr("has_diseases", function()
    return dot.frost_fever.ticking and dot.blood_plague.ticking
end)

-- 疫病最短剩余时间
spec:RegisterStateExpr("diseases_min_remains", function()
    if not dot.frost_fever.ticking then return 0 end
    if not dot.blood_plague.ticking then return 0 end
    return min(dot.frost_fever.remains, dot.blood_plague.remains)
end)

-- 宠物血量百分比表达式，方便管理宠物血量（食尸鬼/石像鬼）
spec:RegisterStateExpr("pet_health_pct", function()
    -- 边缘情况处理：如果宠物不存在或已死亡，返回0
    if not UnitExists("pet") or UnitIsDead("pet") then
        return 0
    end
    -- 计算血量百分比：(当前血量 / 最大血量) * 100
    return (UnitHealth("pet") / UnitHealthMax("pet")) * 100
end)


-- ==================== 智能符文优化系统 ====================
-- 最大化DPS输出的符文管理策略 by 智能优化版 20251227

-- 获取指定符文类型的冷却剩余时间（返回最短的那个）
spec:RegisterStateExpr("blood_rune_cd", function()
    local cd1 = blood_runes.expiry[1] - state.query_time
    local cd2 = blood_runes.expiry[2] - state.query_time
    return max(0, min(cd1, cd2))
end)

spec:RegisterStateExpr("frost_rune_cd", function()
    local cd1 = frost_runes.expiry[1] - state.query_time
    local cd2 = frost_runes.expiry[2] - state.query_time
    return max(0, min(cd1, cd2))
end)

spec:RegisterStateExpr("unholy_rune_cd", function()
    local cd1 = unholy_runes.expiry[1] - state.query_time
    local cd2 = unholy_runes.expiry[2] - state.query_time
    return max(0, min(cd1, cd2))
end)

-- 获取所有符文中最快刷新的时间
spec:RegisterStateExpr("next_rune_in", function()
    local times = {}
    for i = 1, 2 do
        if blood_runes.expiry[i] > state.query_time then
            table.insert(times, blood_runes.expiry[i] - state.query_time)
        end
        if frost_runes.expiry[i] > state.query_time then
            table.insert(times, frost_runes.expiry[i] - state.query_time)
        end
        if unholy_runes.expiry[i] > state.query_time then
            table.insert(times, unholy_runes.expiry[i] - state.query_time)
        end
    end
    if #times == 0 then return 0 end
    table.sort(times)
    return times[1]
end)

-- 符文即将浪费检测：如果符文快刷新但已有可用符文，应该先消耗
spec:RegisterStateExpr("blood_rune_wasting", function()
    -- 如果已有2个鲜血符文可用，且有符文即将刷新，就是浪费
    if blood_runes.current >= 2 then return true end
    -- 如果有1个可用，且另一个在1.5秒内刷新
    if blood_runes.current >= 1 then
        local cd = blood_rune_cd
        if cd > 0 and cd < 1.5 then return true end
    end
    return false
end)

spec:RegisterStateExpr("frost_rune_wasting", function()
    if frost_runes.current >= 2 then return true end
    if frost_runes.current >= 1 then
        local cd = frost_rune_cd
        if cd > 0 and cd < 1.5 then return true end
    end
    return false
end)

spec:RegisterStateExpr("unholy_rune_wasting", function()
    if unholy_runes.current >= 2 then return true end
    if unholy_runes.current >= 1 then
        local cd = unholy_rune_cd
        if cd > 0 and cd < 1.5 then return true end
    end
    return false
end)

-- 任意符文即将浪费
spec:RegisterStateExpr("any_rune_wasting", function()
    return blood_rune_wasting or frost_rune_wasting or unholy_rune_wasting
end)

-- 符能即将溢出检测（超过100时应该消耗）
spec:RegisterStateExpr("runic_power_overflow", function()
    return runic_power.current >= 100
end)

-- 符能高位检测（超过80，应该考虑消耗）
spec:RegisterStateExpr("runic_power_high", function()
    return runic_power.current >= 80
end)

-- 智能死亡符文使用判断：何时应该用死亡符文替代特定符文
-- 原则：当特定符文充足时保留死亡符文，当特定符文不足时使用死亡符文
spec:RegisterStateExpr("should_use_death_for_blood", function()
    -- 没有鲜血符文但有死亡符文时使用
    if blood_runes.current == 0 and death_runes > 0 then return true end
    -- 鲜血符文即将浪费时不用死亡符文
    if blood_rune_wasting then return false end
    return false
end)

spec:RegisterStateExpr("should_use_death_for_frost", function()
    if frost_runes.current == 0 and death_runes > 0 then return true end
    if frost_rune_wasting then return false end
    return false
end)

spec:RegisterStateExpr("should_use_death_for_unholy", function()
    if unholy_runes.current == 0 and death_runes > 0 then return true end
    if unholy_rune_wasting then return false end
    return false
end)

-- 符文对齐检测：检查是否有多个符文同时可用（爆发窗口）
spec:RegisterStateExpr("rune_pairs_ready", function()
    local pairs = 0
    if blood_runes.current >= 2 then pairs = pairs + 1 end
    if frost_runes.current >= 2 then pairs = pairs + 1 end
    if unholy_runes.current >= 2 then pairs = pairs + 1 end
    return pairs
end)

-- 全符文就绪（6符文爆发窗口）
spec:RegisterStateExpr("all_runes_ready", function()
    return blood_runes.current >= 2 and frost_runes.current >= 2 and unholy_runes.current >= 2
end)

-- 符文效率评分：评估当前符文状态的效率（0-100）
-- 高分意味着符文利用率高，低分意味着有浪费
spec:RegisterStateExpr("rune_efficiency", function()
    local score = 100
    -- 每个满的符文对扣分（浪费冷却时间）
    if blood_runes.current >= 2 then score = score - 15 end
    if frost_runes.current >= 2 then score = score - 15 end
    if unholy_runes.current >= 2 then score = score - 15 end
    -- 符能溢出扣分
    if runic_power.current >= 130 then score = score - 20 end
    -- 死亡符文过多扣分（应该使用）
    if death_runes >= 4 then score = score - 10 end
    return max(0, score)
end)

-- 应该使用符能技能（防止溢出）
spec:RegisterStateExpr("should_dump_runic_power", function()
    -- 符能超过100必须消耗
    if runic_power.current >= 100 then return true end
    -- 符能超过80且没有符文可用时消耗
    if runic_power.current >= 80 and runes_available == 0 then return true end
    return false
end)

-- 智能技能优先级辅助：判断是否应该优先使用某类符文技能
-- 返回应该优先消耗的符文类型："blood", "frost", "unholy", "death", "none"
spec:RegisterStateExpr("priority_rune_type", function()
    -- 优先消耗即将浪费的符文
    if blood_rune_wasting then return "blood" end
    if frost_rune_wasting then return "frost" end
    if unholy_rune_wasting then return "unholy" end
    -- 死亡符文过多时优先消耗
    if death_runes >= 4 then return "death" end
    -- 否则返回当前最多的符文类型
    local b, f, u = blood_runes.current, frost_runes.current, unholy_runes.current
    if b >= f and b >= u then return "blood" end
    if f >= b and f >= u then return "frost" end
    return "unholy"
end)

-- 符文冷却同步度：检测符文冷却是否同步（便于爆发）
-- 返回0-1，1表示完全同步
spec:RegisterStateExpr("rune_sync_score", function()
    local cds = {}
    for i = 1, 2 do
        local bcd = blood_runes.expiry[i] - state.query_time
        local fcd = frost_runes.expiry[i] - state.query_time
        local ucd = unholy_runes.expiry[i] - state.query_time
        if bcd > 0 then table.insert(cds, bcd) end
        if fcd > 0 then table.insert(cds, fcd) end
        if ucd > 0 then table.insert(cds, ucd) end
    end
    if #cds < 2 then return 1 end
    table.sort(cds)
    -- 计算冷却时间的标准差
    local sum = 0
    for _, cd in ipairs(cds) do sum = sum + cd end
    local avg = sum / #cds
    local variance = 0
    for _, cd in ipairs(cds) do variance = variance + (cd - avg)^2 end
    local stddev = math.sqrt(variance / #cds)
    -- 标准差越小，同步度越高
    return max(0, 1 - stddev / 5)
end)

-- 爆发窗口检测：是否处于适合爆发的状态
spec:RegisterStateExpr("burst_window", function()
    -- 至少4个符文可用
    if runes_available < 4 then return false end
    -- 符能充足
    if runic_power.current < 40 then return false end
    -- 有重要buff时
    if buff.bloodlust.up or buff.heroism.up then return true end
    if buff.unholy_frenzy.up then return true end
    if buff.dancing_rune_weapon.up then return true end
    -- 符文同步度高时
    if rune_sync_score > 0.7 and runes_available >= 5 then return true end
    return false
end)

-- 保守模式：是否应该保留符文（等待爆发窗口）
spec:RegisterStateExpr("conserve_runes", function()
    -- 如果有符文即将浪费，不保守
    if any_rune_wasting then return false end
    -- 如果大招快好了，保留符文
    if cooldown.summon_gargoyle.remains > 0 and cooldown.summon_gargoyle.remains < 10 then return true end
    if cooldown.dancing_rune_weapon.remains > 0 and cooldown.dancing_rune_weapon.remains < 10 then return true end
    return false
end)

-- 疾病刷新优先级：是否应该优先刷新疾病
spec:RegisterStateExpr("disease_refresh_priority", function()
    -- 疾病不存在，最高优先级
    if not dot.frost_fever.ticking or not dot.blood_plague.ticking then return true end
    -- 疾病即将消失（<3秒）
    if diseases_min_remains < 3 then return true end
    -- 有瘟疫打击天赋且疾病<6秒时刷新
    if talent.epidemic.enabled and diseases_min_remains < 6 then return true end
    return false
end)


-- PVP 专精选择器已移除，简化为3个主要专精 by 哑吡 20260103
