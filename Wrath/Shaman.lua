if UnitClassBase( 'player' ) ~= 'SHAMAN' then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local spec = Hekili:NewSpecialization( 7 )

spec:RegisterGear( "tier10enhancement", 50830, 50831, 50832, 50833, 50834, 51195, 51196, 51197, 51198, 51199, 51244, 51243, 51242, 51241, 51240 )

local LastConsumedStackTS, LastSwingTimestamp, last_consumed_stack_ts = 0,0,0
spec:RegisterResource( Enum.PowerType.Mana, {
    mainhand = {
        swing = "mainhand",
        aura = "flurry",

        last = function ()
            local swing = state.combat == 0 and state.now or state.swings.mainhand
            local t = state.query_time

            return swing + ( floor( ( t - swing ) / state.swings.mainhand_speed ) * state.swings.mainhand_speed )
        end,

        interval = "mainhand_speed",

        stop = function () return state.swings.mainhand == 0 end,
        value = function( now )
            local secsSinceLastConsume = now - last_consumed_stack_ts
            if secsSinceLastConsume >= 0.5 and state.buff.flurry.stack > 0 then
                state.removeStack("flurry")
            end
            return 0
        end,
    },

    offhand = {
        swing = "offhand",
        aura = "flurry",

        last = function ()
            local swing = state.combat == 0 and state.now or state.swings.offhand
            local t = state.query_time

            return swing + ( floor( ( t - swing ) / state.swings.offhand_speed ) * state.swings.offhand_speed )
        end,

        interval = "offhand_speed",

        stop = function () return state.swings.offhand == 0 end,
        value = function( now )
            local secsSinceLastConsume = now - last_consumed_stack_ts
            if secsSinceLastConsume >= 0.5 and state.buff.flurry.stack > 0  then
                state.removeStack("flurry")
            end
            return 0
        end,
    }
} )

-- Talents
spec:RegisterTalents( {
    ancestral_awakening       = {  2061, 3, 51556, 51557, 51558 },
    ancestral_healing         = {   581, 3, 16176, 16235, 16240 },
    ancestral_knowledge       = {   614, 5, 17485, 17486, 17487, 17488, 17489 },
    anticipation              = {   601, 3, 16254, 16271, 16272 },
    astral_shift              = {  2050, 3, 51474, 51478, 51479 },
    blessing_of_the_eternals  = {  2060, 2, 51554, 51555 },
    booming_echoes            = {  2262, 2, 63370, 63372 },
    call_of_flame             = {   561, 3, 16038, 16160, 16161 },
    call_of_thunder           = {   562, 1, 16041 },
    cleanse_spirit            = {  2084, 1, 51886 },
    concussion                = {   563, 5, 16035, 16105, 16106, 16107, 16108 },
    convection                = {   564, 5, 16039, 16109, 16110, 16111, 16112 },
    dual_wield                = {  1690, 1, 30798 },
    dual_wield_specialization = {  1692, 3, 30816, 30818, 30819 },
    earth_shield              = {  1698, 1,   974 },
    earthen_power             = {  2056, 2, 51523, 51524 },
    earths_grasp              = {  2101, 2, 16043, 16130 },
    elemental_devastation     = {  1645, 3, 30160, 29179, 29180 },
    elemental_focus           = {   574, 1, 16164 },
    elemental_fury            = {   565, 5, 16089, 60184, 60185, 60187, 60188 },
    elemental_mastery         = {   573, 1, 16166 },
    elemental_oath            = {  2049, 2, 51466, 51470 },
    elemental_precision       = {  1685, 3, 30672, 30673, 30674 },
    elemental_reach           = {  1641, 2, 28999, 29000 },
    elemental_warding         = {  1640, 3, 28996, 28997, 28998 },
    elemental_weapons         = {   611, 3, 16266, 29079, 29080 },
    enhancing_totems          = {   610, 3, 16259, 16295, 52456 },
    eye_of_the_storm          = {  1642, 3, 29062, 29064, 29065 },
    feral_spirit              = {  2058, 1, 51533 },
    flurry                    = {   602, 5, 16256, 16281, 16282, 16283, 16284 },
    focused_mind              = {  1695, 3, 30864, 30865, 30866 },
    frozen_power              = {  2263, 2, 63373, 63374 },
    guardian_totems           = {   609, 2, 16258, 16293 },
    healing_focus             = {   587, 3, 16181, 16230, 16232 },
    healing_grace             = {  1646, 3, 29187, 29189, 29191 },
    healing_way               = {  1648, 3, 29206, 29205, 29202 },
    improved_chain_heal       = {  1697, 2, 30872, 30873 },
    improved_earth_shield     = {  2059, 2, 51560, 51561 },
    improved_fire_nova        = {   567, 2, 16086, 16544 },
    improved_ghost_wolf       = {   605, 2, 16262, 16287 },
    improved_healing_wave     = {   586, 5, 16182, 16226, 16227, 16228, 16229 },
    improved_reincarnation    = {   589, 2, 16184, 16209 },
    improved_shields          = {   607, 3, 16261, 16290, 51881 },
    improved_stormstrike      = {  2054, 2, 51521, 51522 },
    improved_water_shield     = {   583, 3, 16180, 16196, 16198 },
    improved_windfury_totem   = {  1647, 2, 29192, 29193 },
    lava_flows                = {  2051, 3, 51480, 51481, 51482 },
    lava_lash                 = {  2249, 1, 60103 },
    lightning_mastery         = {   721, 5, 16578, 16579, 16580, 16581, 16582 },
    lightning_overload        = {  1686, 3, 30675, 30678, 30679 },
    maelstrom_weapon          = {  2057, 5, 51528, 51529, 51530, 51531, 51532 },
    mana_tide_totem           = {   590, 1, 16190 },
    mental_dexterity          = {  2083, 3, 51883, 51884, 51885 },
    mental_quickness          = {  1691, 3, 30812, 30813, 30814 },
    natures_blessing          = {  1696, 3, 30867, 30868, 30869 },
    natures_guardian          = {  1699, 5, 30881, 30883, 30884, 30885, 30886 },
    natures_swiftness         = {   591, 1, 16188 },
    purification              = {   592, 5, 16178, 16210, 16211, 16212, 16213 },
    restorative_totems        = {   588, 3, 16187, 16205, 16206 },
    reverberation             = {   575, 5, 16040, 16113, 16114, 16115, 16116 },
    riptide                   = {  2064, 1, 61295 },
    shamanism                 = {  2252, 5, 62097, 62098, 62099, 62100, 62101 },
    shamanistic_focus         = {   617, 1, 43338 },
    shamanistic_rage          = {  1693, 1, 30823 },
    spirit_weapons            = {   616, 1, 16268 },
    static_shock              = {  2055, 3, 51525, 51526, 51527 },
    storm_earth_and_fire      = {  2052, 3, 51483, 51485, 51486 },
    stormstrike               = {   901, 1, 17364 },
    thundering_strikes        = {   613, 5, 16255, 16302, 16303, 16304, 16305 },
    thunderstorm              = {  2053, 1, 51490 },
    tidal_focus               = {   593, 5, 16179, 16214, 16215, 16216, 16217 },
    tidal_force               = {   582, 1, 55198 },
    tidal_mastery             = {   594, 5, 16194, 16218, 16219, 16220, 16221 },
    tidal_waves               = {  2063, 5, 51562, 51563, 51564, 51565, 51566 },
    totem_of_wrath            = {  1687, 1, 30706 },
    totemic_focus             = {   595, 5, 16173, 16222, 16223, 16224, 16225 },
    toughness                 = {   615, 5, 16252, 16306, 16307, 16308, 16309 },
    unleashed_rage            = {  1689, 3, 30802, 30808, 30809 },
    unrelenting_storm         = {  1682, 3, 30664, 30665, 30666 },
    weapon_mastery            = {  1643, 3, 29082, 29084, 29086 },
} )


