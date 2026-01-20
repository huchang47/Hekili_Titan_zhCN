if UnitClassBase( 'player' ) ~= 'PRIEST' then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local spec = Hekili:NewSpecialization( 5 )

-- Sets
spec:RegisterGear( "tier7", 39521, 39530, 39529, 39528, 39523, 40456, 40454, 40459, 40457, 40458 )
spec:RegisterGear( "tier9", 48755, 48756, 48757, 48758, 48759, 48078, 48077, 48081, 48079, 48080, 48085, 48086, 48082, 48084, 48083 )
spec:RegisterGear( "tier10", 51259, 51257, 51256, 51255, 51258, 51181, 51180, 51182, 51183, 51184, 50392, 50396, 50391, 50393, 50394 ) 
--加入251T10套装 by风雪 20250731

-- Resources
spec:RegisterResource( Enum.PowerType.Mana )

-- Talents
spec:RegisterTalents( {
    absolution                    = {  1769, 3, 33167, 33171, 33172 },
    aspiration                    = {  1894, 2, 47507, 47508 },
    blessed_recovery              = {  1636, 3, 27811, 27815, 27816 },
    blessed_resilience            = {  1765, 3, 33142, 33145, 33146 },
    body_and_soul                 = {  2279, 2, 64127, 64129 },
    borrowed_time                 = {  1202, 5, 52795, 52797, 52798, 52799, 52800 },
    circle_of_healing             = {  1815, 1, 34861 },
    darkness                      = {   462, 5, 15259, 15307, 15308, 15309, 15310 },
    desperate_prayer              = {   442, 1, 19236 },
    dispersion                    = {  1910, 1, 47585 },
    divine_aegis                  = {  1895, 3, 47509, 47511, 47515 },
    divine_fury                   = {  1181, 5, 18530, 18531, 18533, 18534, 18535 },
    divine_providence             = {  1905, 5, 47562, 47564, 47565, 47566, 47567 },
    empowered_healing             = {  1767, 5, 33158, 33159, 33160, 33161, 33162 },
    empowered_renew               = {  1902, 3, 63534, 63542, 63543 },
    enlightenment                 = {  1772, 3, 34908, 34909, 34910 },
    focused_mind                  = {  1777, 3, 33213, 33214, 33215 },
    focused_power                 = {  1771, 2, 33186, 33190 },
    focused_will                  = {  1858, 3, 45234, 45243, 45244 },
    grace                         = {  1901, 2, 47516, 47517 },
    guardian_spirit               = {  1911, 1, 47788 },
    healing_focus                 = {   410, 2, 14913, 15012 },
    healing_prayers               = {   413, 2, 14911, 15018 },
    holy_concentration            = {  1768, 3, 34753, 34859, 34860 },
    holy_reach                    = {  1635, 2, 27789, 27790 },
    holy_specialization           = {   401, 5, 14889, 15008, 15009, 15010, 15011 },
    improved_devouring_plague     = {  2267, 3, 63625, 63626, 63627 },
    improved_flash_heal           = {  1773, 3, 63504, 63505, 63506 },
    improved_healing              = {   408, 3, 14912, 15013, 15014 },
    improved_inner_fire           = {   346, 3, 14747, 14770, 14771 },
    improved_mana_burn            = {   350, 2, 14750, 14772 },
    improved_mind_blast           = {   481, 5, 15273, 15312, 15313, 15314, 15316 },
    improved_power_word_fortitude = {   344, 2, 14749, 14767 },
    improved_power_word_shield    = {   343, 3, 14748, 14768, 14769 },
    improved_psychic_scream       = {   542, 2, 15392, 15448 },
    improved_renew                = {   406, 3, 14908, 15020, 17191 },
    improved_shadow_word_pain     = {   482, 2, 15275, 15317 },
    improved_shadowform           = {  1906, 2, 47569, 47570 },
    improved_spirit_tap           = {  2027, 2, 15337, 15338 },
    improved_vampiric_embrace     = {  1638, 2, 27839, 27840 },
    inner_focus                   = {   348, 1, 14751 },
    inspiration                   = {   361, 3, 14892, 15362, 15363 },
    lightwell                     = {  1637, 1,   724 },
    martyrdom                     = {   321, 2, 14531, 14774 },
    meditation                    = {   347, 3, 14521, 14776, 14777 },
    mental_agility                = {   341, 3, 14520, 14780, 14781 },
    mental_strength               = {  1201, 5, 18551, 18552, 18553, 18554, 18555 },
    mind_flay                     = {   501, 1, 15407 },
    mind_melt                     = {  1781, 2, 14910, 33371 },
    misery                        = {  1816, 3, 33191, 33192, 33193 },
    pain_and_suffering            = {  1909, 3, 47580, 47581, 47582 },
    pain_suppression              = {  1774, 1, 33206 },
    penance                       = {  1897, 1, 47540 },
    power_infusion                = {   322, 1, 10060 },
    psychic_horror                = {  1908, 1, 64044 },
    rapture                       = {  1896, 3, 47535, 47536, 47537 },
    reflective_shield             = {  2268, 2, 33201, 33202 },
    renewed_hope                  = {  2235, 2, 57470, 57472 },
    searing_light                 = {   403, 2, 14909, 15017 },
    serendipity                   = {  1904, 3, 63730, 63733, 63737 },
    shadow_affinity               = {   466, 3, 15318, 15272, 15320 },
    shadow_focus                  = {   463, 3, 15260, 15327, 15328 },
    shadow_power                  = {  1778, 5, 33221, 33222, 33223, 33224, 33225 },
    shadow_reach                  = {   881, 2, 17322, 17323 },
    shadow_weaving                = {   461, 3, 15257, 15331, 15332 },
    shadowform                    = {   521, 1, 15473 },
    silence                       = {   541, 1, 15487 },
    silent_resolve                = {   352, 3, 14523, 14784, 14785 },
    soul_warding                  = {   351, 1, 63574 },
    spell_warding                 = {   411, 5, 27900, 27901, 27902, 27903, 27904 },
    spirit_of_redemption          = {  1561, 1, 20711 },
    spirit_tap                    = {   465, 3, 15270, 15335, 15336 },
    spiritual_guidance            = {   402, 5, 14901, 15028, 15029, 15030, 15031 },
    spiritual_healing             = {   404, 5, 14898, 15349, 15354, 15355, 15356 },
    surge_of_light                = {  1766, 2, 33150, 33154 },
    test_of_faith                 = {  1903, 3, 47558, 47559, 47560 },
    twin_disciplines              = {  1898, 5, 47586, 47587, 47588, 52802, 52803 },
    twisted_faith                 = {  1907, 5, 47573, 47577, 47578, 51166, 51167 },
    unbreakable_will              = {   342, 5, 14522, 14788, 14789, 14790, 14791 },
    vampiric_embrace              = {   484, 1, 15286 },
    vampiric_touch                = {  1779, 1, 34914 },
    veiled_shadows                = {   483, 2, 15274, 15311 },
} )

