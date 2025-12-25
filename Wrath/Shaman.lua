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
            for i = 138, 141 do
                local _, totemSpell = GetActionInfo( i )
                local spellName = totemSpell and GetSpellInfo( totemSpell )
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
            for i = 134, 137 do
                local _, totemSpell = GetActionInfo( i )
                local spellName = totemSpell and GetSpellInfo( totemSpell )
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
            for i = 142, 145 do
                local _, totemSpell = GetActionInfo( i )
                local spellName = totemSpell and GetSpellInfo( totemSpell )
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

        -- 强制显示为已学习
        known = function() return true end,

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
    frostbrand_weapon = {
        id = 8033,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.06,
        spendType = "mana",

        startsCombat = false,
        texture = 135847,

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
    rockbiter_weapon = {
        id = 8017,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.08,
        spendType = "mana",

        startsCombat = false,
        texture = 136086,

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
    windfury_weapon = {
        id = 8232,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.07,
        spendType = "mana",

        startsCombat = false,
        texture = 136018,

        -- 强制显示为已学习
        known = function() return true end,

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

    -- 自动攻击 - 后备技能
    auto_attack = {
        id = 6603,
        cast = 0,
        cooldown = 0,
        gcd = "off",

        startsCombat = true,
        texture = 135641,

        handler = function()
        end
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

spec:RegisterPack( "增强双手(黑科研)", 20251224, [[Hekili:TJ1tpUnru8plCbTvizLKDZsRe0dCdoSCWCdHDgBpjE0Apt0mJt0EjkfulBxQODLIurcP2cie0YbKqceQu(0S1BY(TG34jj2jX)RbQybTxII845979(9EZ738SvtRpYY0djXwh0QrR2nB1AxJw7266720YuEuFSLzFK7HOEWFOOq434V9rXV45Nn(bX3)ENF3V4IV7lpB8PQ36OagYtznblI7cV5f)XPt)HtJp5RN(KjtF6VD(DhBz6ercKVp1YznqBy04gnAUNLjks6Z4wMZ(QtND)pp(2hpDYJTm9jEEy9UWc38m9hNDdFc4pCwxsa4fwMdWCbHr3eRHioLq7jSmp)4heFYJJ)5xeF7V)Lp)o7)YF)zNFY4zF2FgF8dN9n)4zJ)0rFGLzarifQieXWkE7GL)iTmXuKta2Z69GLDLk8mdqdq2cjNCi4hUCIeZjiGwr8EyPXqI0NqBb79GwLBNquVqKTKjXHzTJtu3UgDjCSEjdooerOIrDENrDAnQZBoQZkiTNcPDlhPeRrzdqLHtu)eJR2ZaSnMIdjya1B(UJ60uHXELJHqY4HvXkji4XKgzE7vdqfsTZhjvncN0xd3fp8ztN8RZo(rPEGRpyg7aspFPk)N1lEJq2a4r5hGq8LSqcHeIWbGFXcThIr9zuWtHdkZPHKxtmeSKHYLT9ruVu3)MABd7znpXWfjKJ68wJ6eahoOUhPcY9vvCzIUuND7CqW)AVghvm1a4)2vuYeaTfSf(m3dxHiLe3dNBHRxJJjorCHSOmXoQkHmaLhvMALnyXRLyeWmvN40V6o1i1vgEQG(gBtqxwCo341mbdEqZgv4clYY2oSGc5(Q5S6tzRay(0wZQ6PwOtxpoPIwT1Q5uIHQOtkgXL(BESOSeS2bRO7zA8l8j4aVnya9Jn8ydPj2lVEKoLURLyneYl8f4ivgae(wsGVMvQQir9pIsvf5WARF)VJINlAtjUlVkzfR(MYyZv7YHkxgR1sfF7I3f9iUsW7kbVQptulk7kbV)Jl45H7IIaAVenpxuqGnRRT0h64eGdXuyiX1HtZoAvjfMPvAzKRwDbTZK3kiYgpperrg9DL6EDnkrtn3IaFeyay6wIRnpzw)cQeMB5u0aDjbwkvtrBOTsIbaYGJHeEs6AzR7IvClT1D7uhLhrT1)3wnmUEKCB9hMi5Ujflgxd1H1xacU9lb71gHAvxP56Q1)DUFrrIIfTLCpD)6uz7)jQy5lwTO(D6DMe)lpvDnRlFQD1)UGvtM1NlRsERqrSvUYxrkGzUZ3RIOxrGwIyy9YqTZxSReTX6O5SH(wrAIofOtTn6HB6BVktNL74EkOkOp1Y(lzMzln3UsBuOZzzUwfd0jvF3xSll0bLRKDMtekrmcvvzBtcDIG1tzxc1RBe)O5fx5jCUTj28Qt2Y8AvxBkJ2Iutnoib27dPl(e(7O)i6tFYKRn)R5FVBb)o9w)uYh0x0h7QumuB16V(d]] )
spec:RegisterPack( "增强萨-双手2(黑科研)", 202512241, [[Hekili:TJvxVTnvy4FlCdf4IOeNK2ojGl4kyx0BmxBNtSpj5O4V0Xh3qKMIYguwAjfA1Q4JrfJIGTQPXM2nOswR2pMzNKEf)f49CSz2jyhN11jHe9MilFE973VpVpNOus5tvK1rmSYgsfLQwssQsHIfLwVYAkYSUoyfzhKwBut4blKj8BWV8tbNoA6Ehh8ndhV9xj1R27C(Z2FYd2FYpFW7YLURHnsNRvxBpQg8fkY19igSpXsPEAMATQGOoynLnat2IORJdfe7QPip95)G)jpC8o9N(5N5F63hS1GjJEW5BT7KZECW9g5p6R)yCBIbz8t3oy43oz7bbd(d)Zo8f9VLISbXL5k8dIvtdm80gIGfPXi2wW5OnrQUmkPn4JyluDdSUYhPWaVlPyUmBQzQIvMlw8BK1OegMsqkYVvVAmIwBWU9Q92WZiAtmRaJyIvz2Q6eCVAF4h0R21ITsddi5Q62YwRnx1vYu119A0OGjcBaUKTPAhmYX2QGldksHkT8CryDpQlJRZQxmDcQSAcvsA2IzbbMADBdHAxnt1QJfkorcSGNtSQWikRvCiVwYKEYZMnPVEMMJHmWwmUBd5(WVTqKGIQqOZ0IGn0lOB3XkTGk8yUDUws3PbHIvTS3enNZuQ4LI3eLPF)zFRj6ZuJo596vRyHYLxShxQ0IlWIGGzZWMIWp2l6aJK0OtOyteXYv4msfJnOgYWq1UHkRfwfBGnHyZvyuPL2OXQgAPmaBAP1n2jecgPzKrc)m2hmrnnrHNimD2ZFrdCDiSweRsffwXezHk4OXeHMlMXGSNlKRrWbQuaGdInkgkuq2mE4xCmaKa1qUmk8wEOXUbYd6(NhrPdXshkiqZBAakzHuWZkTqWxsmR7f1DW14Mq(WcBsWHvJYZANgE0UrtQ5IfTmwyoOdbEeZ2QPhoHvQKmA9CXQGrmDNlyRMuih7Ob6KsS6)A2AUc)CYpd0qdmfeZ1Har4sJna1BaWYYZfaHX0sfX88HMWMQsoAcuUslSShciKQYtlvUASYOEwQHpRYxjfUysnCzkYgNdosAkxA5uUMbgTjovOHL5ZJwBk64DOynBZ6O4E(xNETC7MFTNxwQU5SNzE1wvKZY6WDzjbEVXnsc6L6jjXKN7ieHMk8ygq0SWUS5XQYALM0YrrAH4n5S4pjJQ8tFlhVeTwqxH6lRoPX3zMMH)HBHwxykrnCFHlpfjZx7o7BLRCH42TqUr5sJRIsg04w7IPZ8OXTEY6E2CENHwu2S0UKigL)S3ci98QyOljgylpzOlrgy5aJ9MKbw2JUVHzGfTA7cELUSW((FfOw5Ra1Ucu7kqT)7aQbWADquE2hMoN(73py)D(RtVBWtonyRFBLORCUsWGVB6rhF(H9NE)B6FsF)r)40B)WGDo2)5pE8b)5l6FRExFYJEK00JgcFR)j7o(GNmE4nNC3Vy8D21)Sdhp82(p7xxPogy5d3t1GxQdVI2kIVT31hpyVGDUxOv9h9LvF5)(wOLfsbbIhRLnCl3G7SFWEhXVFGDdIb))6Jhhk)9p]] )
spec:RegisterPack( "增强双手2(黑科研)", 20251225, [[Hekili:fB1wZnTru4Fl9LgOZexB5gUKb4HoTZ0MhOpiEwYRLxhTt0fpsRtAMHrtsjqCcouOjCnHsdxd3c0sltWKa)yQUy)u)l0ZUsowsXYg4Hw)qI9z)2Z35(zLkiDgjXkikw60c5fgRGGWy5kC08fYFmjr6S1WsI1qktHMe(Ibsh(BbMKz1mrvy302SULcivsSCDIg97nKkFq1DKXekweWwdRiD6JkjQsQubhIeBRij2(930DNN4V8CTp3EU7EdVZ3iO1J6C(vc2BBV70YT1L(o8uenI)VVKxZRfSudVgV2DVn(75(jNjevr6iJXDk9TgQidfSo2G6uAuNsE39x92Tv7lVL)B3KPt(fDMW)vV072p0)6Vo4XTcw6nEnEktm7cHG8x6I(V6QotCYpWpot49ZndM)PFzN7Dj4FaVRCv39wfmi)DFS)R30)5p07MB5u6uoL6C9NeS2FfS9Zd)19UK)T(t)Lw1BX3YfeCUgbl8YoBSii4qFZpCg33FB)MZFy(zE3)rEBeDwmD5(MlgS(7cV98pfUT)1EP)nUtOGlSM3F84GMRZUsAJuy0IbRVT)VTy22zNvZqX)h7xdYnICc33(a3DwE8pCBTRV9)PRmScRUF4onRQKBLDU5cDE(AEnw0FL7oUZeJ2TE7qNikwC4XdT75(Li3IHj4D3NH5uNmgiiw1UrZUGgMv09d07BzwLOX74NbzzqmM0gAGb1CLL)NDVL3l2178pyKk4QO6A0r8AC92BUvNnMR9dN3DN5CBTE7fFI3YB5((T9x7n8g4GN9mH2B2eUR7oR4V2lGaAWTwWF1vGoC)MqU9(JugBtLvXinGm5AMuIPXi87cTZnUS3Y3jKv3wxqy)XiHmZrjjQrSP285CH2f81tZN7Huykd8eIrfzBGcljrSbQSgUI0xlrHzymu9KiQyrOylcss8ZCkXUv16wZkRJiSPpvCk95oLy6CASm2aRtW2oLobuNMKj(DMbJQbcaokoioQQbdDPMgtwhpyAo1jtWt871JQVktQSXu5YMg1TZrjyRc5X9gNklutXPeO(c9uVnFSlewjkYwSLdGYhlEeTUnwg0TUDQa6rIdkmxMcXrJJOkXc8rnUDG0KPMGktH)yjWJTay21iGJLc3XZ03hwOKzdgMtJyAPq(mvt56vRMthH1SPwM6rr9C2uy9jp8nw)ZBjIRkQqowwJmPkL1AXzSWNoJ9u8(QeYYqdatVzxBpyBmz8Oy8WVn10shmgYu4ur)cPl9suOc9EMktbMWSkAyzkYAsm0Wc9OI6OFuoPurHuTiqn4uGJXJUHGGAyqNut5keCy684CBirfk0Stv7sCsB9izgzGIqOsKfIzv(8lNlciNFEgXwLG1QKRI5mg9lbeEmNOdwRZJRPmNev4AOPrYAiB10Oo(bq13eHWqkG5wbVpJ7a98QzGh1zfDIfMnlkC4gOWELVinnzZQYu197AT5KoKA4yK2t1qAtd40qz2Egr)MhKkqRJMuhfnPGrD2L5rTp7dpx9A9ykU84UBXSzk7b5FmLnrTVNiPuwFq0jFHtP85kwCWLwczpQpQhzgcvLyuip3aGH5OC1uOCEHDbu2E9CHt55d4HuQfgmCq7dCjGWhypMqIfbPMoLcAIUeuDOVgrzHIK4OS3MGvm1lJ6TGpR1QDxLkt0lxpkjexSkYg2IG10Qzod2AGRVh4te6hpdLK(S7w0czmvxe5oiaE9bdZOfg6tkmRwnMj9P)KHpUzDJny9ewPeFUZzpB8E((Es8rsPocrS670HSMqn03LWlWGIpvtit5T6v8U8MCzs)7]] )
spec:RegisterPack( "元素(黑科研)", 20251224, [[Hekili:fBvuRTTvu4Fl9Lrdde2YXnjW2Gnyp08q6dAVn6v6kPRTUeP7viDLnbkcNvstAjPozKcJ1nQhS101cT7HT120UTFm1sY(P9xyNRusRCIKtzpSHbB575C)(oNZ97C0f1e9finBSGGwtTHA7MQnwrPz72lV4IinXg(eKMp2ADCx4bg2d(ozRBM9RJU80xDq2rhKn6WfInUS6cs32WLJTLWfYJcSaxrAMruxXvziZYC0yz1gGt(el0AlH0CO22KcxiHwiTcKtUZ9bWZ(5Fp92d(YjFZbtgUDYw7KD4dUE8QXR28nd2C63ny6w7LS)ozB(KSDEzF84)4VYo8r)9R3nD0lt37Pt2(Xto(jMrDMC0dtgEqYW7yYddtV5wj363aNsE9GK9FwXEFZGVkE1tHzYZEUCR)WUPp4NsV9FcUo(f7LS53ME3hnzV9ZDvfO)tV2NdrWKN)9zp8vz3)PPJ2EXSrBo(fhMEVDhF8XP37xMU9WKF8OXhFxvaJIGiD4(tV1xdyG0CPHIqz1cZjWpRLFqqyytxIn6ZGLTeuodP5H76H1fCbXdPzfqfKakwwz70rPKnfBEFgsav4tbtujCDObeDgVhEUGf5lHQ18Hs4eXSjbHcEWmHM0EpIoHr8OKWyJprvc2IZhmlhmLP7s76iyuw35IxtjETVG80fuR6HoCR1lJ1LIneuR1bgIn(a4zCqxIqrqbFfCDBkbG)JJnAlz4kZNbxCpSUzeK)LjWMlukXTsaXdsmzuhByHdf6sU(qraUhXT4zxOXGzTHKXLMpJ9bpdaCPex7ZD8vS8BLblFbb)PfADtURaj)aTFDWrWFozJvS7zQJY8YbZS1PEMrG9zl9coRBerVpb7ZNNU8mzbbhiCkPOZpLYTKlCRYqrvPklyA51lP1WUU68o6chqv5s8imOt8I175BR4p6YU35R5lRV6tfouw7IME9I5OY2(tAlQTe)(jvRuZxFhs96MCE849Y7)Qu0DXDffhGNRVRa1ZxtuBFQUV6q0dZWk(wIyJpk2OvJyJBCd49nZS6vAukUxOMXt13rCMYrvYSzJ4gVJIqiBL9qftNbowP2e5F)CHQg4au1SXz4s(2ZaQFHVLP(KWN5BrTJnUeOzAT0klviqFxLeIJqIqaPtOceowU6sBqpsabIyx76hvldMAgymVXn(belUNj(TdC(VDst55L1k2B9(wJ)FF4vEjThi3Lov6Aw9XbY6Eis7QE(8abbKaTInkql2i)wikXRkpo4DOUf3AdhsSVgRI76bHrKWHhG0kFLSCYr)Z]] )



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


spec:RegisterPackSelector( "elemental_pvp", nil, "|T136048:0|t 元素PVP",
    "PVP专用元素天赋优先级，适用于战场和竞技场。",
    function( tab1, tab2, tab3 )
        return false
    end )

spec:RegisterPackSelector( "enhancement_pvp", nil, "|T136051:0|t 增强PVP",
    "PVP专用增强天赋优先级，适用于战场和竞技场。",
    function( tab1, tab2, tab3 )
        return false
    end )