-- Auras
spec:RegisterAuras( {
    -- Reduces physical damage taken by $s1%.
    ancestral_fortitude = {
        id = 16237,
        duration = 15,
        max_stack = 1,
        copy = { 16177, 16236, 16237 },
    },
    -- Damage reduced.
    astral_shift = {
        id = 52179,
        duration = 3600,
        tick_time = 1,
        max_stack = 1,
    },
    -- Enabled Cleanse Spirit.
    can_cleanse_spirit = {
        alias = { "dispellable_poison", "dispellable_disease", "dispellable_curse" },
        aliasMode = "first",
        aliasType = "buff",
    },
    -- Enable Cleanse Toxins.
    can_cure_toxins = {
        alias = { "dispellable_poison", "dispellable_disease" },
        aliasMode = "first",
        aliasType = "buff",
    },
    -- Your next $n damage or healing spells have their mana cost reduced by $s1%.
    clearcasting = {
        id = 16246,
        duration = 15,
        max_stack = 2,
    },
    -- Reduces casting or channeling time lost when damaged by $s2% and attacks heal the shielded target for $s1.
    earth_shield = {
        id = 49284,
        duration = 600,
        max_stack = 1,
        copy = { 974, 32593, 32594, 49283, 49284 },
    },
    -- Time between attacks increased by $w1%.
    earth_shock = {
        id = 49231,
        duration = 8,
        max_stack = 1,
        copy = { 8042, 8044, 8045, 8046, 10412, 10413, 10414, 25454, 49230, 49231 },
    },
    -- Increases your chance to get a critical strike with melee attacks by $s1%.
    elemental_devastation = {
        id = 30165,
        duration = 10,
        max_stack = 1,
        copy = { 29177, 29178, 30165 },
    },
    -- Makes LB, CL, LvB instant.
    elemental_mastery = {
        id = 16166,
        duration = 30,
        max_stack = 1,
    },
    -- Casting speed of all spells increased by $s1%.
    elemental_mastery_haste = {
        id = 64701,
        duration = 15,
        max_stack = 1,
    },
    -- Cannot move while using Farsight.
    far_sight = {
        id = 6196,
        duration = 60,
        max_stack = 1,
    },
    feral_spirit = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=51533)
        id = 51533,
        duration = 45,
        max_stack = 1,
    },
    -- $s2 Fire damage every $t2 seconds.
    flame_shock = {
        id = 49233,
        duration = function() return 18 * haste end, --修复by风雪 20250808
        max_stack = 1,
        copy = { 8050, 8052, 8053, 10447, 10448, 25457, 29228, 49232, 49233 },
    },
    flurry = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=16284)
        id = 16284,
        duration = 3600,
        max_stack = 1,
        copy = { 16284, 16283, 16282, 16281, 16280, 16279, 16278, 16277, 16257, 16256 },
    },
    -- Movement slowed to $s1% of normal speed.
    frost_shock = {
        id = 49236,
        duration = function() return glyph.frost_shock.enabled and 10 or 8 end,
        max_stack = 1,
        copy = { 8056, 8058, 10472, 10473, 25464, 49235, 49236 },
    },
    frost_resistance = {
        id = 58744,
        duration = 3600,
        max_stack = 1,
    },
    -- Increases movement speed by $s2%$?s59289[ and regenerates $59289s1% of your maximum health every 5 sec][].  Effects that reduce movement speed may not bring you below your normal movement speed.
    ghost_wolf = {
        id = 2645,
        duration = 3600,
        max_stack = 1,
    },
    grounding_totem_effect = {
        id = 8178,
        duration = 3600,
        max_stack = 1,
    },
    -- Cannot attack or cast spells.
    hex = {
        id = 51514,
        duration = 30,
        max_stack = 1,
    },
    -- Causes $49279s1 Nature damage to attacker on hit.  $n charges.
    lightning_shield = {
        id = 49281,
        duration = 600,
        max_stack = function() return 3 + talent.static_shock.rank * 2 end,
        copy = { 324, 325, 905, 945, 8134, 8788, 10431, 10432, 25469, 25472, 49280, 49281 },
    },
    -- Reduces the cast time of your next Lightning Bolt, Chain Lightning, Lesser Healing Wave, Healing Wave, Chain Heal, or Hex spell by $s1%.
    maelstrom_weapon = {
        id = 53817,
        duration = 30,
        max_stack = 5,
        copy = { 1283511 }, -- 泰坦服熔岩武器（双手形态）的漩涡武器ID
    },
    -- Your next Nature spell with a casting time less than 10 secs will be an instant cast spell.
    natures_swiftness = {
        id = 16188,
        duration = 3600,
        max_stack = 1,
    },
    -- Heals $s2 every $t2 seconds.  Increases caster's Chain Heal by $s3%.
    riptide = {
        id = 61301,
        duration = function() return glyph.riptide.enabled and 21 or 15 end,
        max_stack = 1,
        copy = { 61295, 61299, 61300, 61301, 66053 },
    },
    -- All damage taken reduced by $s2% and successful melee attacks have a chance to regenerate mana equal to $s1% of your attack power.
    shamanistic_rage = {
        id = 30823,
        duration = 15,
        max_stack = 1,
    },
    -- Any elemental shield is applied.
    shield = {
        alias = { "lightning_shield", "earth_shield", "water_shield" },
        aliasMode = "first",
        aliasType = "buff",
    },
    -- Increases Nature damage taken from the Shaman by $s1%.
    stormstrike = {
        id = 17364,
        duration = 12,
        max_stack = 4,
    },
    -- Increases the critical effect chance of your Healing Wave, Lesser Healing Wave and Chain Heal by $s1%. Each critical heal reduces the chance by 20%. Lasts $55166d.
    tidal_force = {
        id = 55198,
        duration = 20,
        max_stack = 1,
    },
    -- Cast time of next Healing Wave reduced by $s1%.  Critical effect chance of next Lesser Healing Wave increased by $s2%.
    tidal_waves = {
        id = 53390,
        duration = 15,
        max_stack = 1,
    },
    -- Attack power party buff.
    unleashed_rage = {
        id = 30809,
        duration = 3600,
        max_stack = 1,
    },
    -- Able to breathe underwater.
    water_breathing = {
        id = 131,
        duration = 600,
        max_stack = 1,
    },
    -- $s2 mana per 5 sec.  Attacks and spells used against you restore $57961s1 mana.  $n charges.
    water_shield = {
        id = 57960,
        duration = 600,
        max_stack = function() return glyph.water_shield.enabled and 4 or 3 end,
        copy = { 24398, 33736, 52127, 52129, 52131, 52134, 52136, 52138, 57960 },
    },
    -- Allows walking over water.
    water_walking = {
        id = 546,
        duration = 600,
        max_stack = 1,
    },

    -- Totems.
    earthbind_totem = {
        duration = 45,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 2 )

            if up and texture == 136102 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    earth_elemental_totem = {
        duration = 120,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 2 )

            if up and texture == 136024 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    stoneclaw_totem = {
        duration = 15,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 2 )

            if up and texture == 136097 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    stoneskin_totem = {
        duration = 120,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 2 )

            if up and texture == 136098 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    strength_of_earth_totem = {
        duration = 120,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 2 )

            if up and texture == 136023 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    tremor_totem = {
        duration = 120,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 2 )

            if up and texture == 136108 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    earth_totem = {
        alias = { "earthbind_totem", "stoneclaw_totem", "stoneskin_totem", "strength_of_earth_totem", "earth_elemental_totem", "tremor_totem" },
        aliasMode = "first",
        aliasType = "buff",
    },

    flametongue_totem = {
        duration = 120,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 1 )

            if up and texture == 136040 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    magma_totem = {
        duration = 20,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 1 )

            if up and texture == 135826 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    searing_totem = {
        duration = 50,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 1 )

            if up and texture == 135825 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    frost_resistance_totem = {
        duration = 120,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 1 )

            if up and texture == 135866 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    fire_elemental_totem = {
        duration = 300,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 1 )

            if up and texture == 135790 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    totem_of_wrath = {
        duration = 300,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 1 )

            if up and texture == 135829 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    fire_totem = {
        alias = { "flametongue_totem", "magma_totem", "searing_totem", "frost_resistance_totem", "fire_elemental_totem", "totem_of_wrath" },
        aliasMode = "first",
        aliasType = "buff",
    },

    fire_resistance_totem = {
        duration = 120,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 3 )

            if up and texture == 135832 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    cleansing_totem = {
        duration = 120,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 3 )

            if up and texture == 136019 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    healing_stream_totem = {
        duration = 120,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 3 )

            if up and texture == 135127 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    mana_spring_totem = {
        duration = 120,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 3 )

            if up and texture == 136053 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    mana_tide_totem = {
        duration = 120,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 3 )

            if up and texture == 135861 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    water_totem = {
        alias = { "fire_resistance_totem", "cleansing_totem", "healing_stream_totem", "mana_spring_totem", "mana_tide_totem" },
        aliasMode = "first",
        aliasType = "buff",
    },

    grounding_totem = {
        duration = 45,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 4 )

            if up and texture == 136039 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    nature_resistance_totem = {
        duration = 300,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 4 )

            if up and texture == 136061 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    sentry_totem = {
        duration = 300,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 4 )

            if up and texture == 136082 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    windfury_totem = {
        duration = 300,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 4 )

            if up and texture == 136114 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    wrath_of_air_totem = {
        duration = 300,
        max_stack = 1,
        generate = function( t )
            local up, name, start, duration, texture = GetTotemInfo( 4 )

            if up and texture == 136092 then
                t.count = 1
                t.expires = start + duration
                t.applied = start
                t.caster = "player"
                return
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },
    air_totem = {
        alias = { "grounding_totem", "nature_resistance_totem", "sentry_totem", "windfury_totem", "wrath_of_air_totem" },
        aliasMode = "first",
        aliasType = "buff",
    },
    -- 狮心 - 人类种族技能buff
    lions_heart = {
        id = 20599,
        duration = 15,
        max_stack = 1,
    },
} )


-- Glyphs
spec:RegisterGlyphs( {
    [58058] = "astral_recall",
    [55437] = "chain_heal",
    [55449] = "chain_lightning",
    [63279] = "earth_shield",
    [55439] = "earthliving_weapon",
    [55452] = "elemental_mastery",
    [63271] = "feral_spirit",
    [55455] = "fire_elemental_totem",
    [55450] = "fire_nova",
    [55447] = "flame_shock",
    [55451] = "flametongue_weapon",
    [55443] = "frost_shock",
    [59289] = "ghost_wolf",
    [55456] = "healing_stream_totem",
    [55440] = "healing_wave",
    [63291] = "hex",
    [55454] = "lava",
    [55444] = "lava_lash",
    [55438] = "lesser_healing_wave",
    [55453] = "lightning_bolt",
    [55448] = "lightning_shield",
    [55441] = "mana_tide",
    [58059] = "renewed_life",
    [63273] = "riptide",
    [55442] = "shocking",
    [63298] = "stoneclaw_totem",
    [55446] = "stormstrike",
    [58135] = "arctic_wolf",
    [58134] = "black_wolf",
    [63270] = "thunder",
    [62132] = "thunderstorm",
    [63280] = "totem_of_wrath",
    [58055] = "water_breathing",
    [55436] = "water_mastery",
    [58063] = "water_shield",
    [58057] = "water_walking",
    [55445] = "windfury_weapon",
} )


-- 武器附魔状态变量 - 这些值在 reset_precast 钩子中设置
local _windfury_mainhand, _windfury_offhand = false, false
local _flametongue_mainhand, _flametongue_offhand = false, false
local _frostbrand_mainhand, _frostbrand_offhand = false, false
local _rockbiter_mainhand, _rockbiter_offhand = false, false
local _mainhand_imbued, _offhand_imbued = false, false

spec:RegisterStateExpr( "windfury_mainhand", function () return _windfury_mainhand end )
spec:RegisterStateExpr( "windfury_offhand", function () return _windfury_offhand end )
spec:RegisterStateExpr( "flametongue_mainhand", function () return _flametongue_mainhand end )
spec:RegisterStateExpr( "flametongue_offhand", function () return _flametongue_offhand end )
spec:RegisterStateExpr( "frostbrand_mainhand", function () return _frostbrand_mainhand end )
spec:RegisterStateExpr( "frostbrand_offhand", function () return _frostbrand_offhand end )
spec:RegisterStateExpr( "rockbiter_mainhand", function () return _rockbiter_mainhand end )
spec:RegisterStateExpr( "rockbiter_offhand", function () return _rockbiter_offhand end )
spec:RegisterStateExpr( "mainhand_imbued", function () return _mainhand_imbued end )
spec:RegisterStateExpr( "offhand_imbued", function () return _offhand_imbued end )

local GetWeaponEnchantInfo = _G.GetWeaponEnchantInfo

local enchant_ids = {
    -- Windfury (所有等级)
    [283]  = "windfury",  -- Rank 1
    [284]  = "windfury",  -- Rank 2
    [525]  = "windfury",  -- Rank 3
    [1669] = "windfury",  -- Rank 4
    [2636] = "windfury",  -- Rank 5
    [3785] = "windfury",  -- Rank 6
    [3786] = "windfury",  -- Rank 7
    [3787] = "windfury",  -- Rank 8
    -- Flametongue (所有等级)
    [5]    = "flametongue",  -- Rank 1
    [4]    = "flametongue",  -- Rank 2
    [3]    = "flametongue",  -- Rank 3
    [523]  = "flametongue",  -- Rank 4
    [1665] = "flametongue",  -- Rank 5
    [1666] = "flametongue",  -- Rank 6
    [2634] = "flametongue",  -- Rank 7
    [3779] = "flametongue",  -- Rank 8
    [3780] = "flametongue",  -- Rank 9
    [3781] = "flametongue",  -- Rank 10
    -- Frostbrand (所有等级)
    [2]    = "frostbrand",
    [12]   = "frostbrand",
    [524]  = "frostbrand",
    [1667] = "frostbrand",
    [1668] = "frostbrand",
    [2635] = "frostbrand",
    [3782] = "frostbrand",  -- Rank 7
    [3783] = "frostbrand",  -- Rank 8
    [3784] = "frostbrand",  -- Rank 9
    -- Rockbiter (所有等级)
    [3023] = "rockbiter",
    [3026] = "rockbiter",
    [3028] = "rockbiter",
    [3031] = "rockbiter",
    [3034] = "rockbiter",
    [3037] = "rockbiter",
    [3040] = "rockbiter",
    [3043] = "rockbiter",
    -- Earthliving (所有等级)
    [3345] = "earthliving",
    [3346] = "earthliving",
    [3347] = "earthliving",
    [3348] = "earthliving",
    [3349] = "earthliving",
    [3350] = "earthliving",
}