-- Auras
spec:RegisterAuras( {
    -- Attempts to dispel $10872s1 disease every $t1 seconds.
    abolish_disease = {
        id = 552,
        duration = 12,
        tick_time = 3,
        max_stack = 1,
    },
    absolution = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=33172)
        id = 33172,
        duration = 3600,
        max_stack = 1,
        copy = { 33172, 33171, 33167 },
    },
    -- Prevents you from being critically hit.
    blessed_resilience = {
        id = 33143,
        duration = 6,
        max_stack = 1,
        copy = { 33143 },
    },
    -- Movement speed increased by $s1%.
    body_and_soul = {
        id = 65081,
        duration = 4,
        max_stack = 1,
        copy = { 65081, 64128 },
    },
    -- $s1% spell haste until next spell cast.
    borrowed_time = {
        id = 59891,
        duration = 6,
        max_stack = 1,
        copy = { 59891, 59890, 59889, 59888, 59887 },
    },
    -- Causes $s1 damage every $t1 seconds, healing the caster.
    devouring_plague = {
        id = 2944,
        duration = function() return 24 * spell_haste end,
        tick_time = function() return 3 * ( buff.shadowform.up and spell_haste or 1 ) end,
        max_stack = 1,
        copy = { 2944, 19276, 19277, 19278, 19279, 19280, 25467, 48299, 48300 },
    },
    -- Reduces all damage by $s1%, and you regenerate $49766s1% mana every $60069t1 sec for $d.  Cannot attack or cast spells. Immune to snare and movement impairing effects.
    dispersion = {
        id = 47585,
        duration = 6,
        max_stack = 1,
    },
    divine_fury = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=18535)
        id = 18535,
        duration = 3600,
        max_stack = 1,
        copy = { 18535, 18534, 18533, 18531, 18530 },
    },
    -- Healing received increased by $s2%.
    divine_hymn = {
        id = 64844,
        duration = 8,
        max_stack = 1,
        copy = { 64844, 64843 },
    },
    -- Reduced threat level.
    fade = {
        id = 586,
        duration = 10,
        max_stack = 1,
    },
    -- Warded against Fear.
    fear_ward = {
        id = 6346,
        duration = 180,
        max_stack = 1,
    },
    -- Cannot lose casting time from taking damage while casting Priest spells and decreases the duration of Interrupt effects by $s2%.
    focused_casting = {
        id = 27828,
        duration = 6,
        max_stack = 1,
        copy = { 14743, 27828 },
    },
    -- All damage reduced by $s1%.  Healing effects increased by $s2%.
    focused_will = {
        id = 45242,
        duration = 8,
        max_stack = 3,
        copy = { 45237, 45241, 45242 },
    },
    -- Increases all healing received by the Priest by $s2%.
    grace = {
        id = 47930,
        duration = 15,
        max_stack = 3,
    },
    -- Increased healing received by $s1% and will prevent 1 killing blow.
    guardian_spirit = {
        id = 47788,
        duration = 10,
        max_stack = 1,
    },
    healing_prayers = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=15018)
        id = 15018,
        duration = 3600,
        max_stack = 1,
        copy = { 15018, 14911 },
    },
    -- Mana regeneration increased by $s1%.
    holy_concentration = {
        id = 63725,
        duration = 8,
        max_stack = 1,
        copy = { 63725, 63724, 34754 },
    },
    -- $s2 Holy damage every $t2 seconds.
    holy_fire = {
        id = 14914,
        duration = 7,
        max_stack = 1,
        copy = { 14914, 15261, 15262, 15263, 15264, 15265, 15266, 15267, 25384, 48134, 48135 },
    },
    holy_specialization = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=15011)
        id = 15011,
        duration = 3600,
        max_stack = 1,
        copy = { 15011, 15010, 15009, 15008, 14889 },
    },
    -- Maximum mana increased by $s2%.
    hymn_of_hope = {
        id = 64904,
        duration = function() return glyph.hymn_of_hope.enabled and 10 or 8 end,
        max_stack = 1,
        copy = { 64904, 64901 },
    },
    improved_mana_burn = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=14772)
        id = 14772,
        duration = 3600,
        max_stack = 1,
        copy = { 14772, 14750 },
    },
    improved_power_word_shield = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=14769)
        id = 14769,
        duration = 3600,
        max_stack = 1,
        copy = { 14769, 14768, 14748 },
    },
    improved_psychic_scream = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=15448)
        id = 15448,
        duration = 3600,
        max_stack = 1,
        copy = { 15448, 15392 },
    },
    improved_renew = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=17191)
        id = 17191,
        duration = 3600,
        max_stack = 1,
        copy = { 17191, 15020, 14908 },
    },
    -- Spirit increased by $s1% and allows $s2% mana regeneration while casting.
    improved_spirit_tap = {
        id = 59000,
        duration = 8,
        max_stack = 1,
        copy = { 49694, 59000 },
    },
    -- Increases armor by $s1.
    inner_fire = {
        id = 588,
        duration = 1800,
        max_stack = 32,
        copy = { 588, 602, 1006, 7128, 10951, 10952, 25431, 48040, 48168 },
    },
    -- The mana cost of your next spell is reduced by $s1%.
    inner_focus = {
        id = 14751,
        duration = 3600,
        max_stack = 1,
    },
    -- Reduces physical damage taken by $s1%.
    inspiration = {
        id = 15359,
        duration = 15,
        max_stack = 1,
        copy = { 14893, 15357, 15359 },
    },
    -- Levitating.
    levitate = {
        id = 1706,
        duration = 120,
        max_stack = 1,
    },
    lightwell = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=724)
        id = 724,
        duration = 180,
        max_stack = 1,
    },
    -- Charmed.  Time between attacks increased by $s3%.
    mind_control = {
        id = 605,
        duration = 60,
        max_stack = 1,
    },
    -- Movement speed slowed.
    mind_flay = {
        id = 15407,
        duration = function() return ( 3 - ( set_bonus.tier10_4pc == 1 and 0.5 or 0 ) ) * spell_haste end,
        tick_time = function() return ( 1 - ( set_bonus.tier10_4pc == 1 and 0.17 or 0 ) ) * spell_haste end,
        max_stack = 1,
        copy = { 15407, 17311, 17312, 17313, 17314, 18807, 25387, 48155, 48156, 58381 },
    },
    -- Causing shadow damage to all targets within $49821a1 yards.
    mind_sear = {
        id = 48045,
        duration = function() return 5 * spell_haste end,
        tick_time = function() return 1 * spell_haste end,
        max_stack = 1,
        copy = { 48045, 49821, 53022, 53023, 60441 },
    },
    -- Reduced distance at which target will attack.
    mind_soothe = {
        id = 453,
        duration = 15,
        max_stack = 1,
    },
    -- Sight granted through target's eyes.
    mind_vision = {
        id = 2096,
        duration = 60,
        max_stack = 1,
        copy = { 2096, 10909 },
    },
    -- Chance to hit with spells on the target increased by $s1%.
    misery = {
        id = 33198,
        duration = 24,
        max_stack = 1,
        copy = { 33196, 33197, 33198 },
    },
    -- All damage taken reduced by $s1% and resistance to Dispel mechanics increased by $s2%.
    pain_suppression = {
        id = 33206,
        duration = 8,
        max_stack = 1,
    },
    -- Spell casting speed increased by $s1% and mana cost of spells reduced by $s2%.
    power_infusion = {
        id = 10060,
        duration = 15,
        max_stack = 1,
    },
    -- Absorbs damage.
    power_word_shield = {
        id = 17,
        duration = 30,
        max_stack = 1,
        copy = { 17, 592, 600, 3747, 6065, 6066, 10898, 10899, 10900, 10901, 25217, 25218, 27607, 48065, 48066 },
    },
    -- Increases Shadow Resistance by $s1.
    prayer_of_shadow_protection = {
        id = 27683,
        duration = function() return glyph.shadow_protection.enabled and 1800 or 1200 end,
        max_stack = 1,
        copy = { 27683, 39236, 39374, 48170 },
    },
    -- Increases Spirit by $s1.
    prayer_of_spirit = {
        id = 27681,
        duration = 3600,
        max_stack = 1,
        copy = { 27681, 32999, 48074 },
        shared = "player"
    },
    -- Disarmed.
    psychic_horror = {
        id = 64058,
        duration = 10,
        max_stack = 1,
        copy = { 64058, 64044 },
    },
    -- Running in Fear.
    psychic_scream = {
        id = 8122,
        duration = function() return glyph.psychic_scream.enabled and 10 or 8 end,
        max_stack = 1,
        copy = { 8122, 8124, 10888, 10890, 27610 },
    },
    -- Healing $s1 damage every $t1 seconds.
    renew = {
        id = 139,
        duration = function() return glyph.renew.enabled and 12 or 15 end,
        tick_time = 3,
        max_stack = 1,
        copy = { 139, 6074, 6075, 6076, 6077, 6078, 10927, 10928, 10929, 25221, 25222, 25315, 27606, 48067, 48068 },
    },
    -- Reduces all damage taken by $s1%.
    renewed_hope = {
        id = 63944,
        duration = 60,
        max_stack = 1,
    },
    -- Reduces the cast time of your next Greater Heal or Prayer of Healing by $s1%.
    serendipity = {
        id = 63735,
        duration = 20,
        max_stack = 3,
        copy = { 63735, 63734, 63731 },
    },
    -- Shackled.
    shackle_undead = {
        id = 9484,
        duration = 30,
        max_stack = 1,
        copy = { 9484, 9485, 10955 },
    },
    -- Shadow resistance increased by $s1.
    shadow_protection = {
        id = 976,
        duration = function() return glyph.shadow_protection.enabled and 1200 or 600 end,
        max_stack = 1,
        copy = { 976, 7235, 7241, 7242, 7243, 7244, 10957, 10958, 16874, 25433, 48169 },
    },
    -- Increases Shadow damage done by $s1%.
    shadow_weaving = {
        id = 15258,
        duration = 15,
        max_stack = 5,
        copy = { 15258 },
    },
    -- $s1 Shadow damage every $t1 seconds.
    shadow_word_pain = {
        id = 589,
        duration = 18,
        tick_time = 3,
        max_stack = 1,
        copy = { 589, 594, 970, 992, 2767, 10892, 10893, 10894, 25367, 25368, 27605, 48124, 48125 },
    },
    shadowfiend = {
        duration = 15,
        max_stack = 1,
    },
    -- Shadow damage you deal increased by $s2%.  All damage you take reduced by $s3% and threat generated is reduced by $49868s1%. You may not cast Holy spells except Cure Disease and Abolish Disease.  Grants the periodic damage from your Shadow Word: Pain, Devouring Plague, and Vampiric Touch spells the ability to critically hit for $49868s2% increased damage and grants Devouring Plague and Vampiric Touch the ability to benefit from haste.
    shadowform = {
        id = 15473,
        duration = 3600,
        max_stack = 1,
    },
    -- Glyph of Shadow
    shadowy_insight = {
        id = 61792,
        duration = 10,
        max_stack = 1,
    },
    -- Silenced.
    silence = {
        id = 15487,
        duration = 5,
        max_stack = 1,
    },
    spell_warding = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=27904)
        id = 27904,
        duration = 3600,
        max_stack = 1,
        copy = { 27904, 27903, 27902, 27901, 27900 },
    },
    -- Spirit increased by $s1% and allows $s2% of mana regeneration while casting.
    spirit_tap = {
        id = 15271,
        duration = 15,
        max_stack = 1,
        copy = { 15271 },
    },
    -- Spirit of Redemption
    spirit_of_redemption = {
        id = 27827,
        duration = function() return glyph.spirit_of_redemption.enabled and 21 or 15 end,
        max_stack = 1,
    },
    -- Your next Smite or Flash Heal spell is instant cast, costs no mana but is incapable of a critical hit.
    surge_of_light = {
        id = 33151,
        duration = 10,
        max_stack = 1,
        copy = { 33151 },
    },
    -- $15286s1% of single-target Shadow spell damage caused by casting priest heals the priest and $/5;15286s1% heals the group.
    vampiric_embrace = {
        id = 15286,
        duration = 1800,
        max_stack = 1,
    },
    -- 吸血鬼之触$s2 Shadow damage every $t2 seconds. Priest's party or raid members gain 1% of their maximum mana per 5 sec when the priest deals damage from Mind Blast.
    vampiric_touch = {
        id = 34914,
        duration = function() return ( 15 + ( set_bonus.tier9_2pc == 1 and 6 or 0 ) ) * ( buff.shadowform.up and spell_haste or 1 ) end,
        max_stack = 1,
        tick_time = function() return 3 * ( buff.shadowform.up and spell_haste or 1 ) end,
        copy = { 34914, 34916, 34917, 48159, 48160 },
    },
    -- Cannot be shielded by Power Word: Shield.
    weakened_soul = {
        id = 6788,
        duration = 15,
        max_stack = 1,
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
    [55675] = "circle_of_healing",
    [55677] = "dispel_magic",
    [63229] = "dispersion",
    [55684] = "fade",
    [57985] = "fading",
    [55678] = "fear_ward",
    [55679] = "flash_heal",
    [58009] = "fortitude",
    [55683] = "holy_nova",
    [63246] = "hymn_of_hope",
    [55686] = "inner_fire",
    [57987] = "levitate",
    [55673] = "lightwell",
    [55691] = "mass_dispel",
    [55688] = "mind_control",
    [55687] = "mind_flay",
    [63237] = "mind_sear",
    [63248] = "pain_suppression",
    [63235] = "penance",
    [55672] = "power_word_shield",
    [55680] = "prayer_of_healing",
    [55676] = "psychic_scream",
    [55674] = "renew",
    [55690] = "scourge_imprisonment",
    [57986] = "shackle_undead",
    [55689] = "shadow",
    [58015] = "shadow_protection",
    [55682] = "shadow_word_death",
    [55681] = "shadow_word_pain",
    [58228] = "shadowfiend",
    [55692] = "smite",
    [55685] = "spirit_of_redemption",
} )

-- Abilities
spec:RegisterAbilities( {
    -- Attempts to cure 1 disease effect on the target, and 1 more disease effect every 3 seconds for 12 sec.
    abolish_disease = {
        id = 552,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.12,
        spendType = "mana",

        startsCombat = false,
        texture = 136066,

        handler = function ()
            applyBuff( "abolish_disease" )
        end,
    },


    -- Heals a friendly target and the caster for 1055 to 1352.  Low threat.
    binding_heal = {
        id = 32546,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",

        spend = 0.27,
        spendType = "mana",

        startsCombat = false,
        texture = 135883,

        handler = function ()
            -- 治疗目标和自己，无需状态变化
        end,

        copy = { 48119, 48120 },
    },


    -- Heals up to 5 friendly party or raid members within 15 yards of the target for 347 to 383.
    circle_of_healing = {
        id = 34861,
        cast = 0,
        cooldown = 6,
        gcd = "spell",

        spend = 0.21,
        spendType = "mana",

        talent = "circle_of_healing",
        startsCombat = false,
        texture = 135887,

        handler = function ()
            -- AOE治疗，无需状态变化
        end,
    },


    -- Removes 1 disease from the friendly target.
    cure_disease = {
        id = 528,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.12,
        spendType = "mana",

        startsCombat = false,
        texture = 135935,

        handler = function ()
            -- 驱散疾病，无需状态变化
        end,
    },


    -- Instantly heals the caster for 263 to 325.
    desperate_prayer = {
        id = 19236,
        cast = 0,
        cooldown = 120,
        gcd = "spell",

        spend = 0.21,
        spendType = "mana",

        talent = "desperate_prayer",
        startsCombat = false,
        texture = 135954,

        toggle = "defensives",

        handler = function ()
            -- 即时自我治疗，无需状态变化
        end,
    },


    -- Afflicts the target with a disease that causes 152 Shadow damage over 24 sec. 15% of damage caused by the Devouring Plague heals the caster. This spell can only affect one target at a time.
    devouring_plague = {
        id = 2944,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.25,
        spendType = "mana",

        startsCombat = true,
        texture = 252997,

        -- 噬灵瘟疫在暗影形态下才能享受急速和暴击加成
        -- 添加暗影形态建议检查 BY YaBi 20260118
        usable = function()
            if not buff.shadowform.up then
                return true, "建议在暗影形态下使用以获得急速和暴击加成"
            end
            return true
        end,

        handler = function ()
            if talent.shadow_weaving.rank == 3 then
                addStack( "shadow_weaving" )
            end
            applyDebuff( "target", "devouring_plague" )
        end,

        copy = { 19276, 19277, 19278, 19279, 19280, 25467, 48299, 48300 },
    },


    -- Dispels magic on the target, removing 1 harmful spell from a friend or 1 beneficial spell from an enemy.
    dispel_magic = {
        id = 527,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.14,
        spendType = "mana",

        startsCombat = true,
        texture = 135894,
        buff = "dispellable_magic",

        handler = function ()
            if glyph.dispel_magic.enabled then health.current = min( health.max, health.current + 0.03 * health.max ) end
            removeBuff( "dispellable_magic" )
        end,

        copy = { 988 },
    },


    -- You disperse into pure Shadow energy, reducing all damage taken by 90%.  You are unable to attack or cast spells, but you regenerate 6% mana every 1 sec for 6 sec. Dispersion can be cast while stunned, feared or silenced and clears all snare and movement impairing effects when cast, and makes you immune to them while dispersed.
    dispersion = {
        id = 47585,
        cast = 0,
        cooldown = function() return glyph.dispersion.enabled and 75 or 120 end,
        gcd = "spell",

        talent = "dispersion",
        startsCombat = false,
        texture = 237563,

        toggle = "defensives",

        handler = function ()
            applyBuff( "dispersion" )
        end,
    },


    -- Heals 3 nearby lowest health friendly party or raid targets within 40 yards for 3024 to 3342 every 2 sec for 8 sec, and increases healing done to them by 10% for 8 sec. Maximum of 12 heals. The Priest must channel to maintain the spell.
    divine_hymn = {
        id = 64843,
        cast = 0,
        cooldown = 480,
        gcd = "spell",

        spend = 0.63,
        spendType = "mana",

        startsCombat = false,
        texture = 237540,

        toggle = "cooldowns",

        handler = function ()
            -- 神圣赞美诗，引导治疗
        end,
    },


    -- Holy power infuses the target, increasing their Spirit by 17 for 30 min.
    divine_spirit = {
        id = 14752,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.26,
        spendType = "mana",

        startsCombat = false,
        texture = 135898,

        handler = function ()
            applyBuff( "divine_spirit" )
        end,

        copy = { 14818, 14819, 27841, 25312, 48073 },
    },


    -- Fade out, temporarily reducing all your threat for 10 sec.
    fade = {
        id = 586,
        cast = 0,
        cooldown = function() return glyph.fade.enabled and 21 or 30 end,
        gcd = "spell",

        spend = function() return glyph.fading.enabled and 0.105 or 0.15 end,
        spendType = "mana",

        startsCombat = false,
        texture = 135994,

        handler = function ()
            applyBuff( "fade" )
        end,
    },


    -- Wards the friendly target against Fear.  The next Fear effect used against the target will fail, using up the ward.  Lasts 3 min.
    fear_ward = {
        id = 6346,
        cast = 0,
        cooldown = function() return glyph.fear_ward.enabled and 120 or 180 end,
        gcd = "spell",

        spend = 0.03,
        spendType = "mana",

        startsCombat = false,
        texture = 135902,

        toggle = "defensives",

        handler = function ()
            applyBuff( "fear_ward" )
        end,
    },


    -- Heals a friendly target for 202 to 247.
    flash_heal = {
        id = 2061,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",

        spend = function() return glyph.flash_heal.enabled and 0.162 or 0.18 end,
        spendType = "mana",

        startsCombat = false,
        texture = 135907,

        handler = function ()
            -- 快速治疗，无需状态变化
        end,

        copy = { 9472, 9473, 9474, 10915, 10916, 10917, 25233, 25235, 48070, 48071 },
    },


    -- A slow casting spell that heals a single target for 924 to 1039.
    greater_heal = {
        id = 2060,
        cast = 3,
        cooldown = 0,
        gcd = "spell",

        spend = 0.32,
        spendType = "mana",

        startsCombat = false,
        texture = 135913,

        handler = function ()
            -- 强效治疗术，无需状态变化
        end,

        copy = { 10963, 10964, 10965, 25314, 25210, 25213, 48062, 48063 },
    },


    -- Calls upon a guardian spirit to watch over the friendly target. The spirit increases the healing received by the target by 40%, and also prevents the target from dying by sacrificing itself.  This sacrifice terminates the effect but heals the target of 50% of their maximum health. Lasts 10 sec.
    guardian_spirit = {
        id = 47788,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        spend = 0.06,
        spendType = "mana",

        talent = "guardian_spirit",
        startsCombat = false,
        texture = 237542,

        toggle = "defensives",

        handler = function ()
            applyBuff( "guardian_spirit" )
        end,
    },


    -- Heal your target for 307 to 353.
    heal = {
        id = 2054,
        cast = 3,
        cooldown = 0,
        gcd = "spell",

        spend = 0.32,
        spendType = "mana",

        startsCombat = false,
        texture = 135915,

        handler = function ()
            -- 治疗术，无需状态变化
        end,

        copy = { 2055, 6063, 6064 },
    },


    -- Consumes the enemy in Holy flames that cause 108 to 134 Holy damage and an additional 21 Holy damage over 7 sec.
    holy_fire = {
        id = 14914,
        cast = 2,
        cooldown = 10,
        gcd = "spell",

        spend = 0.11,
        spendType = "mana",

        startsCombat = true,
        texture = 135972,

        handler = function ()
            applyDebuff( "target", "holy_fire" )
        end,

        copy = { 15262, 15263, 15264, 15265, 15266, 15267, 15261, 25384, 48134, 48135 },
    },


    -- Causes an explosion of holy light around the caster, causing 29 to 34 Holy damage to all enemy targets within 10 yards and healing all party members within 10 yards for 54 to 63.  These effects cause no threat.
    holy_nova = {
        id = 15237,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.2,
        spendType = "mana",

        startsCombat = true,
        texture = 135922,

        handler = function ()
            -- 神圣新星，AOE伤害和治疗
        end,

        copy = { 15430, 15431, 27799, 27800, 27801, 25331, 48077, 48078 },
    },


    -- Restores 3% mana to 3 nearby low mana friendly party or raid targets every 2 sec for 8 sec, and increases their total maximum mana by 20% for 8 sec. Maximum of 12 mana restores. The Priest must channel to maintain the spell.
    hymn_of_hope = {
        id = 64901,
        cast = function() return glyph.hymn_of_hope.enabled and 10 or 8 end,
        channeled = true,
        cooldown = 360,
        gcd = "spell",

        startsCombat = false,
        texture = 135982,

        toggle = "cooldowns",

        handler = function ()
            -- 希望圣歌，引导恢复法力
        end,
    },


    -- A burst of Holy energy fills the caster, increasing armor by 315.  Each melee or ranged damage hit against the priest will remove one charge.  Lasts 30 min or until 20 charges are used.
    inner_fire = {
        id = 588,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.14,
        spendType = "mana",

        startsCombat = false,
        texture = 135926,

        handler = function ()
            applyBuff( "inner_fire", nil, 20 + ( talent.inner_fire.rank * 4 ) )
        end,

        copy = { 7128, 602, 1006, 10951, 10952, 25431, 48040, 48168 },
    },


    -- When activated, reduces the mana cost of your next spell by 100% and increases its critical effect chance by 25% if it is capable of a critical effect.
    inner_focus = {
        id = 14751,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        talent = "inner_focus",
        startsCombat = false,
        texture = 135863,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "inner_focus" )
        end,
    },


    -- Heal your target for 47 to 58.
    lesser_heal = {
        id = 2050,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",

        spend = 0.16,
        spendType = "mana",

        startsCombat = false,
        texture = 135929,

        handler = function ()
            -- 次级治疗术，无需状态变化
        end,

        copy = { 2052, 2053 },
    },


    -- Allows the friendly party or raid target to levitate, floating a few feet above the ground.  While levitating, the target will fall at a reduced speed and travel over water.  Any damage will cancel the effect.  Lasts 2 min.
    levitate = {
        id = 1706,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.03,
        spendType = "mana",

        startsCombat = false,
        texture = 135928,

        handler = function ()
            -- TODO: glyph.levitate.enabled removes reagent requirement.
        end,
    },


    -- Creates a Holy Lightwell.  Friendly players can click the Lightwell to restore 801 health over 6 sec.  Attacks done to you equal to 30% of your total health will cancel the effect. Lightwell lasts for 3 min or 10 charges.
    lightwell = {
        id = 724,
        cast = 0.5,
        cooldown = 180,
        gcd = "spell",

        spend = 0.17,
        spendType = "mana",

        talent = "lightwell",
        startsCombat = false,
        texture = 135980,

        toggle = "cooldowns",

        handler = function ()
            -- 召唤光明之泉
        end,
    },


    -- Destroy 10% of the target's mana (up to a maximum of 20% of your own maximum mana). For each mana destroyed in this way, the target takes 0.5 Shadow damage.
    mana_burn = {
        id = 8129,
        cast = 3,
        cooldown = 0,
        gcd = "spell",

        spend = 0.14,
        spendType = "mana",

        startsCombat = true,
        texture = 136170,

        handler = function ()
            -- 法力燃烧，消耗目标法力
        end,
    },


    -- Dispels magic in a 15 yard radius, removing 1 harmful spell from each friendly target and 1 beneficial spell from each enemy target.  Affects a maximum of 10 friendly targets and 10 enemy targets.  This dispel is potent enough to remove Magic effects that are normally undispellable.
    mass_dispel = {
        id = 32375,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",

        spend = function() return 0.33 * ( glyph.mass_dispel.enabled and 0.65 or 1 ) end,
        spendType = "mana",

        startsCombat = false,
        texture = 135739,

        handler = function ()
            -- 群体驱散
        end,
    },


    -- Blasts the target for 42 to 46 Shadow damage.
    mind_blast = {
        id = 8092,
        cast = function() return 1.5 * haste end,
        cooldown = function() return 8 - ( 0.5 * talent.improved_mind_blast.rank ) end,
        gcd = "spell",

        spend = function() return 0.17 * ( set_bonus.tier7_2pc == 1 and 0.90 or 1 ) end,
        spendType = "mana",

        startsCombat = true,
        texture = 136224,

        handler = function ()
            if talent.shadow_weaving.rank == 3 then
                addStack( "shadow_weaving" )
            end
        end,

        copy = { 8102, 8103, 8104, 8105, 8106, 10945, 10946, 10947, 25372, 25375, 48126, 48127 },
    },


    -- Controls a humanoid mind up to level 82, but increases the time between its attacks by 25%.  Lasts up to 1 min.
    mind_control = {
        id = 605,
        cast = 3,
        cooldown = 0,
        gcd = "spell",

        spend = 0.12,
        spendType = "mana",

        startsCombat = true,
        texture = 136206,

        handler = function ()
            -- 精神控制，控制人形生物
            applyDebuff( "target", "mind_control" )
        end,
    },

    -- Mind Flay: Assault the target's mind with Shadow energy, causing 45 Shadow damage over 3 sec and slowing their movement speed by 50%.
    mind_flay = {
        id = 15407,
        cast = function () return class.auras.mind_flay.duration end,
        channeled = true,
        breakable = true,
        cooldown = 0,
        gcd = "spell",

        spend = 0.09,
        spendType = "mana",

        talent = "mind_flay",
        startsCombat = true,
        texture = 136208,

        aura = "mind_flay",
        tick_time = function () return class.auras.mind_flay.tick_time end,

        -- 精神鞭笞是暗影天赋核心技能，建议在暗影形态下使用
        -- 添加暗影形态建议检查 BY YaBi 20260118
        usable = function()
            if not buff.shadowform.up then
                return true, "建议在暗影形态下使用以获得急速加成"
            end
            return true
        end,

        start = function ()
            applyDebuff( "target", "mind_flay" )
            if talent.pain_and_suffering.rank == 3 then
                applyDebuff( "shadow_word_pain" )
            end
        end,

        tick = function ()
            if talent.shadow_weaving.rank == 3 then
                addStack( "shadow_weaving" )
            end
        end,

        breakchannel = function ()
            removeDebuff( "target", "mind_flay" )
        end,

        handler = function ()
            -- 精神鞭笞引导结束
        end,

        copy = { 17311, 17312, 17313, 17314, 18807, 25387, 48155, 48156 }
    },


    -- Causes an explosion of shadow magic around the enemy target, causing 183 to 197 Shadow damage every 1 sec for 5 sec to all enemies within 10 yards around the target.
    mind_sear = {
        id = 48045,
        cast = function() return 5 * spell_haste end,
        channeled = true,
        breakable = true,
        cooldown = 0,
        gcd = "spell",

        spend = 0.28,
        spendType = "mana",

        startsCombat = true,
        texture = 237565,

        aura = "mind_sear",
        tick_time = function () return class.auras.mind_sear.tick_time end,

        -- 精神灼烧是暗影AOE技能，建议在暗影形态下使用
        -- 添加暗影形态建议检查 BY YaBi 20260118
        usable = function()
            if not buff.shadowform.up then
                return true, "建议在暗影形态下使用以获得伤害加成"
            end
            return true
        end,

        start = function ()
            applyDebuff( "target", "mind_sear" )
        end,

        tick = function ()
            if talent.shadow_weaving.rank == 3 then
                addStack( "shadow_weaving" )
            end
        end,

        breakchannel = function ()
            removeDebuff( "target", "mind_sear" )
        end,

        handler = function ()
            -- 精神灼烧引导结束
        end,

        copy = { 53023 },
    },


    -- Soothes the target, reducing the range at which it will attack you by 10 yards.  Only affects Humanoid targets.  Lasts 15 sec.
    mind_soothe = {
        id = 453,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.06,
        spendType = "mana",

        startsCombat = false,
        texture = 135933,

        handler = function ()
            -- 安抚心灵，减少敌人攻击范围
            applyDebuff( "target", "mind_soothe" )
        end,
    },


    -- Allows the caster to see through the target's eyes for 1 min.
    mind_vision = {
        id = 2096,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.03,
        spendType = "mana",

        startsCombat = false,
        texture = 135934,

        handler = function ()
            -- 心灵视界，查看目标视野
            applyBuff( "mind_vision" )
        end,

        copy = { 10909 },
    },


    -- Instantly reduces a friendly target's threat by 5%, reduces all damage taken by 40% and increases resistance to Dispel mechanics by 65% for 8 sec.
    pain_suppression = {
        id = 33206,
        cast = 0,
        cooldown = 180,
        gcd = "spell",

        spend = 0.08,
        spendType = "mana",

        talent = "pain_suppression",
        startsCombat = false,
        texture = 135936,

        toggle = "defensives",

        handler = function ()
            applyBuff( "pain_suppression" )
        end,
    },


    -- Launches a volley of holy light at the target, causing 240 Holy damage to an enemy, or 670 to 756 healing to an ally instantly and every 1 sec for 2 sec.
    penance = {
        id = 47540,
        cast = function() return 2 * haste end,
        channeled = true,
        cooldown = function() return glyph.penance.enabled and 10 or 12 end,
        gcd = "spell",

        spend = 0.16,
        spendType = "mana",

        talent = "penance",
        startsCombat = true,
        texture = 237545,

        start = function ()
            applyDebuff( "target", "penance" )
        end,
    },


    -- Infuses the target with power, increasing spell casting speed by 20% and reducing the mana cost of all spells by 20%.  Lasts 15 sec.
    power_infusion = {
        id = 10060,
        cast = 0,
        cooldown = 120,
        gcd = "off",

        spend = 0.16,
        spendType = "mana",

        talent = "power_infusion",
        startsCombat = false,
        texture = 135939,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "power_infusion" )
        end,
    },


    -- Power infuses the target, increasing their Stamina by 3 for 30 min.
    power_word_fortitude = {
        id = 1243,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return glyph.fortitude.enabled and 0.135 or 0.27 end,
        spendType = "mana",

        startsCombat = false,
        texture = 135987,

        handler = function ()
            applyBuff( "power_word_fortitude" )
        end,

        copy = { 1244, 1245, 2791, 10937, 10938, 25389, 48161 },
    },


    -- Draws on the soul of the friendly target to shield them, absorbing 48 damage.  Lasts 30 sec.  While the shield holds, spellcasting will not be interrupted by damage.  Once shielded, the target cannot be shielded again for 15 sec.
    power_word_shield = {
        id = 17,
        cast = 0,
        cooldown = 4,
        gcd = "spell",

        spend = 0.23,
        spendType = "mana",

        startsCombat = false,
        texture = 135940,

        handler = function ()
            -- if glyph.power_word_shield.enabled then health.current = min( health.max, health.current + some_amount_of_healing ) end
            applyBuff( "power_word_shield" )
            applyDebuff( "player", "weakened_soul" )
        end,

        copy = { 592, 600, 3747, 6065, 6066, 10898, 10899, 10900, 10901, 25217, 25218, 48065, 48066 },
    },


    -- Power infuses all party and raid members, increasing their Stamina by 43 for 1 |4hour:hrs;.
    prayer_of_fortitude = {
        id = 21562,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return glyph.fortitude.enabled and 0.345 or 0.69 end,
        spendType = "mana",

        startsCombat = false,
        texture = 135941,

        handler = function ()
            applyBuff( "prayer_of_fortitude" )
        end,

        copy = { 21564, 25392, 48162 },
    },


    -- A powerful prayer heals the friendly target's party members within 30 yards for 312 to 333.
    prayer_of_healing = {
        id = 596,
        cast = 3,
        cooldown = 0,
        gcd = "spell",

        spend = 0.48,
        spendType = "mana",

        startsCombat = false,
        texture = 135943,

        handler = function ()
            -- 治疗祷言，群体治疗
        end,

        copy = { 996, 10960, 10961, 25316, 25308, 48072 },
    },


    -- Places a spell on the target that heals them for 800 the next time they take damage.  When the heal occurs, Prayer of Mending jumps to a party or raid member within 20 yards.  Jumps up to 5 times and lasts 30 sec after each jump.  This spell can only be placed on one target at a time.
    prayer_of_mending = {
        id = 33076,
        cast = 0,
        cooldown = 10,
        gcd = "spell",

        spend = 0.15,
        spendType = "mana",

        startsCombat = false,
        texture = 135944,

        handler = function ()
            -- 愈合祷言，跳跃治疗
            applyBuff( "prayer_of_mending" )
        end,

        copy = { 48112, 48113 },
    },


    -- Power infuses the target's party and raid members, increasing their Shadow resistance by 60 for 20 min.
    prayer_of_shadow_protection = {
        id = 27683,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.62,
        spendType = "mana",

        startsCombat = false,
        texture = 135945,

        handler = function ()
            applyBuff( "prayer_of_shadow_protection" )
        end,

        copy = { 39374, 48170 },
    },


    -- Power infuses the target's party and raid members, increasing their Spirit by 40 for 1 |4hour:hrs;.
    prayer_of_spirit = {
        id = 27681,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.69,
        spendType = "mana",

        startsCombat = false,
        texture = 135946,

        handler = function ()
            applyBuff( "prayer_of_spirit" )
        end,

        copy = { 32999, 48074 },
    },


    -- You terrify the target, causing them to tremble in horror for 3 sec and drop their main hand and ranged weapons for 10 sec.
    psychic_horror = {
        id = 64044,
        cast = 0,
        cooldown = 120,
        gcd = "spell",

        spend = 0.16,
        spendType = "mana",

        talent = "psychic_horror",
        startsCombat = true,
        texture = 237568,

        toggle = "interrupts",

        handler = function ()
            -- 心灵恐慌，恐惧并缴械目标
            applyDebuff( "target", "psychic_horror" )
        end,
    },


    -- The caster lets out a psychic scream, causing 2 enemies within 8 yards to flee for 8 sec.  Damage caused may interrupt the effect.
    psychic_scream = {
        id = 8122,
        cast = 0,
        cooldown = function() return glyph.psychic_scream.enabled and 22 or 30 end,
        gcd = "spell",

        spend = 0.15,
        spendType = "mana",

        startsCombat = true,
        texture = 136184,
        toggle = "interrupts",

        handler = function ()
            -- 心灵尖啸，AOE 恐惧
            applyDebuff( "target", "psychic_scream" )
        end,

        copy = { 8124, 10888, 10890 },
    },


    -- Heals the target for 45 over 15 sec.
    renew = {
        id = 139,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.17,
        spendType = "mana",

        startsCombat = false,
        texture = 135953,

        handler = function ()
            -- 恢复，HOT 治疗
            applyBuff( "renew" )
        end,

        copy = { 6074, 6075, 6076, 6077, 6078, 10927, 10928, 10929, 25315, 25221, 25222, 48067, 48068 },
    },


    -- Brings a dead player back to life with 70 health and 135 mana.  Cannot be cast when in combat.
    resurrection = {
        id = 2006,
        cast = 10,
        cooldown = 0,
        gcd = "spell",

        spend = 0.6,
        spendType = "mana",

        startsCombat = false,
        texture = 135955,

        handler = function ()
            -- 复活术，复活死亡玩家，非战斗技能
        end,

        copy = { 2010, 10880, 10881, 20770, 25435, 48171 },
    },


    -- Shackles the target undead enemy for up to 30 sec.  The shackled unit is unable to move, attack or cast spells.  Any damage caused will release the target.  Only one target can be shackled at a time.
    shackle_undead = {
        id = 9484,
        cast = function() return glyph.scourge_imprisonment.enabled and 0.5 or 1.5 end,
        cooldown = 0,
        gcd = "spell",

        spend = 0.09,
        spendType = "mana",

        startsCombat = false,
        texture = 136091,
        toggle = "interrupts",

        handler = function ()
            -- 束缚亡灵，控制亡灵目标
            applyDebuff( "target", "shackle_undead" )
        end,

        copy = { 9485, 10955 },
    },


    -- Increases the target's resistance to Shadow spells by 30 for 10 min.
    shadowfiend = {
        id = 34433,
        cast = 0,
        cooldown = 180,
        gcd = "spell",

        spend = 0,
        spendType = "mana",

        startsCombat = true,
        texture = 136199,
        toggle = "cooldowns",

        handler = function ()
            applyBuff( "shadowfiend" )
        end,

        copy = {},
    },


    -- Increases the target's resistance to Shadow spells by 30 for 10 min.
    shadow_protection = {
        id = 976,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.31,
        spendType = "mana",

        startsCombat = false,
        texture = 136121,

        handler = function ()
            applyBuff( "shadow_protection" )
        end,

        copy = { 10957, 10958, 25433, 48169 },
    },


    -- A word of dark binding that inflicts 450 to 522 Shadow damage to the target.  If the target is not killed by Shadow Word: Death, the caster takes damage equal to the damage inflicted upon the target.
    shadow_word_death = {
        id = 32379,
        cast = 0,
        cooldown = 12,
        gcd = "spell",

        spend = 0.12,
        spendType = "mana",

        startsCombat = true,
        texture = 136149,

        handler = function ()
            -- 暗言术：灭，对目标造成伤害，如果目标未死则反噬自己
        end,

        copy = { 32996, 48157, 48158 },
    },


    -- A word of darkness that causes 30 Shadow damage over 18 sec.
    shadow_word_pain = {
        id = 589,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.22,
        spendType = "mana",

        startsCombat = true,
        texture = 136207,

        handler = function ()
            applyDebuff( "target", "shadow_word_pain" )
        end,

        copy = { 594, 970, 992, 2767, 10892, 10893, 10894, 25367, 25368, 48124, 48125 },
    },


    -- Assume a Shadowform, increasing your Shadow damage by 15%, reducing all damage done to you by 15% and threat generated by 30%.  However, you may not cast Holy spells while in this form except Cure Disease and Abolish Disease.  Grants the periodic damage from your Shadow Word: Pain, Devouring Plague, and Vampiric Touch spells the ability to critically hit for 100% increased damage and grants Devouring Plague and Vampiric Touch the ability to benefit from haste.
    shadowform = {
        id = 15473,
        cast = 0,
        cooldown = 1.5,
        gcd = "spell",

        spend = 0.13,
        spendType = "mana",

        talent = "shadowform",
        startsCombat = false,
        texture = 136200,

        handler = function ()
            applyBuff( "shadowform" )
        end,
    },


    -- Silences the target, preventing them from casting spells for 5 sec.  Non-player victim spellcasting is also interrupted for 3 sec.
    silence = {
        id = 15487,
        cast = 0,
        cooldown = 45,
        gcd = "off",

        spend = 225,
        spendType = "mana",

        talent = "silence",
        startsCombat = true,
        texture = 136164,
        toggle = "interrupts",

        readyTime = state.timeToInterrupt,

        handler = function ()
            interrupt()
            applyDebuff( "target", "silence" )
        end,
    },


    -- Smite an enemy for 15 to 20 Holy damage.
    smite = {
        id = 585,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",

        spend = 0.09,
        spendType = "mana",

        startsCombat = false,
        texture = 135924,

        handler = function ()
            -- 惩击，神圣伤害技能
        end,

        copy = { 591, 598, 984, 1004, 6060, 10933, 10934, 25363, 25364, 48122, 48123 },
    },


    -- Fills you with the embrace of Shadow energy, causing you to be healed for 15% and other party members to be healed for 3% of any single-target Shadow spell damage you deal for 30 min.
    vampiric_embrace = {
        id = 15286,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        talent = "vampiric_embrace",
        startsCombat = false,
        texture = 136230,
        essential = true,

        handler = function ()
            applyBuff( "vampiric_embrace" )
        end,
    },


    -- 吸血鬼之触Causes 450 Shadow damage over 15 sec to your target and causes up to 10 party or raid members to gain 1% of their maximum mana per 5 sec when you deal damage from Mind Blast. In addition, if the Vampiric Touch is dispelled it will cause 720 damage to the afflicted target.
    vampiric_touch = {
        id = 34914,
        cast = function() return 1.5 * haste end,
        cooldown = 0,
        gcd = "spell",

        spend = 0.16,
        spendType = "mana",

        talent = "vampiric_touch",
        startsCombat = true,
        texture = 135978,

        -- 吸血鬼之触在暗影形态下才能享受急速和暴击加成
        -- 添加暗影形态建议检查 BY YaBi 20260118
        usable = function()
            if not buff.shadowform.up then
                return true, "建议在暗影形态下使用以获得急速和暴击加成"
            end
            return true
        end,

        handler = function ()
            if talent.shadow_weaving.rank == 3 then
                addStack( "shadow_weaving" )
            end
            applyDebuff( "target", "vampiric_touch" )
        end,

        copy = { 34914, 34916, 34917, 48159, 48160 }, --添加高等级技能，by风雪 20250731

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

-- Hooks
spec:RegisterHook( "reset_precast", function ()
end )

-- Expressions
spec:RegisterStateExpr( "flay_over_blast", function()
    local currentSP = GetSpellBonusDamage( 6 ) or 0
    -- 使用 APIWrapper 获取法术信息
    local APIWrapper = ns.APIWrapper or (Hekili and Hekili.APIWrapper)
    local vttimer = 1500
    if APIWrapper and APIWrapper.GetSpellInfo then
        local spellInfo = APIWrapper.GetSpellInfo( 48160 )
        vttimer = spellInfo and spellInfo.castTime or 1500
    elseif GetSpellInfo then
        vttimer = select( 4, GetSpellInfo( 48160 ) ) or 1500
    end
    vttimer = vttimer / 1000
    local currHaste = ( ( 1.5 / vttimer ) - 1 ) * 100
    local latency = select( 4, GetNetStats() ) / 1000
    
    if set_bonus.tier10_4pc then
        -- Linelo maffs for 4pc T10 with 10ms MF clip delays
        if (currHaste > 102.68 and currentSP > 1500) or (currentSP > 5493.3 and currHaste < 50) or
        (currentSP > 5.0219e-04*currHaste^4 - 1.7950e-01*currHaste^3 + 2.4578e+01*currHaste^2 - 1.5651e+03*currHaste^1 + 4.1580e+04) then
            return false
        end
    else
        --Linelo maffs w/o 4pc T10
        if currentSP >= (-1.0038e-02*latency^2 + 1.7241e-03*latency + 1.1564e-04)*currHaste^4 
        +  (4.928100*latency^2 - 0.908961*latency - 0.063893)*currHaste^3
        +  (-878.800*latency^2 + 177.068*latency + 13.641)*currHaste^2
        +  (6.6990e+04*latency^2 - 1.5253e+04*latency - 1.3489e+03)*currHaste^1
        +  (-1.8099e+06*latency^2 + 5.0044e+05*latency + 5.3978e+04) then
            return false
        end
    end
    
    return true
end )


-- Options
spec:RegisterOptions( {
    enabled = true,

    aoe = 2,

    gcd = 1243,

    nameplates = true,
    nameplateRange = 40,

    damage = true,
    damageExpiration = 3,

    potion = "wild_magic",

    package = "Shadow",
    package1 = "Shadow",
    -- package2 = "",
    -- package3 = "",
} )


-- Packs
spec:RegisterPack( "暗影(黑科研)", 20260110, [[Hekili:vNvBVTT1v4FlgfqqgXrHsQ2oRq0aBadylFiBaAFMu0KxzreksbskNAadcVfKy5KL0eSMy3fN0eG060204(YAqQtC8pMjkk)VyN7LVtEVusPjROffjku3Zl3ZlpNNdLqvH)MqtfjBKWfRXvBjUQv5QWvLBjU6cnT3OhsOzpj5ljTg8bDPUWFo6NUX4dVl(XBOziPGf3YOVPm8vN(Q74DWDCV(99E0N69vVy0oBj0C1(QA2)zDHvZBf4)QwdKUhsw4Ilk0SJQIcY)KilzHMJp5Zg(YVE013A8voE4R3Z9Qd8o6GtV6n9o(5UF(rdp6w)j0Lu1uh9974(pVN3odCh8IHhV))DR)HZfCUWF1ufzz)roTA2rsX4YoToRtRr)7DDp(7925a3xoaRqIuoxy0p(DUp4lhT7l8(QJ825NDh8n4hJfW)qJ25gJ(X7cN7rV09KR4(MV27whck292VC8J360N96H)8ngFWx60Af4zF2Z8(7)K39(gVDVk5bGjh)0TgT)HFK3U3N8eVF4nEFXdp9HFR3ZEOVmNCfqMt3FBVbxtOPMQLTfjOQQVMgc(0fjPiKU0QAifH)GqtztvBKPQKqZ1LG)cECfB1UirBdrfvKtRg8oTKKTvn0R0vvxrSTM0gvu6BkHFKtRn30PvzNwDnwhSGtRsoTMZPLIHDff06qIeEOypnP16JQyI6kPQB50AEHM(keNAsFibBiLY0bxTF72vu11rMITnK7BvPFVihaBslsYr8YgMkI9aBfBYgoTQwzrI7v8bxH2T1wv(sI4GItRZ40sdk80L3i19i6S4lq9zmcdznUyv57BTvr6kyL9HmvgeNXowyyVm5)jHOWRhscNuQyzd9CoTGBMFeGHxaF)YWbMpkKwGUWhUEbkRrKUMp7nloQJVElY86HZtRl1TNQPQmO3(YDIZsjZcGPKLSSdYpfE9Qh7lP1m2twQOaDrf0fxnV8SwmWN9(azcCLLOX6qD)QAW35NHiPhtupnKUQvNUiD7u171ZxGseg7uNV4wm21pXkmrBiwJ)UmA0cqHBwCulDQMnCbgaIRsTytFzjvYTOkhnJgGfWQ05Sr93zorIG(8tOomzBxoWc5osqOrl87lYxW3SYtH)Wa0jkoWgsFUGYKGSLQjIGzwyxsvUCzzqoIHydnhAOOlbQ7QMsYZO5YknXOSHtNlCUdnGyW3HJz2VNTOAB4SugEucNiTwHVgXoSrAZAKKazkijBc(rv2qzzLNgorv24pDL0LQ0dbKI0T9lAwkrmtrfO8yAH)mwne8gkD9jun(yNp5XS6cMk9jSXEzBP(A204mekOSKMMO))qet1WNWHOp1ovD)Yt2fnDqsA2DQ0t22hXkb8YQaDlr83tIsg2bxV6jD7(wirqvDTYC5(WKhkq20NGKQWIB0UT4AYk4ByKeD2ahp7HqkWvtgPH8P6KrfStxy9SosePJ6cKgjJ3tODZ(6mJyYAaIl1PgtJ0bu8cH3lo52ZejB0DvjQPxQJdABy2Tc8365OQaFXuWBtrfAcqIw4gCBIIiadKVRNP0gqFPr7KFDYs8eIwmdlF1zCzqBK2tW5SvT7RGyAX0NizHtELumHSSiTK5MbKpzIPYg1Oai1IrmxAs1)2bnNus9g9WJrTtAaFGB8N0aOkY8veXXSnHXy4(tL(D7UrisFDoUisK2sMRHStI5tuyqbBYhtP(zYUsG6ZaJuJlPrqFmsUVnsSxhjlK)DpOnRWc)CnXaQ75ZaSAHKmlUW)xeZXSf5ugXjVbCxe9ddweqSzzOhmy5JftRIMltD(Aip0FvwYQWEU3InQY2XLRvYFLakb3jfVEVSYcLzn04HqwO6TWN)nYwKtMe5V9216Dl58SBGnvdsMbRrLBE2nWMXi(5a06W3zucKgAGV1za(wWYptLlK04uXyNfe1I3rA6wJGn3MPAnIc2IzwwJyrHPAnILMittB8EQMyAcaYZOb3296FU7HV29QFXWJU2IrVqw3b7o(XpL8Ywb913UJHPqt3)1DCV9JXCvnARIh7)bFGtRz4nXIp(0(2yjN99)BKf)UKjMAWEU7Ct3TVM7t225c(bqRkrKYpd)5I5wVGABEA8WPlxkUYrIMN8Dj2eVPRyA8HJ0ptg3zntg(4uTumUwK(ZXQUrvo6cNfMcRI5yc)X4MIFwyQ60xT34N)e3R)0HhVF05HtLD33fW8n5X8QdsX)WR8U3UJV5HJ(U)JFb3X3cxpT9NavJdp(eVp9PjvhLfEXUEm32g1xm55Jw(n5dd984NWyz2fsS8lF1KcKzdt)BLpJzS)KgAELjlQ)wP(He3BFlOE3VJNes8E8ZhEYdgT1RgT)oJ27nEp5OK6JGNeMgCh8a3dUb0X6(j7bXW4mhoItY7(G9(wnbI)cKLf4lZAPLsWclZV5M5xvzcMi1Ifbgj3cjnQXfEb(9)L)iCliGlXA2pWc6oAMgLGm)5PiqwWFsDEHVivggfpLBHume5RUqowJ8lVqYbH8fohK4l(tRkvUOvbAa7luQOdScVVttBpHZeWNEEk3Seu(XodnMaRWrrU0S3NUWsBE28(d9Xgrmokr1x4RZ8sehuMw3zUac9LkxMj5B(fz4ilVi0mWwoWtPkydqU5zOYQ0I0XCkyMG4JdALZWkFZnzZiVrDAvePhQmxEI3ZIZptdzMffNcgycbLZvRuytwwadAvtXn7ZwJ8Ksnb(WeQFj8BXQJ5PPbOX(WrSvjhlbZ2g8lXrzAtrfG0C9uJEU5D9U)Zh9OTZIE7pBJHVtTljpCw4VKo00fKmlefFEkwprMnnDPG0jO6)Fcch5xZiiCg5sG79RjMgf)lZqI35dakSSAkNXNU449poBK9su6LzXLSjlkcJ)fndJNSUJn45QuBblKCHNAckN(pOBPC15X)yULyNJBWxoqqw)eUrDje)UmBvD2jOOcI4)IMSLV2(D0KnAGuZ04NCJxOctWC8sH9sSp8B94fk9D0CDYBkb)Yre(Fp]] )