local MainhandHasSpellpower = false
spec:RegisterStateExpr( "mainhand_has_spellpower", function() return MainhandHasSpellpower end )

local AURA_APPLIED_EVENTS = {
    SPELL_AURA_APPLIED      = 1,
    SPELL_AURA_APPLIED_DOSE = 1,
    SPELL_AURA_REFRESH      = 1,
}

local AURA_REMOVED_EVENTS = {
    SPELL_AURA_REMOVED      = 1,
    SPELL_AURA_REMOVED_DOSE = 1,
}

spec:RegisterCombatLogEvent( function( _, subtype, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName, _, ...)
    if sourceGUID ~= state.GUID then
        return
    end

    local timestamp = GetTime()
    if subtype == "SWING_DAMAGE" then
        LastSwingTimestamp = timestamp
    end

    if spellID == state.buff.flurry.id then
        local _, amount = select(1, ...)
        local secsSinceLastConsume = timestamp - LastConsumedStackTS
        if AURA_APPLIED_EVENTS[subtype] then
            if secsSinceLastConsume > 0.5 then
                LastConsumedStackTS = timestamp
            end
        end

        if AURA_REMOVED_EVENTS[subtype] then
            LastConsumedStackTS = timestamp
        end
    end

end, false )

local reset_gear = function()
    MainhandHasSpellpower = false
end

local update_gear = function(slotId, itemId)
    if slotId == 16 then
        local mhStats = GetItemStats("item:"..itemId)
        local mhSpellPower = mhStats and mhStats["ITEM_MOD_SPELL_POWER"]
        MainhandHasSpellpower = mhSpellPower and tonumber(mhSpellPower) > 0
    end
end

spec:RegisterHook( "reset_precast", function()
    _windfury_mainhand = false
    _windfury_offhand = false
    _flametongue_mainhand = false
    _flametongue_offhand = false
    _frostbrand_mainhand = false
    _frostbrand_offhand = false
    _rockbiter_mainhand = false
    _rockbiter_offhand = false
    _mainhand_imbued = false
    _offhand_imbued = false

    -- GetWeaponEnchantInfo 返回值:
    -- 1: hasMainHandEnchant (boolean)
    -- 2: mainHandExpiration (number)
    -- 3: mainHandCharges (number)
    -- 4: mainHandEnchantID (number) <-- 这是附魔ID！
    -- 5-8: 副手同样的参数
    local mh_enchanted, mh_expires, mh_charges, mh_enchant_id, oh_enchanted, oh_expires, oh_charges, oh_enchant_id = GetWeaponEnchantInfo()

    if mh_enchanted then
        _mainhand_imbued = true

        -- 用附魔 ID (第4个参数) 查找附魔类型
        local mh_type = enchant_ids[ mh_enchant_id ]

        if mh_type == "windfury" then _windfury_mainhand = true
        elseif mh_type == "flametongue" then _flametongue_mainhand = true
        elseif mh_type == "frostbrand" then _frostbrand_mainhand = true
        elseif mh_type == "rockbiter" then _rockbiter_mainhand = true end
    end

    if oh_enchanted then
        _offhand_imbued = true

        -- 用附魔 ID (第8个参数) 查找附魔类型
        local oh_type = enchant_ids[ oh_enchant_id ]

        if oh_type == "windfury" then _windfury_offhand = true
        elseif oh_type == "flametongue" then _flametongue_offhand = true
        elseif oh_type == "frostbrand" then _frostbrand_offhand = true
        elseif oh_type == "rockbiter" then _rockbiter_offhand = true end
    end

    last_consumed_stack_ts = LastConsumedStackTS
end )


Hekili:RegisterGearHook( reset_gear, update_gear )