spec:RegisterPackSelector( "discipline", "none", "|T135987:0|t 暗影",
    "如果你在|T135987:0|t戒律天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    -- Criteria
    -- The pack selector hook passes the points spent in tab1 (Discipline), tab2 (Holy), and tab3 (Shadow).
    function( tab1, tab2, tab3 )
        -- If we spent the most points in Shadow, then swap to this package.
        -- We could also reference anything else we wanted; e.g., talent.shadowform.enabled or something else entirely.
        return tab1 > max( tab2, tab3 )
    end )


spec:RegisterPackSelector( "holy", "none", "|T237542:0|t 神圣",
    "如果你在|T237542:0|t神圣天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    -- Criteria
    -- The pack selector hook passes the points spent in tab1 (Discipline), tab2 (Holy), and tab3 (Shadow).
    function( tab1, tab2, tab3 )
        -- If we spent the most points in Shadow, then swap to this package.
        -- We could also reference anything else we wanted; e.g., talent.shadowform.enabled or something else entirely.
        return tab2 > max( tab1, tab3 )
    end )

spec:RegisterPackSelector( "shadow", "Shadow", "|T136207:0|t 暗影",
    "如果你在|T136207:0|t暗影天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    -- Criteria
    -- The pack selector hook passes the points spent in tab1 (Discipline), tab2 (Holy), and tab3 (Shadow).
    function( tab1, tab2, tab3 )
        -- If we spent the most points in Shadow, then swap to this package.
        -- We could also reference anything else we wanted; e.g., talent.shadowform.enabled or something else entirely.
        return tab3 > max( tab1, tab2 )
    end )