-- Abilities
spec:RegisterAbilities( {
    -- Returns the spirit to the body, restoring a dead target to life with 1800 health and 1365 mana.  Cannot be cast when in combat.
    ancestral_spirit = {
        id = 2008,
        cast = 10,
        cooldown = 0,
        gcd = "spell",

        spend = 0.72,
        spendType = "mana",

        startsCombat = false,
        texture = 136077,

        handler = function ()
            -- 复活目标，无需状态变化
        end,

        copy = { 20609, 20610, 20776, 20777, 25590, 49277 },
    },


    -- Yanks the caster through the twisting nether back to Dalaran.  Speak to an Innkeeper in a different place to change your home location.
    astral_recall = {
        id = 556,
        cast = 10,
        cooldown = function() return glyph.astral_recall.enabled and 450 or 900 end,
        gcd = "spell",

        spend = 0.05,
        spendType = "mana",

        startsCombat = false,
        texture = 136010,

        toggle = "cooldowns",

        handler = function ()
            -- 传送回炉石位置，无需状态变化
        end,
    },


    -- Increases melee, ranged, and spell casting speed by 30% for all party and raid members.  Lasts 40 sec.    After the completion of this effect, those affected will become Sated and unable to benefit from Bloodlust again for 10 min.
    bloodlust = {
        id = 2825,
        cast = 0,
        cooldown = 300,
        gcd = "spell",

        spend = 0.26,
        spendType = "mana",

        startsCombat = false,
        texture = 136012,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "bloodlust" )
            applyDebuff( "player", "sated" )
        end,

        -- copy = { "heroism", 32182 }
    },

    -- (实验)新增联盟技能"英勇"by风雪20250507
    heroism = {
        id = 32182,
        cast = 0,
        cooldown = 300,
        gcd = "spell",

        spend = 0.26,
        spendType = "mana",

        startsCombat = false,
        texture = 132313,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "heroism" )
            applyDebuff( "player", "sated" )
        end,
    },
    -- 新增结束 
 
    -- Simultaneously places up to 4 totems specified in the Totem Bar. Can call different totems than Call of the Elements.
    call_of_the_ancestors = {
        id = 66843,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        startsCombat = false,
        texture = 310731,

        handler = function ()
            -- 使用 APIWrapper 获取法术信息
            local APIWrapper = ns.APIWrapper or (Hekili and Hekili.APIWrapper)
            for i = 138, 141 do
                local _, totemSpell = GetActionInfo( i )
                local spellName = nil
                if totemSpell then
                    if APIWrapper and APIWrapper.GetSpellInfo then
                        local spellInfo = APIWrapper.GetSpellInfo( totemSpell )
                        spellName = spellInfo and spellInfo.name
                    elseif GetSpellInfo then
                        spellName = GetSpellInfo( totemSpell )
                    end
                end
                local ability = spellName and class.abilities[ spellName ]
                if ability then
                    ability.handler()
                end
            end
        end,
    },


    -- Simultaneously places up to 4 totems specified in the Totem Bar.
    call_of_the_elements = {
        id = 66842,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        startsCombat = false,
        texture = 310730,

        handler = function ()
            -- 使用 APIWrapper 获取法术信息
            local APIWrapper = ns.APIWrapper or (Hekili and Hekili.APIWrapper)
            for i = 134, 137 do
                local _, totemSpell = GetActionInfo( i )
                local spellName = nil
                if totemSpell then
                    if APIWrapper and APIWrapper.GetSpellInfo then
                        local spellInfo = APIWrapper.GetSpellInfo( totemSpell )
                        spellName = spellInfo and spellInfo.name
                    elseif GetSpellInfo then
                        spellName = GetSpellInfo( totemSpell )
                    end
                end
                local ability = spellName and class.abilities[ spellName ]
                if ability then
                    ability.handler()
                end
            end
        end,
    },


    -- Simultaneously places up to 4 totems specified in the Totem Bar. Can call different totems than Call of the Elements or Call of the Ancestors.
    call_of_the_spirits = {
        id = 66844,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        startsCombat = false,
        texture = 310732,

        handler = function ()
            -- 使用 APIWrapper 获取法术信息
            local APIWrapper = ns.APIWrapper or (Hekili and Hekili.APIWrapper)
            for i = 142, 145 do
                local _, totemSpell = GetActionInfo( i )
                local spellName = nil
                if totemSpell then
                    if APIWrapper and APIWrapper.GetSpellInfo then
                        local spellInfo = APIWrapper.GetSpellInfo( totemSpell )
                        spellName = spellInfo and spellInfo.name
                    elseif GetSpellInfo then
                        spellName = GetSpellInfo( totemSpell )
                    end
                end
                local ability = spellName and class.abilities[ spellName ]
                if ability then
                    ability.handler()
                end
            end
        end,
    },


    -- Heals the friendly target for 1055 to 1205, then jumps to heal additional nearby targets.  If cast on a party member, the heal will only jump to other party members.  Each jump reduces the effectiveness of the heal by 40%.  Heals 3 total targets.
    chain_heal = {
        id = 1064,
        cast = 2.5,
        cooldown = 0,
        gcd = "spell",

        spend = 0.19,
        spendType = "mana",

        startsCombat = false,
        texture = 136042,

        handler = function ()
            removeBuff( "riptide" )
        end,

        copy = { 10622, 10623, 25422, 25423, 55458, 55459 },
    },


    -- 闪电链Hurls a lightning bolt at the enemy, dealing 982 to 1123 Nature damage and then jumping to additional nearby enemies.  Each jump reduces the damage by 30%.  Affects 3 total targets.
    chain_lightning = {
        id = 421,
        cast = function ()
            if buff.elemental_mastery.up then return 0 end
            return (2 - (talent.lightning_mastery.rank * 0.1)) * (1 - (buff.maelstrom_weapon.stack * 2) / 10) * haste
        end,
        cooldown = function () 
            return 6 - (talent.storm_earth_and_fire.rank == 1 and 0.75 or talent.storm_earth_and_fire.rank == 2 and 1.5 or 2.5) --修复by风雪 20250808
        end,

        gcd = "spell",

        spend = function ()
            return ( buff.clearcasting.up and 0.6 or 1 ) * 0.26
        end,
        spendType = "mana",

        startsCombat = true,
        texture = 136015,

        handler = function ()
            removeBuff( "elemental_mastery" )
            removeBuff( "maelstrom_weapon" )
            removeStack( "clearcasting" )
            removeDebuffStack( "target", "stormstrike" )
        end,

        copy = { 930, 2860, 10605, 25439, 25442, 49270, 49271 },
    },

    -- Cleanse the spirit of a friendly target, removing 1 poison effect, 1 disease effect, and 1 curse effect.
    cleanse_spirit = {
        id = 51886,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.07,
        spendType = "mana",

        talent = "cleanse_spirit",
        startsCombat = false,
        texture = 236288,

        buff = "can_cleanse_spirit",

        handler = function ()
            removeBuff( "can_cleanse_spirit" )
        end,
    },


    -- Summons a Cleansing Totem with 5 health at the feet of the caster that attempts to remove 1 disease and 1 poison effect from party members within 30 yards every 3 seconds.  Lasts 5 min.
    cleansing_totem = {
        id = 8170,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.08,
        spendType = "mana",

        startsCombat = false,
        texture = 136019,

        totem = "water",

        handler = function ()
            removeBuff( "water_totem" )
            summonTotem( "cleansing_totem" )
            applyBuff( "cleansing_totem" )
        end,
    },

    -- Cures 1 poison effect and 1 disease effect on a friendly target.
    cure_toxins = {
        id = 526,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.07,
        spendType = "mana",

        startsCombat = false,
        texture = 136067,

        buff = "can_cleanse_toxins",

        handler = function ()
            removeBuff( "can_cleanse_toxins" )
        end,
    },


    -- Summon an elemental totem that calls forth a greater earth elemental to protect the caster and his allies.  Lasts 2 min.
    earth_elemental_totem = {
        id = 2062,
        cast = 0,
        cooldown = 600,
        gcd = "spell",

        spend = 0.24,
        spendType = "mana",

        startsCombat = false,
        texture = 136024,

        toggle = "cooldowns",

        totem = "earth",

        handler = function ()
            removeBuff( "earth_totem" )
            summonTotem( "earth_elemental_totem" )
            applyBuff( "earth_elemental_totem" )
        end,
    },


    -- Protects the target with an earthen shield, reducing casting or channeling time lost when damaged by 30%  and causing attacks to heal the shielded target for 150.  This effect can only occur once every few seconds.  6 charges.  Lasts 10 min.  Earth Shield can only be placed on one target at a time and only one Elemental Shield can be active on a target at a time.
    earth_shield = {
        id = 974,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.15,
        spendType = "mana",

        talent = "earth_shield",
        startsCombat = false,
        texture = 136089,

        handler = function ()
            removeBuff( "shield" )
            applyBuff( "earth_shield" )
        end,
    },


    -- Instantly shocks the target with concussive force, causing 862 to 909 Nature damage and reducing melee attack speed by 10% for 8 sec.
    earth_shock = {
        id = 8042,
        cast = 0,
        cooldown = 6,
        gcd = function() return glyph.shocking.enabled and "totem" or "spell" end,

        spend = function ()
            return ( buff.clearcasting.up and 0.6 or 1 ) * 0.18
        end,

        spendType = "mana",

        startsCombat = true,
        texture = 136026,

        handler = function ()
            applyDebuff( "target", "earth_shock" )
            setCooldown( "flame_shock", 6 )
            setCooldown( "frost_shock", 6 )
            removeDebuffStack( "target", "stormstrike" )
        end,

        copy = { 8044, 8045, 8046, 10412, 10413, 10414, 25454, 49230, 49231 },
    },


    -- Summons an Earthbind Totem with 5 health at the feet of the caster for 45 sec that slows the movement speed of enemies within 10 yards.
    earthbind_totem = {
        id = 2484,
        cast = 0,
        cooldown = 15,
        gcd = "spell",

        spend = 0.05,
        spendType = "mana",

        startsCombat = false,
        texture = 136102,

        totem = "earth",

        handler = function ()
            removeBuff( "earth_totem" )
            summonTotem( "earthbind_totem" )
            applyBuff( "earthbind_totem" )
        end,
    },


    -- Imbue the Shaman's weapon with earthen life. Increases healing done by 150 and each heal has a 20% chance to proc Earthliving on the target, healing an additional 652 over 12 sec. Lasts 30 minutes.
    earthliving_weapon = {
        id = 51730,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.06,
        spendType = "mana",

        startsCombat = false,
        texture = 237575,

        usable = function() return ( equipped.mainhand and not mainhand_imbued ) or ( equipped.offhand and not offhand_imbued ), "must have an unimbued weapon" end,

        handler = function ()
            if equipped.mainhand and not mainhand_imbued then
                mainhand_imbued = true
                earthliving_mainhand = true
            elseif equipped.offhand and not offhand_imbued then
                offhand_imbued = true
                earthliving_offhand = true
            end
        end,

        copy = { 51988, 51991, 51992, 51993, 51994 },
    },


    -- When activated, your next Lightning Bolt, Chain Lightning or Lava Burst spell becomes an instant cast spell. In addition, you gain 15% spell haste for 15 sec. Elemental Mastery shares a cooldown with Nature's Swiftness.
    elemental_mastery = {
        id = 16166,
        cast = 0,
        cooldown = function() return glyph.elemental_mastery.enabled and 150 or 180 end,
        gcd = "spell",

        talent = "elemental_mastery",
        startsCombat = false,
        texture = 136115,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "elemental_mastery" )
            applyBuff( "elemental_mastery_haste" )
            haste = haste + 0.15
        end,
    },


    -- Changes the caster's viewpoint to the targeted location.  Lasts 1 min.  Only useable outdoors.
    far_sight = {
        id = 6196,
        cast = 2,
        cooldown = 0,
        gcd = "spell",

        spend = 0.03,
        spendType = "mana",

        startsCombat = false,
        texture = 136034,

        handler = function ()
            applyBuff( "far_sight" )
        end,
    },


    -- Summons two Spirit Wolves under the command of the Shaman, lasting 45 sec.
    feral_spirit = {
        id = 51533,
        cast = 0,
        cooldown = 180,
        gcd = "spell",

        spend = 0.12,
        spendType = "mana",

        talent = "feral_spirit",
        startsCombat = false,
        texture = 237577,

        toggle = "cooldowns",

        handler = function ()
            summonPet( "spirit_wolf" )
        end,
    },


    -- Summons an elemental totem that calls forth a greater fire elemental to rain destruction on the caster's enemies.  Lasts 2 min.
    fire_elemental_totem = {
        id = 2894,
        cast = 0,
        cooldown = function() return glyph.fire_elemental_totem.enabled and 300 or 600 end,
        gcd = "totem",

        spend = 0.23,
        spendType = "mana",

        startsCombat = true,
        texture = 135790,

        toggle = "cooldowns",

        totem = "fire",

        handler = function ()
            removeBuff( "fire_totem" )
            summonTotem( "fire_elemental_totem" )
            applyBuff( "fire_elemental_totem" )
        end,
    },


    -- 火焰新星Causes the shaman's active Fire totem to emit a wave of flames, inflicting 893 to 997 Fire damage to enemies within 10 yards of the totem.
    fire_nova = {
        id = 1535,
        cast = 0,
        cooldown = function()
            return (glyph.fire_nova.enabled and 7 or 10) - talent.improved_fire_nova.rank * 2
        end,
        gcd = "spell",

        spend = 0.22,
        spendType = "mana",

        startsCombat = true,
        texture = 135824,

        buff = "fire_totem",

        handler = function ()
            -- 火焰新星造成AOE伤害，无需额外状态变化
        end,

        copy = { 8498, 8499, 11314, 11315, 25546, 25547, 61649, 61657 },
    },


    -- Summons a Fire Resistance Totem with 5 health at the feet of the caster for 5 min that increases the fire resistance of party and raid members within 30 yards by 130.
    fire_resistance_totem = {
        id = 8184,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 0.08,
        spendType = "mana",

        startsCombat = false,
        texture = 135832,

        totem = "water",

        handler = function ()
            removeBuff( "water_totem" )
            summonTotem( "fire_resistance_totem" )
            applyBuff( "fire_resistance_totem" )
        end,

        copy = { 10537, 10538, 25563, 58737, 58739 },
    },


    -- 烈焰震击Instantly sears the target with fire, causing 505 Fire damage immediately and 842 Fire damage over 16.45 sec. This periodic damage may critically strike and will occur more rapidly based on the caster's spell haste.
    flame_shock = {
        id = 8050,
        cast = 0,
        cooldown = function () return 6 - talent.booming_echoes.rank * 1 end, --修复by风雪 20250808
        gcd = function() return glyph.shocking.enabled and "totem" or "spell" end,

        spend = function ()
            return ( buff.clearcasting.up and 0.6 or 1 ) * 0.17
        end,
        spendType = "mana",

        startsCombat = true,
        texture = 135813,

        handler = function ()
            applyDebuff( "target", "flame_shock" )
            setCooldown( "frost_shock", 6 )
            setCooldown( "earth_shock", 6 )
        end,

        copy = { 8052, 8053, 10447, 10448, 29228, 25457, 49232, 49233 },
    },


    -- Summons a Flametongue Totem with 5 health at the feet of the caster.  Party and raid members within 30 yards of the totem have their spell damage and healing increased by up to 144.  Lasts 5 min.
    flametongue_totem = {
        id = 58656,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 0.11,
        spendType = "mana",

        startsCombat = false,
        texture = 136040,

        totem = "fire",

        handler = function ()
            removeBuff( "fire_totem" )
            summonTotem( "flametongue_totem" )
            applyBuff( "flametongue_totem" )
        end,

        copy = { 8249, 10526, 16387, 25557, 58649, 58652, 58656 },
    },


    -- Imbue the Shaman's weapon with fire, increasing total spell damage by 211. Each hit causes 89.0 to 274 additional Fire damage, based on the speed of the weapon.  Slower weapons cause more fire damage per swing.  Lasts 30 minutes.
    -- 火舌武器：必须学习了该技能才显示 by 哑吡 20251225
    flametongue_weapon = {
        id = 8024,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        max_rank = 10,

        spend = 0.06,
        spendType = "mana",

        startsCombat = false,
        texture = 135814,

        -- 必须学习了该技能才显示
        known = function() return IsSpellKnown(8024) or IsSpellKnown(8027) or IsSpellKnown(8030) or IsSpellKnown(16339) or IsSpellKnown(16341) or IsSpellKnown(16342) or IsSpellKnown(25489) or IsSpellKnown(58785) or IsSpellKnown(58789) or IsSpellKnown(58790) end,

        usable = function()
            -- 如果主手已经是火舌，不需要再上
            if flametongue_mainhand then
                return false, "already have flametongue"
            end
            -- 主手没有火舌，可以上（包括切换场景）
            return true, "need flametongue"
        end,

        handler = function ()
            -- 清除其他附魔状态，设置火舌
            _windfury_mainhand = false
            _frostbrand_mainhand = false
            _rockbiter_mainhand = false
            _flametongue_mainhand = true
            _mainhand_imbued = true
        end,

        copy = { 8027, 8030, 16339, 16341, 16342, 25489, 58785, 58789, 58790 },
    },


    -- Summons a Frost Resistance Totem with 5 health at the feet of the caster for 5 min.  The totem increases party and raid members' frost resistance by 130, if within 30 yards.
    frost_resistance_totem = {
        id = 8181,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 0.08,
        spendType = "mana",

        startsCombat = false,
        texture = 135866,

        totem = "fire",

        handler = function ()
            removeBuff( "fire_totem" )
            summonTotem( "frost_resistance_totem" )
            applyBuff( "frost_resistance_totem" )
        end,

        copy = { 10478, 10479, 25560, 58741, 58745 },
    },


    -- 冰霜震击Instantly shocks the target with frost, causing 820 to 867 Frost damage and slowing movement speed by 50%.  Lasts 8 sec.  Causes a high amount of threat.
    frost_shock = {
        id = 8056,
        cast = 0,
        cooldown = function () return 6 - talent.booming_echoes.rank * 1 end, --修复by风雪 20250808
        gcd = function() return glyph.shocking.enabled and "totem" or "spell" end,

        spend = function ()
            return ( buff.clearcasting.up and 0.6 or 1 ) * 0.18
        end,
        spendType = "mana",

        startsCombat = true,
        texture = 135849,

        handler = function ()
            applyDebuff( "target", "frost_shock" )
            setCooldown( "flame_shock", 6 )
            setCooldown( "earth_shock", 6 )
        end,

        copy = { 8058, 10472, 10473, 25464, 49235, 49236 },
    },


    -- Imbue the Shaman's weapon with frost.  Each hit has a chance of causing 530 additional Frost damage and slowing the target's movement speed by 50% for 8 sec.  Lasts 30 minutes.
    -- 冰封武器：必须学习了该技能才显示 by 哑吡 20251225
    frostbrand_weapon = {
        id = 8033,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.06,
        spendType = "mana",

        startsCombat = false,
        texture = 135847,

        -- 必须学习了该技能才显示
        known = function() return IsSpellKnown(8033) or IsSpellKnown(8038) or IsSpellKnown(10456) or IsSpellKnown(16355) or IsSpellKnown(16356) or IsSpellKnown(25500) or IsSpellKnown(58794) or IsSpellKnown(58795) or IsSpellKnown(58796) end,

        usable = function() return ( equipped.mainhand and not mainhand_imbued ) or ( equipped.offhand and not offhand_imbued ), "must have an unimbued weapon" end,

        handler = function( rank )
            if equipped.mainhand and not mainhand_imbued then
                mainhand_imbued = true
                frostbrand_mainhand = true
            elseif equipped.offhand and not offhand_imbued then
                offhand_imbued = true
                frostbrand_offhand = true
            end
        end,

        copy = { 8038, 10456, 16355, 16356, 25500, 58794, 58795, 58796 },
    },


    -- Turns the Shaman into a Ghost Wolf, increasing speed by 40%. As a Ghost Wolf, the Shaman is less hindered by effects that would reduce movement speed. Only useable outdoors.
    ghost_wolf = {
        id = 2645,
        cast = 2,
        cooldown = 0,
        gcd = "spell",

        spend = 0.06,
        spendType = "mana",

        startsCombat = false,
        texture = 136095,

        handler = function ()
            applyBuff( "ghost_wolf" )
        end,
    },


    -- Summons a Grounding Totem with 5 health at the feet of the caster that will redirect one harmful spell cast on a nearby party member to itself, destroying the totem.  Will not redirect area of effect spells.  Lasts 45 sec.
    grounding_totem = {
        id = 8177,
        cast = 0,
        cooldown = 15,
        gcd = "spell",

        spend = 0.05,
        spendType = "mana",

        startsCombat = false,
        texture = 136039,

        totem = "air",

        handler = function ()
            removeBuff( "air_totem" )
            summonTotem( "grounding_totem" )
            applyBuff( "grounding_totem" )
        end,
    },


    -- Summons a Healing Stream Totem with 5 health at the feet of the caster for 5 min that heals group members within 30 yards for 25 every 2 seconds.
    healing_stream_totem = {
        id = 5394,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.03,
        spendType = "mana",

        startsCombat = false,
        texture = 135127,

        totem = "water",

        handler = function( rank )
            removeBuff( "water_totem" )
            summonTotem( "healing_stream_totem" )
            applyBuff( "healing_stream_totem" )
        end,

        copy = { 6375, 6377, 10462, 10463, 25567, 58755, 58756, 58757 },
    },


    -- Heals a friendly target for 3034 to 3466.
    healing_wave = {
        id = 331,
        cast = function()
            if buff.natures_swiftness.up then return 0 end
            return 3 * haste
        end,
        cooldown = 0,
        gcd = "spell",

        spend = 0.25,
        spendType = "mana",

        startsCombat = false,
        texture = 136052,

        handler = function ()
            removeBuff( "natures_swiftness" )
        end,

        copy = { 332, 547, 913, 939, 959, 8005, 10395, 10396, 25357, 25391, 25396, 49272, 49273 },
    },


    -- Transforms the enemy into a frog. While hexed, the target cannot attack or cast spells. Damage caused may interrupt the effect. Lasts 30 sec. Only one target can be hexed at a time.  Only works on Humanoids and Beasts.
    hex = {
        id = 51514,
        cast = 1.5,
        cooldown = 45,
        gcd = "spell",

        spend = 0.03,
        spendType = "mana",

        startsCombat = true,
        texture = 237579,

        handler = function ()
            applyDebuff( "target", "hex" )
        end,
    },


    -- 熔岩爆裂You hurl molten lava at the target, dealing 1203 to 1534 Fire damage. If your Flame Shock is on the target, Lava Burst will deal a critical strike.
    lava_burst = {
        id = 51505,
        cast = function ()
            if buff.elemental_mastery.up then return 0 end
            return (2 - talent.lightning_mastery.rank * 0.1) * haste  --修复施法时间by 风雪 20250808
        end,
        cooldown = 8,
        gcd = "spell",

        spend = 0.1,
        spendType = "mana",

		velocity = 20, --新增技能飞行速度，修改by风雪 20250808

        startsCombat = true,
        texture = 237582,

        handler = function ()
            removeBuff( "elemental_mastery" )
        end,

        copy = { 60043 },
    },


    -- You charge your off-hand weapon with lava, instantly dealing 100% off-hand Weapon damage. Damage is increased by 25% if your off-hand weapon is enchanted with Flametongue.
    -- 熔岩猛击（双持）
    lava_lash = {
        id = 60103,
        cast = 0,
        cooldown = 6,
        gcd = "spell",

        spend = 0.04,
        spendType = "mana",

        talent = "lava_lash",
        startsCombat = true,
        texture = 236289,

        usable = function()
            return equipped.offhand, "需要双持武器"
        end,

        handler = function ()
            -- 熔岩猛击，副手武器攻击
        end,
    },

    -- 熔岩强击（双手武器，双手灵巧天赋）
    lava_strike = {
        id = 1272856,
        cast = 0,
        cooldown = 6,
        gcd = "spell",

        spend = 0.04,
        spendType = "mana",

        talent = "dual_wield",
        startsCombat = true,
        texture = 236289,

        usable = function()
            return not equipped.offhand, "需要双手武器"
        end,

        handler = function ()
            -- 熔岩强击，双手武器攻击
        end,
    },


    -- Heals a friendly target for 1624 to 1852.
    lesser_healing_wave = {
        id = 8004,
        cast = function ()
            if buff.natures_swiftness.up then return 0 end
            return 1.5 * haste
        end,
        cooldown = 0,
        gcd = "spell",

        spend = 0.15,
        spendType = "mana",

        startsCombat = false,
        texture = 136043,

        handler = function ()
            removeBuff( "natures_swiftness" )
        end,

        { 8008, 8010, 10466, 10467, 10468, 25420, 49275, 49276 },
    },


    -- 闪电箭Casts a bolt of lightning at the target for 726 to 828 Nature damage.
    lightning_bolt = {
        id = 403,
        cast = function ()
            if buff.elemental_mastery.up or buff.natures_swiftness.up then return 0 end
            return (2.5 - talent.lightning_mastery.rank * 0.1) * (1 - (buff.maelstrom_weapon.stack * 2) / 10) * haste
        end,
        cooldown = 0,
        gcd = "spell",

        spend = function ()
            return 0.1 * ( buff.clearcasting.up and 0.6 or 1 )
        end,
        spendType = "mana",

        startsCombat = true,
        texture = 136048,

        handler = function ()
            removeStack( "clearcasting" )
            removeBuff( "natures_swiftness" )
            removeBuff( "elemental_mastery" )
            removeBuff( "maelstrom_weapon" )
            removeDebuffStack( "target", "stormstrike" )
        end,

        copy = { 529, 548, 915, 943, 6041, 10391, 10392, 15207, 15208, 25448, 25449, 49237, 49238 },
    },


    -- The caster is surrounded by 3 balls of lightning.  When a spell, melee or ranged attack hits the caster, the attacker will be struck for 380 Nature damage.  This expends one lightning ball.  Only one ball will fire every few seconds.  Lasts 10 min.  Only one Elemental Shield can be active on the Shaman at any one time.
    lightning_shield = {
        id = 324,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        startsCombat = false,
        texture = 136051,

        handler = function ()
            removeBuff( "shield" )
            applyBuff( "lightning_shield", nil, buff.lightning_shield.max_stack )
        end,

        copy = { 325, 905, 945, 8134, 10431, 10432, 25469, 25472, 49280, 49281 },
    },


    -- Summons a Magma Totem with 5 health at the feet of the caster for 20 sec that causes 371 Fire damage to creatures within 8 yards every 2 seconds.
    magma_totem = {
        id = 8190,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.27,
        spendType = "mana",

        startsCombat = true,
        texture = 135826,

        totem = "fire",

        handler = function ()
            removeBuff( "fire_totem" )
            summonTotem( "magma_totem" )
            applyBuff( "magma_totem" )
        end,

        copy = { 10585, 10586, 10587, 25552, 58731, 58734 },
    },


    -- Summons a Mana Spring Totem with 5 health at the feet of the caster for 5 min that restores 91 mana every 5 seconds to all party and raid members within 30 yards.
    mana_spring_totem = {
        id = 5675,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.04,
        spendType = "mana",

        startsCombat = false,
        texture = 136053,

        totem = "water",

        handler = function ()
            removeBuff( "water_totem" )
            summonTotem( "mana_spring_totem" )
            applyBuff( "mana_spring_totem" )
        end,

        copy = { 10495, 10496, 10497, 25570, 58771, 58773, 58774 },
    },


    -- Summons a Mana Tide Totem with 10% of the caster's health at the feet of the caster for 12 sec that restores 6% of total mana every 3 seconds to group members within 30 yards.
    mana_tide_totem = {
        id = 16190,
        cast = 0,
        cooldown = 300,
        gcd = "spell",

        talent = "mana_tide_totem",
        startsCombat = false,
        texture = 135861,

        toggle = "cooldowns",

        totem = "water",

        handler = function ()
            removeBuff( "water_totem" )
            summonTotem( "mana_tide_totem" )
            applyBuff( "mana_tide_totem" )
        end,
    },


    -- Summons a Nature Resistance Totem with 5 health at the feet of the caster for 5 min that increases the nature resistance of party and raid members within 30 yards by 130.
    nature_resistance_totem = {
        id = 10595,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.08,
        spendType = "mana",

        startsCombat = true,
        texture = 136061,

        totem = "air",

        handler = function ()
            removeBuff( "air_totem" )
            summonTotem( "nature_resistance_totem" )
            applyBuff( "nature_resistance_totem" )
        end,

        copy = { 10600, 10601, 25574, 58746, 58749 },
    },


    -- When activated, your next Nature spell with a base casting time less than 10 sec. becomes an instant cast spell. Nature's Swiftness shares a cooldown with Elemental Mastery.
    natures_swiftness = {
        id = 16188,
        cast = 0,
        cooldown = 120,
        gcd = "off",

        talent = "natures_swiftness",
        startsCombat = false,
        texture = 136076,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "natures_swiftness" )
            setCooldown( "elemental_mastery", 120 )
        end,
    },


    -- Purges the enemy target, removing 2 beneficial magic effects.
    purge = {
        id = 370,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.08,
        spendType = "mana",

        startsCombat = true,
        texture = 136075,

        debuff = "dispellable_magic",

        handler = function ()
            removeDebuff( "target", "dispellable_magic" )
        end,

        copy = { 8012 },
    },


    -- Heals a friendly target for 639 to 691 and another 665 over 15 sec.  Your next Chain Heal cast on that primary target within 15 sec will consume the healing over time effect and increase the amount of the Chain Heal by 25%.
    riptide = {
        id = 61295,
        cast = 0,
        cooldown = 6,
        gcd = "spell",

        spend = 0.18,
        spendType = "mana",

        talent = "riptide",
        startsCombat = false,
        texture = 252995,

        handler = function ()
            applyBuff( "riptide" )
        end,
    },


    -- Imbue the Shaman's weapon, increasing its damage per second by 9.  Lasts 30 minutes.
    -- 石化武器：必须学习了该技能才显示 by 哑吡 20251225
    rockbiter_weapon = {
        id = 8017,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.08,
        spendType = "mana",

        startsCombat = false,
        texture = 136086,

        -- 必须学习了该技能才显示
        known = function() return IsSpellKnown(8017) or IsSpellKnown(8018) or IsSpellKnown(8019) or IsSpellKnown(10399) end,

        usable = function() return ( equipped.mainhand and not mainhand_imbued ) or ( equipped.offhand and not offhand_imbued ), "must have an unimbued weapon" end,

        handler = function ()
            if equipped.mainhand and not mainhand_imbued then
                mainhand_imbued = true
                rockbiter_mainhand = true
            elseif equipped.offhand and not offhand_imbued then
                offhand_imbued = true
                rockbiter_offhand = true
            end
        end,

        copy = { 8018, 8019, 10399 },
    },


    -- Summons a Searing Totem with 5 health at your feet for 1 min that repeatedly attacks an enemy within 201 yards for 90 to 120 Fire damage.
    searing_totem = {
        id = 3599,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 0.07,
        spendType = "mana",

        startsCombat = false,
        texture = 135825,

        totem = "fire",

        handler = function ()
            removeBuff( "fire_totem" )
            summonTotem( "searing_totem" )
            applyBuff( "searing_totem" )
        end,

        copy = { 6363, 6364, 6365, 10437, 10438, 25533, 58699, 58703, 58704 },
    },


    -- Summons an immobile Sentry Totem with 100 health at your feet for 5 min that allows vision of nearby area and warns of enemies that attack it.  Right-Click on buff to switch back and forth between totem sight and shaman sight.
    sentry_totem = {
        id = 6495,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 0.02,
        spendType = "mana",

        startsCombat = false,
        texture = 136082,

        totem = "air",

        handler = function ()
            removeBuff( "air_totem" )
            applyBuff( "sentry_totem" )
        end,

        copy = { 6363, 6364, 6365, 10437, 10438, 25533 },
    },


    -- Reduces all damage taken by 30% and gives your successful melee attacks a chance to regenerate mana equal to 15% of your attack power. This spell is usable while stunned. Lasts 15 sec.
    shamanistic_rage = {
        id = 30823,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        talent = "shamanistic_rage",
        startsCombat = false,
        texture = 136088,

        -- Shamanistic Rage is on Defensives toggle unless mana is below the threshold and not wearing Tier10
        toggle = function ()
            if mana.percent > settings.shaman_rage_threshold and not set_bonus.tier10enhancement_2pc == 1 then return "defensives" end
        end,

        handler = function ()
            applyBuff( "shamanistic_rage" )
        end,
    },


    -- Summons a Stoneclaw Totem with 1632  health at the feet of the caster for 15 sec that taunts creatures within 8 yards to attack it.  Enemies attacking the Stoneclaw Totem have a 50% chance to be stunned for 3 sec. Stoneclaw totem also protects all your totems, causing them to absorb 1085 damage.
    stoneclaw_totem = {
        id = 5730,
        cast = 0,
        cooldown = 30,
        gcd = "totem",

        spend = 0.06,
        spendType = "mana",

        startsCombat = true,
        texture = 136097,

        totem = "earth",

        handler = function ()
            removeBuff( "earth_totem" )
            summonTotem( "stoneclaw_totem" )
            applyBuff( "stoneclaw_totem" )
        end,

        copy = { 6390, 6391, 6392, 10427, 10428, 25525, 58580, 58581, 58582 },
    },


    -- Summons a Stoneskin Totem with 5 health at the feet of the caster.  The totem protects party and raid members within 30 yards, increasing armor by 1150.  Lasts 5 min.
    stoneskin_totem = {
        id = 8071,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 0.1,
        spendType = "mana",

        startsCombat = false,
        texture = 136098,

        totem = "earth",

        handler = function ()
            removeBuff( "earth_totem" )
            summonTotem( "stoneskin_totem" )
            applyBuff( "stoneskin_totem" )
        end,

        copy = { 8154, 8155, 10406, 10407, 10408, 25508, 25509, 58751, 58753 },
    },


    -- Instantly attack with both weapons.  In addition, the next 4 sources of Nature damage dealt to the target from the Shaman are increased by 20%. Lasts 12 sec.
    stormstrike = {
        id = 17364,
        cast = 0,
        cooldown = 8,
        gcd = "spell",

        spend = 0.08,
        spendType = "mana",

        talent = "stormstrike",
        startsCombat = true,
        texture = 132314,

        handler = function ()
            applyDebuff( "target", "stormstrike", nil, 4 )
        end,
    },


    -- Summons a Strength of Earth Totem with 5 health at the feet of the caster.  The totem increases the strength and agility of all party and raid members within 30 yards by 155.  Lasts 5 min.
    strength_of_earth_totem = {
        id = 8075,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 0.1,
        spendType = "mana",

        startsCombat = true,
        texture = 136023,

        totem = "earth",

        handler = function ()
            removeBuff( "earth_totem" )
            summonTotem( "strength_of_earth_totem" )
            applyBuff( "strength_of_earth_totem" )
        end,

        copy = { 8160, 8161, 10442, 25361, 25528, 57622, 58643 },
    },


    -- You call down a bolt of lightning, energizing you and damaging nearby enemies within 10 yards. Restores 8% mana to you and deals 571 to 651 Nature damage to all nearby enemies, knocking them back 20 yards. This spell is usable while stunned.
    thunderstorm = {
        id = 51490,
        cast = 0,
        cooldown = function() return glyph.thunder.enabled and 35 or 45 end,
        gcd = "spell",

        talent = "thunderstorm",
        startsCombat = true,
        texture = 237589,

        handler = function ()
            gain( 0.08 * mana.max, "mana" )
        end,
    },


    -- Increases the critical effect chance of your Healing Wave, Lesser Healing Wave and Chain Heal by 60%. Each critical heal reduces the chance by 20%. Lasts 20 sec.
    tidal_force = {
        id = 55198,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        talent = "tidal_force",
        startsCombat = false,
        texture = 135845,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "tidal_force" )
        end,
    },


    -- Summons a Totem of Wrath with 5 health at the feet of the caster.  The totem increases spell power by 100 for all party and raid members, and increases the critical strike chance of all attacks by 3% against all enemies within 40 yards.  Lasts 5 min.
    totem_of_wrath = {
        id = 30706,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 0.05,
        spendType = "mana",

        talent = "totem_of_wrath",
        startsCombat = false,
        texture = 135829,

        totem = "fire",

        handler = function ()
            removeBuff( "fire_totem" )
            summonTotem( "totem_of_wrath" )
            applyBuff( "totem_of_wrath" )
        end,
    },


    -- Returns your totems to the earth, giving you 25% of the mana required to cast each totem destroyed by Totemic Recall.
    totemic_recall = {
        id = 36936,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        startsCombat = false,
        texture = 310733,

        handler = function ()
            if buff.earth_totem.up then
                gain( 0.25 * action[ buff.earth_totem.actual ].cost, "mana" )
                removeBuff( "earth_totem" )
            end
            if buff.fire_totem.up then
                gain( 0.25 * action[ buff.fire_totem.actual ].cost, "mana" )
                removeBuff( "fire_totem" )
            end
            if buff.water_totem.up then
                gain( 0.25 * action[ buff.water_totem.actual ].cost, "mana" )
                removeBuff( "water_totem" )
            end
            if buff.air_totem.up then
                gain( 0.25 * action[ buff.air_totem.actual ].cost, "mana" )
                removeBuff( "air_totem" )
            end
        end,
    },


    -- Summons a Tremor Totem with 5 health at the feet of the caster that shakes the ground around it, removing Fear, Charm and Sleep effects from party members within 30 yards.  Lasts 5 min.
    tremor_totem = {
        id = 8143,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 0.02,
        spendType = "mana",

        startsCombat = false,
        texture = 136108,

        totem = "earth",

        handler = function ()
            removeBuff( "earth_totem" )
            summonTotem( "tremor_totem" )
            applyBuff( "tremor_totem" )
        end,
    },


    -- Allows the target to breathe underwater for 10 min.
    water_breathing = {
        id = 131,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.02,
        spendType = "mana",

        startsCombat = false,
        texture = 136148,

        handler = function ()
            applyBuff( "water_breathing" )
        end,
    },


    -- The caster is surrounded by 3 globes of water, granting 100 mana per 5 sec.  When a spell, melee or ranged attack hits the caster, 428 mana is restored to the caster. This expends one water globe.  Only one globe will activate every few seconds.  Lasts 10 min.  Only one Elemental Shield can be active on the Shaman at any one time.
    water_shield = {
        id = 52127,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        startsCombat = false,
        texture = 132315,

        handler = function ()
            removeBuff( "shield" )
            applyBuff( "water_shield", nil, glyph.water_shield.enabled and 4 or 3 )
        end,

        copy = { 52129, 52131, 52134, 52136, 52138, 24398, 33736 },
    },


    -- Allows the friendly target to walk across water for 10 min.  Any damage will cancel the effect.
    water_walking = {
        id = 546,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.03,
        spendType = "mana",

        startsCombat = false,
        texture = 135863,

        handler = function ()
            applyBuff( "water_walking" )
        end,
    },


    -- Instantly blasts the target with a gust of wind, causing no damage but interrupting spellcasting and preventing any spell in that school from being cast for 2 sec. Also lowers your threat, making the enemy less likely to attack you.
    wind_shear = {
        id = 57994,
        cast = 0,
        cooldown = 6,
        gcd = "off",

        spend = 0.08,
        spendType = "mana",

        startsCombat = true,
        texture = 136018,

        toggle = "interrupts",
        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            interrupt()
        end,
    },


    -- Summons a Windfury Totem with 5 health at the feet of the caster.  The totem provides 16% melee haste to all party and raid members within 30 yards.  Lasts 5 min.
    windfury_totem = {
        id = 8512,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 0.11,
        spendType = "mana",

        startsCombat = false,
        texture = 136114,

        totem = "air",

        handler = function ()
            removeBuff( "air_totem" )
            summonTotem( "windfury_totem" )
            applyBuff( "windfury_totem" )
        end,
    },


    -- Imbue the Shaman's weapon with wind.  Each hit has a 20% chance of dealing additional damage equal to two extra attacks with 1250 extra attack power.  Lasts 30 minutes.
    -- 风怒武器：必须学习了该技能才显示 by 哑吡 20251225
    windfury_weapon = {
        id = 8232,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.07,
        spendType = "mana",

        startsCombat = false,
        texture = 136018,

        -- 必须学习了该技能才显示
        known = function() return IsSpellKnown(8232) or IsSpellKnown(8235) or IsSpellKnown(10486) or IsSpellKnown(16362) or IsSpellKnown(25505) or IsSpellKnown(58801) or IsSpellKnown(58803) or IsSpellKnown(58804) end,

        usable = function()
            -- 如果主手已经是风怒，不需要再上
            if windfury_mainhand then
                return false, "already have windfury"
            end
            -- 主手没有风怒，可以上（包括切换场景）
            return true, "need windfury"
        end,

        handler = function ()
            -- 清除其他附魔状态，设置风怒
            _flametongue_mainhand = false
            _frostbrand_mainhand = false
            _rockbiter_mainhand = false
            _windfury_mainhand = true
            _mainhand_imbued = true
        end,

        copy = { 8235, 10486, 16362, 25505, 58801, 58803, 58804 },
    },


    -- Summons a Wrath of Air Totem with 5 health at the feet of the caster.  The totem provides 5% spell haste to all party and raid members within 30 yards.  Lasts 5 min.
    wrath_of_air_totem = {
        id = 3738,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 0.11,
        spendType = "mana",

        startsCombat = false,
        texture = 136092,

        totem = "air",

        handler = function ()
            removeBuff( "air_totem" )
            summonTotem( "wrath_of_air_totem" )
            applyBuff( "wrath_of_air_totem" )
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

    -- 狮心 - 人类种族技能
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
} )