-- Settings
spec:RegisterSetting( "dots_in_aoe", false, {
    type = "toggle",
    name = "|T252997:0|t|T136207:0|t|T135978:0|t在AOE战斗中使用DOT",
    desc = "启用后，暗影天赋优先级将建议在引导|T237565:0|t心灵灼烧之前，对你的目标施放DOT伤害技能。",
    width = "full",
} )

spec:RegisterSetting( "optimize_mind_blast", false, {
    type = "toggle",
    name = "|T136224:0|t优化心灵震爆",
    desc = "启用后，暗影天赋优先级将在低于急速阈值时推荐使用|T136224:0|t心灵震爆（而不是|T136208:0|t精神鞭笞）。",
    width = "full",
} )

spec:RegisterSetting( "min_shadowfiend_mana", 25, {
    type = "range",
    name = "|T136199:0|t暗影魔法力阈值",
    desc = "如果设置大于零0，当你的法力低于该值时，插件才会推荐你使用|T136199:0|t暗影魔。",
    width = "full",
    min = 0,
    max = 100,
    step = 1,
} )


spec:RegisterPackSelector( "shadow_pvp", nil, "|T136207:0|t 暗影PVP",
    "PVP专用暗影天赋优先级，适用于战场和竞技场。",
    function( tab1, tab2, tab3 )
        return false
    end )