spec:RegisterSetting( "st_cl_mana_threshold", 30, {
    type = "range",
    name = "|T136015:0|t单目标使用闪电链的阈值",
    desc = "当法力值低于设定的百分比时，默认优先级将不会推荐对单目标使用|T136015:0|t闪电链。\n\n"
        .. "如果学会|T237589:0|t雷霆风暴，默认优先级可能会推荐使用它来回复低于该阈值的法力值。",
    min = 0,
    max = 100,
    step = 1,
    width = "full",
} )

spec:RegisterSetting( "shaman_rage_threshold", 50, {
    type = "range",
    name = "|T136088:0|t萨满之怒阈值",
    desc = "当法力值低于设定的百分比时，插件会提示使用萨满之怒来恢复法力值",
    min = 0,
    max = 100,
    step = 1,
    width = "full",
} )

spec:RegisterSetting( "auto_imbue_2h", false, {
    type = "toggle",
    name = "|T135814:0|t双手武器自动切换附魔",
    desc = "启用后，当使用双手武器时，插件会根据敌人数量自动推荐切换武器附魔：\n\n"
        .. "- |cFFFF0000AOE|r (敌人数量 >= 阈值): 推荐|T135814:0|t火舌武器\n"
        .. "- |cFF00FF00单体|r (敌人数量 < 阈值): 推荐|T136018:0|t风怒武器",
    width = "full",
} )

spec:RegisterSetting( "auto_imbue_2h_aoe_threshold", 3, {
    type = "range",
    name = "|T135814:0|t双手AOE切换阈值",
    desc = "当敌人数量达到或超过此阈值时，推荐使用|T135814:0|t火舌武器。\n\n"
        .. "低于此阈值时，推荐使用|T136018:0|t风怒武器。",
    min = 2,
    max = 10,
    step = 1,
    width = "full",
} )


spec:RegisterOptions( {
    enabled = true,

    aoe = 2,

    gcd = 8017,

    nameplates = true,
    nameplateRange = 8,

    damage = true,
    damageExpiration = 6,
    potion = "speed",

    package = "元素(黑科研)",
    usePackSelector = true
} )

spec:RegisterPack( "增强(黑科研)", 20251221, [[Hekili:nJvwtTTvu4FlzYmSKM4ylhsA6GZdDANPnpK8GYBDQKUw(ASg0IhjzOmdJgiByiqAOqwH0eA2GSqsBAziS08JPwsMN6FHEUx5fTAdnDsQFaSp3Z(57EohjUmCxGJTaYeZDoM0mdKHHjtQ0mzg4ez4ynhRmMJTmsCy0qWxurkWFT)LF2ENT6BVTN39zZ7(Wf73sOpM(jSnMSgQarDgAv0fbw94XEMLa2CxBdNPNGJnFfjzZVvLlFCwnlZj5yrvmlPPdgAH5TVXkCSLKkua7ja2qKJT(7VBTnFUZmtu)s7wBN7yFLQUB9S9UYCU7UU9d2Q2wx)BWdljl58RtBp7TCNUQD1nQT7Y)1ex06SwNL49Z8WABDv7FCwNPVMZREQ9Dx1(NM19QlA)BRbbM9uB7EVl7S4RDMDYgYenm(opF77HOwxROKmeRh(WwcSLqki1VWs4RvlHufXkyvtlHJzj4LZQFJvD2EfIlt9lRZsKX5TVX((p152B4U2wUt)o7QVGCeripgjo5BVPhV52NF84gIq3jFXX37rxh(h8Z5UzTDxaCoNDwZzJv8IClHZyjS3TFU7I)H76VY7xp66o373DMEbitqj4EPQUx(n7T8uaH((QZFHAV)(qUPF6z2p(z2l34mF6Q27UM7s)PN0t(cqANB9gN78apc0mT7SlrejohL5yzDxADNhovY(6ElKGY)ihBDluAei12(j12CMVy)7VnJVp1Ht3aAn)0k4b0QpKMFf2N)By93vVTHOvVA9hDX)vPI9r46VyCadxKOPKMQrQY6yrnL8iZpl3XhvsTqXk6JXpkgvwt9OsfZDifKePvqbEjL8vWf6PnHsidEJYyz5YAJI1JxJfLHoUMAQdvb3uP6i1HZ5XBQOhNsb9d8ewowMyn)hQ1j6uRyrFQmErLLgQKPQK6q8gLKWYficMVsXIP8(zQcAJQgVKIizzETI8MLW8yzAhuJwsJr6ML4n1mXkuvm(4uYfL0XrPokmDrpkzKKFIX7eL1i0ADwJAlelGd4NAESHjpquMePEcr8vcfZsPklAoy2bcRLpyeYNcCXbgnacyqhgkzykjcMEimHDdSjFEn1kgPmLW6zsJBpNKNPSyUm(vqfdmVeuOm8tmAPHw9BavqYE12aNJ1bYgLL0LmJiNQ2iiIJripcOgvSIe24m5Y6NtXsq6HVfMUfCubHLnm11uAMLnmHvLYnqpH0wGOQ9vJ8AYMDvx7xpoGnmm10vaTjnmosjeqXAIdFuXXeLHlni9HWMg5YCucajingA9fQEddoBpEuHYMc5QgFbj8zYDA)k37Ujv5XhUT7eaLjOwrIqc2GkskSkkVmGetSlH)4pGbqJG4LrgLIqmAcOJnxc1fPNinr0XKRjgdYK2VovqdPG84iov1uOCYGMufhRN2mecZgjCJtZ(OLQs5EIqRP5Y(FvnGcdh0pfcsHs9iPtLnB3UX3a3mQKzjj1mPHonQiANrOvGj4sgP8KIkauy0XGVixGJDeSUbOxVNpi9NZKMJDuKojkmGhbawdy(z(7DUN9R3X(kpP3c4IOkYM9Ax921xz19wEI6pDYABorTTwQ(up3EMvR9(1Dw8D015DF5lzQVYSGS12CoV18j77VWCWZi4mlSQ2J7nM26924rbCQEd7zEGNvHhIGP1dI4zzkxCSYqoWG(CvE(f81ZrFolVCfejTgNWX2iRZ9LCMqWs4QnfwrOPfwxcXXEilHqDTTe6XsWp5GnVdAnFJDi2jBi70K1OD53h(qIoazIttD35PseF6eDk2doNPJomOQbsuvDzceSdOLqM2QpmKMO8t6Vs2AivOc5P8ZKhgkehFUFoIRHqi(pDa(9nuleFzsNyWhCMbSemeSzd5eK(Ru1Kjr10Hbw083auureJfiXgAMk1Ijd(7QfBR4GZxP6nmyVdjKa(yW8Xj8N)9nHnC6pm2las1Rtl4c(h1sAoWgzamhltO7anMftZUrNh7vopn1hcar9nzoSVEQeZmDy(a1(HNthxbW7yQHIc2P51qUtaiERb7HBrMocxXwiy6cao08(2rvmZ8Teg0sGmcQf8nMnjOgTly4OBgaQgkBn2oOTtK4gcT9bFZ9PMozyEmRo02sXS(anCZMSLsUt9bb20467GbP2A9clHJyjqwXOZqlMK71hA3JgZQ82)GA3UTdshMcysE1FnEIXwJ3)im4om(6)ddUtg4DGhCNmY6G1WjzqrSViblHXh3)fVypj8luW3rbFPcDVnXj722buawEKbUW5vJ5vUdqYYyrYwgeg5(N)]] )
spec:RegisterPack( "增强双持(黑科研)", 20251224, [[Hekili:TJ1tpUnru8pl9svRqyf7DZsrc4qVbhwoyUHyShBpjEugpJ14XjSxSwbQWYEbwPvQiHulGecOx4eiuP8PHMnPFl4n2BITx)VW2fUuUefnZB(97nV59(9Ejit0hGSdWkc6qRrwJnTmpWW0A0493dzRokMGSJX(ZWtHVWXrWNl)(hT8zp9oV4poB1pE2QV987M5EhR7Qn7iMahOHlrKk9btlSz5PFdy2QF(3U4logz7LszQ3LJ8QY6O7znczJtvHcjYE9xF26V8Zx(GtwD(Jr2H0GasH9Ke)2a9dREGpc8ePycLb8JSNtKjubVkllWsoLpnbzFXjF1YtF8YF5zlFWp88N(zh88F)jxC6XR)0)C5jpC939t)1XFs27HSz0evI(wHfeDW6WTFOq2eo2Jrcq3VW7K0yLMo7x8WNS68FD9jpcoMFXs(Hyk3HrNgQ08dliPkIKIr23ksmhwkZ92zUAZNtCiCseLKK5(ozUM5B4LozIreMWsusrKZccowWnsuWRdy1BN5UxUzjlaKa7aUcX8adjr)9cGkCfJR4jg(4evM7RL5YGheU)rvWrmzY1ggi(COLoWvjivENVE3t4Ao(kH6UJWa)71(B1MteHNgHDucfjQQVL7ctOssXwLx(3kZ1k3jvy5uIYybvfs57RzA)(zkhnUyoUpEsJBpfaU1MAog3phjkHmcIA0zKQSuZxTkJXvm3iqSGRz4GbUfmqcWjju4pRw(RI6pBtc8L0POr6RLtaLuCdgRX)n6hFcwQcBIFGqzuH6AjJ5WEV(HDBkbCEkHf04nOy5TrH3Sf4869qBPAbK7l3qdaL5ObCn8CSddNe29lgCsvU6J1gO(xov26)Gu5bkmF1tS02h3O3r3YkBn(MssThn0)x15vxvNaYeCkt1MWZv8RIGyrXV25kFXROkuFJcVUTDW0gRhH5yJyFvrA9O2KUktIXmMJyIJkeQgyKichMGBZ0iTw6udPlrVKrqRmHOu6PgH4pg2Wrcted4ljqUH(PDB1q(2WiJu)CBQgY6w2R3A49krxMYDk(UJES0IHtDkMlpVbXWdI0aIDq)4QBaXJ9BmfwDxzxMxPSaXtWuDPXFZjLxNVRRs(aO0LqEhACvYghoSmSoE3IDxdL5wL47w37FSYCRc8DieE)DxzUvD9EefFjgwQ1PV0u1XVrSTrOktaQvqb1qVmZxz2XqC7s3KgnU041MYLxhDGgOrN5asu7C3PyjXxe5HB2FQQNr5btsLhDz5sT8uTipLRR0DOrEPKG8GA1LdXjojXeglwSGir9(tA7aUUWQE6VsWNMs26KsmF2glmAAaOc8XoABE9Ttt3PpbIzvCPEP9Y2h3ajm5VpE4esW7ZB5)mc0uIj(AXkTHO)o]] )
spec:RegisterPack( "增强双手(黑科研)", 20260120, [[Hekili:TN12UXnry4NLCtJeizTEp0sKs6fCh9ICZ2RT3zTNn2k(e2ZMqKQwLqlTH0uOLerLAReebuvkTuUbu6rEyypLR4vG)zS9UJ31N2eNsOufPiRDo8)n)N((gBjrPllvxfrWslxUu5ZxsuCbbXpQ2cvRjvNSHdwQUdszv0kWdwit4)9(6D7)L3S31V1GVF)b)8FqhFddBKkDF8SB7QaZrQEZ26gKpXsQ5eBEfbXfkvRSimxhSI0YxqQUMUQk2FMypf6IDCTBPBW2N1WUE62wXS(1rUw6wR4jvF4tFyV7SZF)Q717zVQ3x8tZRIBHABqMV323D4bp6OhS5WhUv3d3S7lU)WB84E78OU)5V2F)N)xB(5DU0GN8KYdpyxyTDp8w93)z93DRb37A937wDF9d6V7n6(YFC(MypISggzagt2XMaOzE2A7CP(BF7E78D(wT7lUETUh(4(7S5WR(AFlZMLuDuBIMTl4427o9U9bs1n09iEmVfSJWP8YslZccylutdSQ0hlvxXvNGD1rqia5UcMiSUort3sSuNgNRtdtKfsWrH0PXIDA4HjeQBqWtdbdi7cHkzIMl2tZ2qfSUcfXGXyddMwxHnhjc4tt0SnB3QLqlDxyRSjytbv71Ty2MnW6qe1nyexSjs3YJHLYLgBpfKHHSDlakyzSb2eBbhAWMvYTnhVZl1PHbyslLngJb2ed2yKbhmhdbt0kMi)rOwUAONMKgamrydpIRTP86yKJTLGhbY)70aWqnM1P7(AGPTWM6yp2aISbMd)PT1DCWQc2TAPHS4C(gO1qYnB76rOaPg1feziWG6RI5HfmTZZpnpITRzSt7ct6qro(lzWv3EW1(nvBcn1(BFk)jDovSVt0akPLHmfLvfGeJvHej2rjiRJOBsdgYQ64onUiCqxymG4wkffFuIH1mm1CM2Rf(CQbaQ9lZMM36WceOjhYu384eLl6hDG1yOVIgH2EqUPTbrqb5bvlFixAe8CjHsqeTGIPlKvY1Ck2q9iKFkmEHcTDY(CNAIhhCICIPqsSuIXK0aZmgsQu0HKupsj3OminJRojci46mHrUeTXzUIL5RZ4hmADMyYDUGgqqxiQxH2D1phpyIJDIEA6yd1jArn(i6pmZqv5beRpNL9AOjHtTcbobrYfJ(RMOptoyKpGgvQujvitOUFgN7uKznJK2bzjQTA7UHmnWqtuox0K6fhXMbKM2Y6MnBJLlRjJSJLtB025NwY177OF4R6V53mfhxt(2JB9ld3E3iWJ1JIyBTcy1eq4fxA2Gi)wgGY4ibdb1WB)O(V8GUp)Mu0NSmGZfkbyXtc9F1jqr4CDBBj7)SmvRcpoMSheTdW59L0i7lpe8dJ44o57D5i7TIbgTgEe3ySj)P3LCkZZT7bYXcOutTzECqTA(SslqISFjJJlwX2SjA6IMO9QPc(8Zf9Z2uJLnaQGRKCLrQI9YPfyD7N5m7OQRYDtWjZnNyF8BtZRn9kxHxyySJWlBDIHq6UXkHmbvSe)883RC)TNY9mjeNbv1XuBp6WRr1WmkJm1IEXSvirfVLQi9JU7JhS)VF0EVjsbjNaSJJvNjPYtCINsywY(M8i7pw9ylfrpg)vBYJs6mD4ZMY9PKjhPbxOuqLnaYhz)AApk(Qt1if9xRxvkF3Xk1ByLlzUfYTPQM3uK8kDVWUnL4K93cNwe555lzJj()TV(9tSHkeL5bxtiUsTiTfjbctck9IR(lSJvketfi7xahxADQJJMQiicdP6YMljH3OuCSyNcSLbCEHail(Xei(ka(T0iisskDm8F5Gc(SfXya)xkzarQ3Yx7QLcAx9VcnyArQPEDIXZtMh(pgYYMbmfhlh2F3LCmKim76Nb3)nPqdCmjGcBYWiodXqCg(ScvxgTJpjAhIRrBAKPbVPI)hEbXJnR5Pmr0uVU03rUbwYVjSIsNrS6zcVtBwQoE)fe5VGyLILG80)kI5oh(0JfmTRiE69f3IJQz0xHk5Bs(F2pSwXCN1CC54ZqF2QLfNS5zriv4cZMub))K(N]] )
spec:RegisterPack( "元素(黑科研)", 20260105, [[Hekili:fB1YUTTru0VLUjizJGKSE4cehGuGUObToly7wsnICKir4dbYHsWageYXvpGGTJuRHTRtCJDACJIdYdey0yePK8XunK0R6VqVdP1lhjfz0fDdf1CVZ5CM7lo8X4)rEojebZVC8OXtfnw0urIfBHujsWZrwPaMNRas8EO8Wl6in4jTY6ENEOFZ2x)8oT8EwlVd3(gmNwr1ajXaZYW2ueCKNlRTIk5705ZocdjJfpEsWPcyr(LtZZjRijHdDbBjYZ1R7E0n2XB96E)8Bo)r1O168pD3G(KFN24qVN1H2ODVZEjZNk1D3QT)MnDUZf7O6203(CV6v9)J7Z2XJApkgUBSMxNx6U7FD(UNglssREDoU3znoVwd3T)i4T3rVQ3NoWD)tbx7d4TV73cwUTB5tGT59IFZ)tTGN9(WMWQ96UVFTtaXeQHqUPp8J(vyObBH(09dfP3AVaeH7oVXDVh3hz6tFUB5FzG7GlHXuVo)Q7bpM2Clgg13XVCfg7JUAiP(hDCiedo79raCjRHLLB99yI8STdx1DRnCFWr039wA3Y0MVo0K)7oW7p749Wx5EyTfI6D4AqiHwTYGGXamP1EV7bq0At6dArBvLNtvXIyXs0idm8ZYbvqyDuwvSe)3WZjAQqWMkiiJAus3jZ1CYqqM5XKiLuiYk6lc7uKOyOZZPHYRHeigeSgpbkpMkszTZLlsoftCOZryipeMG1emYjuYerKziTqG(UWmwfRH1jivbnKfa4kJsc4CI5Mw7cF(Xjw0Hmf4QUrred2Kxc2(ojkJu0fuvYlt0v0ZpkFmxkIfW6ynfS1TwkjdNutvEFLtgjCOgvHEtblzdX7fiYvxDIMmXAa3wozUPtMfwDvnJIbcyG8h6kJ40tpXodOV1sozGwSHOQIkIeYABAryGUy)sgYCfCGD81JMlhyriRHkz8ej8xGJzwrEvRJIFvQJw4)Re10lG)pKOsEfc7s4CiB1VqShccmMLr6sckAzTb7JFGig65TXcLWOcWAZCEGgshfPGijiaLoQtgdtNmxFSvxmAqVAyO7gJKKLT1LWWH0WuBszTX6LhMYdhsD5sPujshngKiV2fJeKGzJiDr8nxkE6ij7VQILaBS8CmRXswbRkDPYYsW3onfcn1pZmRwiKQkRiMipq)wFgryKjrEKMGGy1K6ogAiugtYcsz017pZAgs8snAFPg0zolA8zMHL1XztcmvejmrmGvtBDHW3fyFdl8lzcH3QH9TSlMonjbpRTg0UalvWelAOLfnpJGMR880l)VYTsbcSiu1ZCzKRHvczY6QH6d36nPnEm91DPvoU37RMO3zN42OS)6FGwFx)JA)3LVVZDasSjYgM8CFpCoqwyP7ce(t)WGRec3EmjlqyKtrLDdqgT8)7p]] )


spec:RegisterPackSelector( "elemental", "元素(黑科研)", "|T136048:0|t 元素",
    "如果你在|T136048:0|t元素天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    function( tab1, tab2, tab3 )
        return tab1 > max( tab2, tab3 )
    end )

spec:RegisterPackSelector( "enhancement", "增强(黑科研)", "|T136051:0|t 增强",
    "如果你在|T136051:0|t增强天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    function( tab1, tab2, tab3 )
        return tab2 > max( tab1, tab3 )
    end )

spec:RegisterPackSelector( "restoration", "元素(黑科研)", "|T136052:0|t 恢复",
    "如果你在|T136052:0|t恢复天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    function( tab1, tab2, tab3 )
        return tab3 > max( tab1, tab2 )
    end )