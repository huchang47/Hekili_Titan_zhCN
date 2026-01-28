if UnitClassBase( 'player' ) ~= 'ROGUE' then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local spec = Hekili:NewSpecialization( 4 )


-- TODO:  Check gains from Cold Blood, Seal Fate; i.e., guaranteed crits.


spec:RegisterResource( Enum.PowerType.ComboPoints )
spec:RegisterResource( Enum.PowerType.Energy )

-- Talents
spec:RegisterTalents( {
    adrenaline_rush            = {   205, 1, 13750 },
    aggression                 = {  1122, 5, 18427, 18428, 18429, 61330, 61331 },
    blade_flurry               = {   223, 1, 13877 },
    blade_twisting             = {  1706, 2, 31124, 31126 },
    blood_spatter              = {  2068, 2, 51632, 51633 },
    camouflage                 = {   244, 3, 13975, 14062, 14063 },
    cheat_death                = {  1722, 3, 31228, 31229, 31230 },
    close_quarters_combat      = {   182, 5, 13706, 13804, 13805, 13806, 13807 },
    cold_blood                 = {   280, 1, 14177 },
    combat_potency             = {  1825, 5, 35541, 35550, 35551, 35552, 35553 },
    cut_to_the_chase           = {  2070, 5, 51664, 51665, 51667, 51668, 51669 },
    deadened_nerves            = {  1723, 3, 31380, 31382, 31383 },
    deadliness                 = {  1702, 5, 30902, 30903, 30904, 30905, 30906 },
    deadly_brew                = {  2065, 2, 51625, 51626 },
    deflection                 = {   187, 3, 13713, 13853, 13854 },
    dirty_deeds                = {   265, 2, 14082, 14083 },
    dirty_tricks               = {   262, 2, 14076, 14094 },
    dual_wield_specialization  = {   221, 5, 13715, 13848, 13849, 13851, 13852 },
    elusiveness                = {   247, 2, 13981, 14066 },
    endurance                  = {   204, 2, 13742, 13872 },
    enveloping_shadows         = {  1711, 3, 31211, 31212, 31213 },
    filthy_tricks              = {  2079, 2, 58414, 58415 },
    find_weakness              = {  1718, 3, 31234, 31235, 31236 },
    fleet_footed               = {  1721, 2, 31208, 31209 },
    focused_attacks            = {  2069, 3, 51634, 51635, 51636 },
    ghostly_strike             = {   303, 1, 14278 },
    hack_and_slash             = {   242, 5, 13960, 13961, 13962, 13963, 13964 },
    heightened_senses          = {  1701, 2, 30894, 30895 },
    hemorrhage                 = {   681, 1, 16511 },
    honor_among_thieves        = {  2078, 3, 51698, 51700, 51701 },
    hunger_for_blood           = {  2071, 1, 51662 },
    improved_ambush            = {   263, 2, 14079, 14080 },
    improved_eviscerate        = {   276, 3, 14162, 14163, 14164 },
    improved_expose_armor      = {   278, 2, 14168, 14169 },
    improved_gouge             = {   203, 3, 13741, 13793, 13792 },
    improved_kick              = {   206, 2, 13754, 13867 },
    improved_kidney_shot       = {   279, 3, 14174, 14175, 14176 },
    improved_poisons           = {   268, 5, 14113, 14114, 14115, 14116, 14117 },
    improved_sinister_strike   = {   201, 2, 13732, 13863 },
    improved_slice_and_dice    = {  1827, 2, 14165, 14166 },
    improved_sprint            = {   222, 2, 13743, 13875 },
    initiative                 = {   245, 3, 13976, 13979, 13980 },
    killing_spree              = {  2076, 1, 51690 },
    lethality                  = {   269, 5, 14128, 14132, 14135, 14136, 14137 },
    lightning_reflexes         = {   186, 3, 13712, 13788, 13789 },
    mace_specialization        = {   184, 5, 13709, 13800, 13801, 13802, 13803 },
    malice                     = {   270, 5, 14138, 14139, 14140, 14141, 14142 },
    master_of_deception        = {   241, 3, 13958, 13970, 13971 },
    master_of_subtlety         = {  1713, 3, 31221, 31222, 31223 },
    master_poisoner            = {  1715, 3, 31226, 31227, 58410 },
    murder                     = {   274, 2, 14158, 14159 },
    mutilate                   = {  1719, 1,  1329 },
    nerves_of_steel            = {  1707, 2, 31130, 31131 },
    opportunity                = {   261, 2, 14057, 14072 },
    overkill                   = {   281, 1, 58426 },
    precision                  = {   181, 5, 13705, 13832, 13843, 13844, 13845 },
    premeditation              = {   381, 1, 14183 },
    preparation                = {   284, 1, 14185 },
    prey_on_the_weak           = {  2075, 5, 51685, 51686, 51687, 51688, 51689 },
    puncturing_wounds          = {   277, 3, 13733, 13865, 13866 },
    quick_recovery             = {  1762, 2, 31244, 31245 },
    relentless_strikes         = {  2244, 5, 14179, 58422, 58423, 58424, 58425 },
    remorseless_attacks        = {   272, 2, 14144, 14148 },
    riposte                    = {   301, 1, 14251 },
    ruthlessness               = {   273, 3, 14156, 14160, 14161 },
    savage_combat              = {  2074, 2, 51682, 58413 },
    seal_fate                  = {   283, 5, 14186, 14190, 14193, 14194, 14195 },
    serrated_blades            = {  1123, 3, 14171, 14172, 14173 },
    setup                      = {   246, 3, 13983, 14070, 14071 },
    shadow_dance               = {  2081, 1, 51713 },
    shadowstep                 = {  1714, 1, 36554 },
    sinister_calling           = {  1712, 5, 31216, 31217, 31218, 31219, 31220 },
    slaughter_from_the_shadows = {  2080, 5, 51708, 51709, 51710, 51711, 51712 },
    sleight_of_hand            = {  1700, 2, 30892, 30893 },
    surprise_attacks           = {  1709, 1, 32601 },
    throwing_specialization    = {  2072, 2,  5952, 51679 },
    turn_the_tables            = {  2066, 3, 51627, 51628, 51629 },
    unfair_advantage           = {  2073, 2, 51672, 51674 },
    vigor                      = {   382, 1, 14983 },
    vile_poisons               = {   682, 3, 16513, 16514, 16515 },
    vitality                   = {  1705, 3, 31122, 31123, 61329 },
    waylay                     = {  2077, 2, 51692, 51696 },
    weapon_expertise           = {  1703, 2, 30919, 30920 },
} )


-- Glyphs
spec:RegisterGlyphs( {
    [56808] = "adrenaline_rush",
    [56813] = "ambush",
    [56800] = "backstab",
    [56818] = "blade_flurry",
    [58039] = "blurred_speed",
    [63269] = "cloak_of_shadows",
    [56820] = "crippling_poison",
    [56806] = "deadly_throw",
    [58032] = "distract",
    [64199] = "envenom",
    [56799] = "evasion",
    [56802] = "eviscerate",
    [56803] = "expose_armor",
    [63254] = "fan_of_knives",
    [56804] = "feint",
    [56812] = "garrote",
    [56814] = "ghostly_strike",
    [56809] = "gouge",
    [56807] = "hemorrhage",
    [63249] = "hunger_for_blood",
    [63252] = "killing_spree",
    [63268] = "mutilate",
    [58027] = "pick_lock",
    [58017] = "pick_pocket",
    [56819] = "preparation",
    [56801] = "rupture",
    [58033] = "safe_fall",
    [56798] = "sap",
    [63253] = "shadow_dance",
    [56821] = "sinister_strike",
    [56810] = "slice_and_dice",
    [56811] = "sprint",
    [63256] = "tricks_of_the_trade",
    [58038] = "vanish",
    [56805] = "vigor",
} )


-- Auras
spec:RegisterAuras( {
    -- Energy regeneration increased by $s1%.
    adrenaline_rush = {
        id = 13750,
        duration = function() return glyph.adrenaline_rush.enabled and 21 or 15 end,
        max_stack = 1,
    },
    -- Attack speed increased by $s1%.  Weapon attacks strike an additional nearby opponent.
    blade_flurry = {
        id = 13877,
        duration = 15,
        max_stack = 1,
    },
    -- Dazed.
    blade_twisting = {
        id = 51585,
        duration = 8,
        max_stack = 1,
        copy = { 51585, 31125 },
    },
    -- Disoriented.
    blind = {
        id = 2094,
        duration = 10,
        max_stack = 1,
    },
    -- Stunned.
    cheap_shot = {
        id = 1833,
        duration = 4,
        max_stack = 1,
    },
    cheating_death = {
        id = 45182,
        duration = 3,
        max_stack = 1,
    },
    -- Increases chance to resist spells by $s1%.
    cloak_of_shadows = {
        id = 31224,
        duration = 5,
        max_stack = 1,
    },
    -- Critical strike chance of your next offensive ability increased by $s1%.
    cold_blood = {
        id = 14177,
        duration = 3600,
        max_stack = 1,
    },
    deadly_poison = {
        id = 2818,
        duration = 12,
        max_stack = 5,
        copy = { 2819, 11353, 11354, 25349, 26968, 27187, 57970, 57969 },
    },
    -- Movement slowed by $s2%.
    deadly_throw = {
        id = 48674,
        duration = 6,
        max_stack = 1,
        copy = { 26679, 48673, 48674 },
    },
    -- Detecting traps.
    detect_traps = {
        id = 2836,
        duration = 3600,
        max_stack = 1,
    },
    -- Disarmed.
    dismantle = {
        id = 51722,
        duration = 10,
        max_stack = 1,
    },
    -- Chance to apply Deadly Poison increased by $s3% and frequency of applying Instant Poison increased by $s2%.
    envenom = {
        id = 57993,
        duration = 1,
        max_stack = 1,
        copy = { 32645, 32684, 57992, 57993 },
    },
    -- Dodge chance increased by $s1% and chance ranged attacks hit you reduced by $s2%.
    evasion = {
        id = 26669,
        duration = function() return glyph.evasion.enabled and 20 or 15 end,
        max_stack = 1,
        copy = { 5277, 26669, 67354, 67378, 67380 },
    },
    -- $s2% reduced damage taken from area of effect attacks.
    feint = {
        id = 48659,
        duration = 6,
        max_stack = 1,
        copy = { 48659 },
    },
    -- $s1 damage every $t1 seconds.
    garrote = {
        id = 48676,
        duration = function() return glyph.garrote.enabled and 21 or 18 end,
        tick_time = 3,
        max_stack = 1,
        copy = { 703, 8631, 8632, 8633, 8818, 11289, 11290, 26839, 26884, 48675, 48676, 1284409 },-- 圆圆bro添加锁喉新ID
    },
    -- Silenced.
    garrote_silence = {
        id = 1330,
        duration = 3,
        max_stack = 1,
    },
    -- Dodge chance increased by $s2%.
    ghostly_strike = {
        id = 14278,
        duration = function() return glyph.ghostly_strike.enabled and 11 or 7 end,
        max_stack = 1,
    },
    -- Incapacitated.
    gouge = {
        id = 1776,
        duration = function() return 4 + 0.5 * talent.improved_gouge.rank end,
        max_stack = 1,
    },
    -- Increases damage taken by $s3.
    hemorrhage = {
        id = 16511,
        duration = 15,
        max_stack = 1,
        copy = { 16511, 17347, 17348, 26864, 48660 },
    },
    hunger_for_blood = {
        id = 63848,
        duration = 60,
        max_stack = 1,
    },
    -- Stunned.
    kidney_shot = {
        id = 8643,
        duration = 1,
        max_stack = 1,
        copy = { 408, 8643, 27615, 30621 },
    },
    -- Attacking an enemy every $t1 sec.  Damage dealt increased by $61851s3%.
    killing_spree = {
        id = 51690,
        duration = 2,
        tick_time = 0.5,
        max_stack = 1,
    },
    master_of_subtlety = {
        id = 31665,
        duration = 6,
        max_stack = 1,
    },
    overkill = {
        id = 58427,
        duration = 20,
        max_stack = 1,
    },
    -- Critical strike chance for your next Sinister Strike, Backstab, Mutilate, Ambush, Hemorrhage, or Ghostly strike increased by $s1%.
    remorseless = {
        id = 14149,
        duration = 20,
        max_stack = 1,
        copy = { 14143, 14149 },
    },
    -- Melee attack speed slowed by $s2%.
    riposte = {
        id = 14251,
        duration = 30,
        max_stack = 1,
    },
    -- Causes damage every $t1 seconds.
    rupture = {
        id = 48672,
        duration = function() return ( glyph.rupture.enabled and 10 or 6 ) + ( 2 * combo_points.current ) end,
        tick_time = 2,
        max_stack = 1,
        copy = { 1943, 8639, 8640, 11273, 11274, 11275, 26867, 48671, 48672 },
    },
    -- Sapped.
    sap = {
        id = 51724,
        duration = function() return glyph.sap.enabled and 80 or 60 end,
        max_stack = 1,
        copy = { 2070, 6770, 11297, 51724 },
    },
    -- Increases physical damage taken by $s1%.
    savage_combat = {
        id = 58684,
        duration = 3600,
        max_stack = 1,
        copy = { 58683, 58684 },
    },
    -- Can use opening abilities without being stealthed.
    shadow_dance = {
        id = 51713,
        duration = function() return glyph.sap.enabled and 8 or 6 end,
        max_stack = 1,
    },
    shadowstep = {
        id = 36563,
        duration = 10,
        max_stack = 1,
    },
    shadowstep_sprint = {
        id = 36554,
        duration = 3,
        max_stack = 1,
    },
    -- Silenced.
    silenced_improved_kick = {
        id = 18425,
        duration = 2,
        max_stack = 1,
    },
    -- Melee attack speed increased by $s2%.
    slice_and_dice = {
        id = 6774,
        duration = function() return ( ( glyph.slice_and_dice.enabled and 9 or 6 ) + ( 3 * combo_points.current ) ) * ( 1 + 0.25 * talent.improved_slice_and_dice.rank ) end,
        max_stack = 1,
        copy = { 5171, 6434, 6774, 60847 },
    },
    -- Movement speed increased by $w1%.
    sprint = {
        id = 11305,
        duration = 15,
        max_stack = 1,
        copy = { 2983, 8696, 11305, 48594, 56354 },
    },
    -- Stealthed.  Movement slowed by $s3%.
    stealth = {
        id = 1784,
        duration = 3600,
        max_stack = 1,
    },
    -- $s1% increased critical strike chance with combo moves.
    turn_the_tables = {
        id = 52915,
        duration = 8,
        max_stack = 1,
        copy = { 52915, 52914, 52910 },
    },
    vanish = {
        id = 11327,
        duration = 10,
        max_stack = 1,
    },
    -- Time between melee and ranged attacks increased by $s1%.    Movement speed reduced by $s2%.
    waylay = {
        id = 51693,
        duration = 8,
        max_stack = 1,
    },
    -- $s1 damage every $t sec
    lacerate = {
        id = 48568,
        duration = 15,
        tick_time = 3,
        max_stack = 5,
        copy = { 33745, 48567, 48568 },
    },
    -- Bleeding for $s1 damage every $t1 seconds.
    pounce_bleed = {
        id = 49804,
        duration = 18,
        tick_time = 3,
        max_stack = 1,
        copy = { 9007, 9824, 9826, 27007, 49804 },
    },
    -- Bleeding for $s2 damage every $t2 seconds.
    rake = {
        id = 48574,
        duration = function() return 9 + ((set_bonus.tier9_2pc == 1 and 3) or 0) end,
        max_stack = 1,
        copy = { 1822, 1823, 1824, 9904, 27003, 48573, 48574, 59881, 59882, 59883, 59884, 59885, 59886 },
    },
    -- Bleed damage every $t1 seconds.
    rip = {
        id = 49800,
        duration = function() return 12 + ((glyph.rip.enabled and 4) or 0) + ((set_bonus.tier7_2pc == 1 and 4) or 0) end,
        tick_time = 2,
        max_stack = 1,
        copy = { 1079, 9492, 9493, 9752, 9894, 9896, 27008, 49799, 49800 },
    },
    rend = {
        id = 47465,
        duration = 15,
        max_stack = 1,
        shared = "target",
        copy = { 772, 6546, 6547, 6548, 11572, 11573, 11574, 25208 }
    },
    deep_wound = {
        id = 43104,
        duration = 12,
        max_stack = 1,
        shared = "target",
        copy = "deep_wounds"
    },
    bleed = {
        alias = { "lacerate", "pounce_bleed", "rip", "rake", "deep_wound", "rend", "garrote", "rupture" },
        aliasType = "debuff",
        aliasMode = "longest"
    },
    -- 狮心 - 人类种族技能buff
    lions_heart = {
        id = 20599,
        duration = 15,
        max_stack = 1,
    },
    -- 死亡印记 (泰坦时光服) - 标记目标，储存伤害
    marked_for_death = {
        id = 1284398,
        duration = 6,
        max_stack = 1,
    },
    -- 转嫁 (泰坦时光服) - 储存连击点数
    redirect = {
        id = 1282540,
        duration = 3600,
        max_stack = 5,
        copy = { 1282538, 1282540 }
    },
} )


spec:RegisterStateExpr( "cp_max_spend", function ()
    return combo_points.max
end )

-- 转嫁储存的连击点数
spec:RegisterStateExpr( "redirect_cp", function ()
    if buff.redirect.up then
        return buff.redirect.stack
    end
    return 0
end )

-- 是否有转嫁储存的连击点数
spec:RegisterStateExpr( "has_redirect_cp", function ()
    return buff.redirect.up and buff.redirect.stack > 0
end )


local stealth = {
    rogue   = { "stealth", "vanish", "shadow_dance" },
    mantle  = { "stealth", "vanish" },
    all     = { "stealth", "vanish", "shadow_dance", "shadowmeld" }
}

local enchant_ids = {
    [7] = "deadly",
    [8] = "deadly",
    [626] = "deadly",
    [627] = "deadly",
    [3771] = "deadly",
    [2630] = "deadly",
    [2642] = "deadly",
    [2643] = "deadly",
    [3770] = "deadly",
    [323] = "instant",
    [324] = "instant",
    [325] = "instant",
    [623] = "instant",
    [3769] = "instant",
    [624] = "instant",
    [625] = "instant",
    [2641] = "instant",
    [3768] = "instant",
    [2640] = "anesthetic",
    [3774] = "anesthetic",
    [703] = "wound",
    [704] = "wound",
    [705] = "wound",
    [706] = "wound",
    [2644] = "wound",
    [3772] = "wound",
    [3773] = "wound",
    [35] = "mind",
    [22] = "crippling",
}


spec:RegisterStateTable( "stealthed", setmetatable( {}, {
    __index = function( t, k )
        if k == "rogue" then
            return buff.stealth.up or buff.vanish.up or buff.shadow_dance.up
        elseif k == "rogue_remains" then
            return max( buff.stealth.remains, buff.vanish.remains, buff.shadow_dance.remains )

        elseif k == "mantle" then
            return buff.stealth.up or buff.vanish.up
        elseif k == "mantle_remains" then
            return max( buff.stealth.remains, buff.vanish.remains )

        elseif k == "all" then
            return buff.stealth.up or buff.vanish.up or buff.shadow_dance.up or buff.shadowmeld.up
        elseif k == "remains" or k == "all_remains" then
            return max( buff.stealth.remains, buff.vanish.remains, buff.shadow_dance.remains, buff.shadowmeld.remains )
        end

        return false
    end
} ) )


spec:RegisterHook( "spend", function( amt, resource )
    if resource == "combo_points" and amt * talent.relentless_strikes.rank * 4 >= 100 then
        gain( 25, "energy" )
    end
end )


-- We need to break stealth when we start combat from an ability.
spec:RegisterHook( "runHandler", function( action )
    local a = class.abilities[ action ]

    if stealthed.all and ( not a or a.startsCombat ) then
        if buff.stealth.up then
            setCooldown( "stealth", 10 )
            if talent.master_of_subtlety.enabled then applyBuff( "master_of_subtlety", 6 ) end
            if talent.overkill.enabled then applyBuff( "overkill", 20 ) end
        end

        removeBuff( "stealth" )
        removeBuff( "shadowmeld" )
        removeBuff( "vanish" )
    end

    if ( not a or a.startsCombat ) then
        if buff.cold_blood.up then removeBuff( "cold_blood" ) end
        if buff.shadowstep.up then removeBuff( "shadowstep" ) end
    end
end )


spec:RegisterHook( "reset_precast", function()
    if buff.killing_spree.up then setCooldown( "global_cooldown", max( gcd.remains, buff.killing_spree.remains ) ) end

    local mh, mh_expires, _, mh_id, oh, oh_expires, _, oh_id = GetWeaponEnchantInfo()

end )


-- Abilities
spec:RegisterAbilities( {
    -- Increases your Energy regeneration rate by 100% for 15 sec.
    adrenaline_rush = {
        id = 13750,
        cast = 0,
        cooldown = 180,
        gcd = "totem",

        talent = "adrenaline_rush",
        startsCombat = false,
        texture = 136206,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "adrenaline_rush" )
            energy.regen = energy.regen * 2
        end,
    },


    -- Ambush the target, causing 275% weapon damage plus 509 to the target.  Must be stealthed and behind the target.  Requires a dagger in the main hand.  Awards 2 combo points.
    ambush = {
        id = 8676,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function() return 60 - 4 * talent.slaughter_from_the_shadows.rank end,
        spendType = "energy",

        startsCombat = true,
        texture = 132282,

        usable = function() return stealthed.all, "must be in stealth" end,

        handler = function ()
            -- TODO: Use fail positioning from Burning Crusade.
            gain( talent.initiative.rank == 3 and 3 or 2, "combo_points" )
            removeBuff( "remorseless" )
            if talent.waylay.rank == 2 then applyDebuff( "target", "waylay" ) end
        end,

        copy = { 8676, 8724, 8725, 11267, 11268, 11269, 27441, 48689, 48690, 48691 },
    },


    -- Backstab the target, causing 150% weapon damage plus 255 to the target.  Must be behind the target.  Requires a dagger in the main hand.  Awards 1 combo point.
    backstab = {
        id = 53,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function() return 60 - 4 * talent.slaughter_from_the_shadows.rank end,
        spendType = "energy",

        startsCombat = true,
        texture = 132090,

        -- 背刺不需要潜行，只需要在目标背后 - 修复 by 哑吡 20260103
        -- usable = function() return stealthed.all, "must be in stealth" end,

        handler = function ()
            if glyph.backstab.enabled and debuff.rupture.up then debuff.rupture.expires = debuff.rupture.expires + 2 end
            gain( 1, "combo_points" )
            removeBuff( "remorseless" )
            if talent.waylay.rank == 2 then applyDebuff( "target", "waylay" ) end
        end,

        copy = { 53, 2589, 2590, 2591, 8721, 11279, 11280, 11281, 25300, 26863, 48656, 48657 },
    },


    -- Increases your attack speed by 20%.  In addition, attacks strike an additional nearby opponent.  Lasts 15 sec.
    blade_flurry = {
        id = 13877,
        cast = 0,
        cooldown = 120,
        gcd = "totem",

        spend = function() return glyph.blade_flurry.enabled and 0 or 25 end,
        spendType = "energy",

        talent = "blade_flurry",
        startsCombat = false,
        texture = 132350,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "blade_flurry" )
        end,
    },


    -- Blinds the target, causing it to wander disoriented for up to 10 sec.  Any damage caused will remove the effect.
    blind = {
        id = 2094,
        cast = 0,
        cooldown = function() return 180 - 30 * talent.elusiveness.rank end,
        gcd = "totem",

        spend = function() return 30 * ( 1 - 0.25 * talent.dirty_tricks.rank ) end,
        spendType = "energy",

        startsCombat = true,
        texture = 136175,

        toggle = "interrupts",

        handler = function ()
            applyDebuff( "target", "blind" )
        end,
    },


    -- Stuns the target for 4 sec.  Must be stealthed.  Awards 2 combo points.
    cheap_shot = {
        id = 1833,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function() return 60 - 10 * talent.dirty_deeds.rank end,
        spendType = "energy",

        startsCombat = true,
        texture = 132092,

        usable = function() return stealthed.all, "must be in stealth" end,

        handler = function ()
            applyDebuff( "tagret", "cheap_shot" )
            gain( talent.initiative.rank == 3 and 3 or 2, "combo_points" )
        end,
    },


    -- Instantly removes all existing harmful spell effects and increases your chance to resist all spells by 90% for 5 sec.  Does not remove effects that prevent you from using Cloak of Shadows.
    cloak_of_shadows = {
        id = 31224,
        cast = 0,
        cooldown = function() return 180 - 15 * talent.elusiveness.rank end,
        gcd = "totem",

        startsCombat = false,
        texture = 136177,

        toggle = "defensives",

        buff = "dispellable_magic",

        handler = function ()
            removeBuff( "dispellable_magic" )
            applyBuff( "cloak_of_shadows" )
        end,
    },


    -- When activated, increases the critical strike chance of your next offensive ability by 100%.
    cold_blood = {
        id = 14177,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        talent = "cold_blood",
        startsCombat = false,
        texture = 135988,

        toggle = "cooldowns",

        nobuff = "cold_blood",

        handler = function ()
            applyBuff( "cold_blood" )
        end,
    },


    -- Finishing move that reduces the movement of the target by 50% for 6 sec and causes increased thrown weapon damage:     1 point  : 223 - 245 damage     2 points: 365 - 387 damage     3 points: 507 - 529 damage     4 points: 649 - 671 damage     5 points: 791 - 813 damage
    deadly_throw = {
        id = 26679,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 35,
        spendType = "energy",

        startsCombat = true,
        texture = 135430,

        usable = function() return combo_points.current > 0, "requires combo_points" end,

        handler = function ()
            applyDebuff( "target", "deadly_throw" )
            spend( combo_points.current, "combo_points" )
            if talent.throwing_specialization.rank == 2 then interrupt() end
        end,

        copy = { 26679, 48673, 48674 },
    },


    -- Disarm the enemy, removing all weapons, shield or other equipment carried for 10 sec.
    dismantle = {
        id = 51722,
        cast = 0,
        cooldown = 60,
        gcd = "totem",

        spend = 25,
        spendType = "energy",

        startsCombat = true,
        texture = 236272,

        toggle = "cooldowns",

        handler = function ()
            applyDebuff( "target", "dismantle" )
        end,
    },


    -- Throws a distraction, attracting the attention of all nearby monsters for 10 seconds.  Does not break stealth.
    distract = {
        id = 1725,
        cast = 0,
        cooldown = function() return 30 - 5 * talent.filthy_tricks.rank end,
        gcd = "totem",

        spend = function() return 30 - 5 * talent.filthy_tricks.rank end,
        spendType = "energy",

        startsCombat = false,
        texture = 132289,

        handler = function ()
            -- 分散注意力，无需状态变化
        end,
    },


    -- Finishing move that consumes your Deadly Poison doses on the target and deals instant poison damage.  Following the Envenom attack you have an additional 15% chance to apply Deadly Poison and a 75% increased frequency of applying Instant Poison for 1 sec plus an additional 1 sec per combo point.  One dose is consumed for each combo point:    1 dose:  180 damage    2 doses: 361 damage    3 doses: 541 damage    4 doses: 722 damage    5 doses: 902 damage
    envenom = {
        id = 32645,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 35,
        spendType = "energy",

        startsCombat = true,
        texture = 132287,

        usable = function()
            if combo_points.current == 0 then
                return false, "requires combo_points"
            end

            if not debuff.deadly_poison.up then
                return false, "requires deadly_poison debuff"
            end

            return true
        end,

        handler = function ()
            if not ( glyph.envenom.enabled or talent.master_poisoner.rank == 3 ) then
                removeDebuffStack( "target", "deadly_poison", combo_points.current )
            end

            if talent.cut_to_the_chase.rank == 5 and buff.slice_and_dice.up then
                buff.slice_and_dice.expires = query_time + buff.slice_and_dice.duration
            end

            spend( combo_points.current, "combo_points" )
        end,

        copy = { 32645, 32684, 57992, 57993 },
    },


    -- Increases the rogue's dodge chance by 50% and reduces the chance ranged attacks hit the rogue by 25%.  Lasts 15 sec.
    evasion = {
        id = 5277,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        spend = 0,
        spendType = "energy",

        startsCombat = false,
        texture = 136205,

        toggle = "defensives",

        handler = function ()
            applyBuff( "evasion" )
        end,

        copy = { 5277, 26669 },
    },


    -- Finishing move that causes damage per combo point:     1 point  : 256-391 damage     2 points: 452-602 damage     3 points: 648-813 damage     4 points: 845-1024 damage     5 points: 1040-1235 damage
    eviscerate = {
        id = 2098,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 35,
        spendType = "energy",

        startsCombat = true,
        texture = 132292,

        usable = function() return combo_points.current > 0, "requires combo_points" end,

        handler = function ()
            if talent.cut_to_the_chase.rank == 5 and buff.slice_and_dice.up then
                buff.slice_and_dice.expires = query_time + buff.slice_and_dice.duration
            end

            spend( combo_points.current, "combo_points" )
        end,

        copy = { 2098, 6760, 6761, 6762, 8623, 8624, 11299, 11300, 26865, 31016, 48667, 48668 },
    },


    -- Finishing move that exposes the target, reducing armor by 20% and lasting longer per combo point:     1 point  : 6 sec.     2 points: 12 sec.     3 points: 18 sec.     4 points: 24 sec.     5 points: 30 sec.
    expose_armor = {
        id = 8647,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function() return 25 - 5 * talent.improved_expose_armor.rank end,
        spendType = "energy",

        startsCombat = true,
        texture = 132354,

        usable = function() return combo_points.current > 0, "requires combo_points" end,

        handler = function ()
            spend( combo_points.current, "combo_points" )
        end,
    },


    -- Instantly throw both weapons at all targets within 8 yards, causing 105% weapon damage with daggers, and 70% weapon damage with all other weapons.
    fan_of_knives = {
        id = 51723,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 50,
        spendType = "energy",

        startsCombat = true,
        texture = 236273,

        handler = function ()
            -- 刀扇造成AOE伤害，可能触发毒药
            if talent.vile_poisons.rank > 0 then
                -- 可能应用毒药
            end
        end,
    },


    -- Performs a feint, causing no damage but lowering your threat by a large amount, making the enemy less likely to attack you.
    feint = {
        id = 1966,
        cast = 0,
        cooldown = 10,
        gcd = "totem",

        spend = function() return glyph.feint.enabled and 0 or 20 end,
        spendType = "energy",

        startsCombat = false,
        texture = 132294,

        handler = function ()
            applyBuff( "feint" )
        end,

        copy = { 1966, 6768, 8637, 11303, 25302, 27448, 48658, 48659 },
    },


    -- Garrote the enemy, silencing them for 3 sec causing 768 damage over 18 sec, increased by attack power.  Must be stealthed and behind the target.  Awards 1 combo point.
    garrote = {
        id = 703,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function() return 50 - 10 * talent.dirty_deeds.rank end,
        spendType = "energy",

        startsCombat = true,
        texture = 132297,

        usable = function() return stealthed.all, "must be in stealth" end,

        handler = function ()
            applyDebuff( "target", "garrote" )
            applyDebuff( "target", "garrote_silence" )
            gain( talent.initiative.rank == 3 and 2 or 1, "combo_points" )
        end,

        copy = { 703, 8631, 8632, 8633, 11289, 11290, 26839, 26884, 48675, 48676, 1284409 },--圆圆bro添加锁喉新ID
    },


    -- Increases dodge by 15% for 7-11 seconds.
    ghostly_strike = {
        id = 14278,
        cast = 0,
        cooldown = function() return glyph.ghostly_strike.enabled and 30 or 20 end,
        gcd = "totem",

        spend = 40,
        spendType = "energy",

        talent = "ghostly_strike",
        startsCombat = true,
        texture = 136136,

        handler = function ()
            applyBuff( "ghostly_strike" )
            gain( 1, "combo_points" )
            removeBuff( "remorseless" )
        end,
    },


    -- Causes 79 damage, incapacitating the opponent for 4 sec, and turns off your attack.  Target must be facing you.  Any damage caused will revive the target.  Awards 1 combo point.
    gouge = {
        id = 1776,
        cast = 0,
        cooldown = 10,
        gcd = "totem",

        spend = function() return glyph.gouge.enabled and 30 or 45 end,
        spendType = "energy",

        startsCombat = true,
        texture = 132155,

        handler = function ()
            applyDebuff( "target", "gouge" )
            gain( 1, "combo_points" )
        end,
    },


    -- An instant strike that deals 110% weapon damage (160% if a dagger is equipped) and causes the target to hemorrhage, increasing any Physical damage dealt to the target by up to 13.  Lasts 10 charges or 15 sec.  Awards 1 combo point.
    hemorrhage = {
        id = 16511,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function() return 35 - talent.slaughter_from_the_shadows.rank end,
        spendType = "energy",

        talent = "hemorrhage",
        startsCombat = true,
        texture = 136168,

        handler = function ()
            applyDebuff( "target", "hemorrhage", nil, 10 )
            gain( 1, "combo_points" )
            removeBuff( "remorseless" )
        end,

        copy = { 16511, 17347, 17348, 26864, 48660 }
    },


    -- Enrages you, increasing all damage caused by 5%.  Requires a bleed effect to be active on the target.  Lasts 1 min.
    hunger_for_blood = {
        id = 63848,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 15,
        spendType = "energy",

        talent = "hunger_for_blood",
        startsCombat = true,
        texture = 236276,

        usable = function()
            return debuff.bleed.up
        end,

        handler = function ()
            applyBuff( "hunger_for_blood" )
        end,
    },


    -- A quick kick that interrupts spellcasting and prevents any spell in that school from being cast for 5 sec.
    kick = {
        id = 1766,
        cast = 0,
        cooldown = 10,
        gcd = "off",

        spend = 25,
        spendType = "energy",

        startsCombat = true,
        texture = 132219,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            interrupt()
            if talent.improved_kick.rank > 1 then applyDebuff( "target", "silenced_improved_kick" ) end
        end,
    },


    -- Finishing move that stuns the target.  Lasts longer per combo point:     1 point  : 2 seconds     2 points: 3 seconds     3 points: 4 seconds     4 points: 5 seconds     5 points: 6 seconds
    kidney_shot = {
        id = 408,
        cast = 0,
        cooldown = 20,
        gcd = "totem",

        spend = 25,
        spendType = "energy",

        startsCombat = true,
        texture = 132298,

        usable = function() return combo_points.current > 0, "requires combo_points" end,

        handler = function ()
            applyDebuff( "target", "kidney_shot" )
            spend( combo_points.current, "combo_points" )
        end,

        copy = { 408, 8643 },
    },


    -- Step through the shadows from enemy to enemy within 10 yards, attacking an enemy every .5 secs with both weapons until 5 assaults are made, and increasing all damage done by 20% for the duration.  Can hit the same target multiple times.  Cannot hit invisible or stealthed targets.
    killing_spree = {
        id = 51690,
        cast = 0,
        cooldown = function() return glyph.killing_spree.enabled and 75 or 120 end,
        gcd = "totem",

        spend = 0,
        spendType = "energy",

        talent = "killing_spree",
        startsCombat = true,
        texture = 236277,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "killing_spree" )
            setCooldown( "global_cooldown", 2.5 )
        end,
    },


    -- Instantly attacks with both weapons for 100% weapon damage plus an additional 44 with each weapon.  Damage is increased by 20% against Poisoned targets.  Awards 2 combo points.
    mutilate = {
        id = 1329,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function() return glyph.mutilate.enabled and 55 or 60 end,
        spendType = "energy",

        talent = "mutilate",
        startsCombat = true,
        texture = 132304,

        handler = function ()
            gain( 2, "combo_points" )
            removeBuff( "remorseless" )
        end,

        copy = { 1329, 34411, 34412, 34413, 48663, 48666 },
    },


    -- When used, adds 2 combo points to your target.  You must add to or use those combo points within 20 sec or the combo points are lost.
    premeditation = {
        id = 14183,
        cast = 0,
        cooldown = 20,
        gcd = "off",

        spend = 0,
        spendType = "energy",

        talent = "premeditation",
        startsCombat = false,
        texture = 136183,

        usable = function() return stealthed.all, "must be in stealth" end,

        handler = function ()
            gain( 2, "combo_points" )
        end,
    },


    -- When activated, this ability immediately finishes the cooldown on your Evasion, Sprint, Vanish, Cold Blood and Shadowstep abilities.
    preparation = {
        id = 14185,
        cast = 0,
        cooldown = function() return 480 - 90 * talent.filthy_tricks.rank end,
        gcd = "totem",

        talent = "preparation",
        startsCombat = false,
        texture = 136121,

        toggle = "cooldowns",

        handler = function ()
            setCooldown( "evasion", 0 )
            setCooldown( "sprint", 0 )
            setCooldown( "vanish", 0 )
            setCooldown( "cold_blood", 0 )
            setCooldown( "shadowstep", 0 )

            if glyph.preparation.enabled then
                setCooldown( "blade_flurry", 0 )
                setCooldown( "dismantle", 0 )
                setCooldown( "kick", 0 )
            end
        end,
    },


    -- A strike that becomes active after parrying an opponent's attack.  This attack deals 150% weapon damage and slows their melee attack speed by 20% for 30 sec.  Awards 1 combo point.
    riposte = {
        id = 14251,
        cast = 0,
        cooldown = 6,
        gcd = "totem",

        spend = 10,
        spendType = "energy",

        talent = "riposte",
        startsCombat = true,
        texture = 132336,

        handler = function ()
            applyDebuff( "target", "riposte" )
            gain( 1, "combo_points" )
        end,
    },


    -- Finishing move that causes damage over time, increased by your attack power.  Lasts longer per combo point:     1 point  : 346 damage over 8 secs     2 points: 505 damage over 10 secs     3 points: 685 damage over 12 secs     4 points: 887 damage over 14 secs     5 points: 1111 damage over 16 secs
    rupture = {
        id = 1943,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 25,
        spendType = "energy",

        startsCombat = true,
        texture = 132302,

        usable = function() return combo_points.current > 0, "requires combo_points" end,

        handler = function ()
            applyDebuff( "target", "rupture" )
            spend( combo_points.current, "combo_points" )
        end,

        copy = { 1943, 8639, 8640, 11273, 11274, 11275, 26867, 48671, 48672 },
    },


    -- Incapacitates the target for up to 45 sec.  Must be stealthed.  Only works on Humanoids that are not in combat.  Any damage caused will revive the target.  Only 1 target may be sapped at a time.
    sap = {
        id = 2070,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function() return 65 * ( 1 - 0.25 * talent.dirty_tricks.rank ) end,
        spendType = "energy",

        startsCombat = true,
        texture = 132310,

        usable = function() return stealthed.all, "must be in stealth" end,

        handler = function ()
            applyDebuff( "target", "sap" )
        end,

        copy = { 2070, 6770, 11297, 51724 },
    },


    -- Enter the Shadow Dance for 6 sec, allowing the use of Sap, Garrote, Ambush, Cheap Shot, Premeditation, Pickpocket and Disarm Trap regardless of being stealthed.
    shadow_dance = {
        id = 51713,
        cast = 0,
        cooldown = 60,
        gcd = "off",

        talent = "shadow_dance",
        startsCombat = false,
        texture = 236279,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "shadow_dance" )
        end,
    },


    -- Attempts to step through the shadows and reappear behind your enemy and increases movement speed by 70% for 3 sec.  The damage of your next ability is increased by 20% and the threat caused is reduced by 50%.  Lasts 10 sec.
    shadowstep = {
        id = 36554,
        cast = 0,
        cooldown = function() return 30 - 5 * talent.filthy_tricks.rank end,
        gcd = "off",

        spend = function() return 10 - 5 * talent.filthy_tricks.rank end,
        spendType = "energy",

        talent = "shadowstep",
        startsCombat = true,
        texture = 132303,

        handler = function ()
            applyBuff( "shadowstep_sprint" )
            applyBuff( "shadowstep" )
            setDistance( 7.5 )
        end,
    },


    -- Performs an instant off-hand weapon attack that automatically applies the poison from your off-hand weapon to the target.  Slower weapons require more Energy.  Neither Shiv nor the poison it applies can be a critical strike.  Awards 1 combo point.
    shiv = {
        id = 5938,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 40, -- TODO: Cost is based on weapon speed.
        spendType = "energy",

        startsCombat = true,
        texture = 135428,

        handler = function ()
            -- TODO: Apply offhand poison.
            gain( 1, "combo_points" )
        end,
    },


    -- An instant strike that causes 98 damage in addition to 100% of your normal weapon damage.  Awards 1 combo point.
    sinister_strike = {
        id = 1752,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function()
            if talent.improved_sinister_strike.rank == 2 then return 40 end
            if talent.improved_sinister_strike.rank == 1 then return 42 end
            return 45
        end,
        spendType = "energy",

        startsCombat = true,
        texture = 136189,

        handler = function ()
            gain( 1, "combo_points" )
            removeBuff( "remorseless" )
        end,

        copy = { 1752, 1757, 1758, 1759, 1760, 8621, 11293, 11294, 26861, 26862, 48637, 48638 },
    },


    -- Finishing move that increases melee attack speed by 40%.  Lasts longer per combo point:     1 point  : 9 seconds     2 points: 12 seconds     3 points: 15 seconds     4 points: 18 seconds     5 points: 21 seconds
    slice_and_dice = {
        id = 5171,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = 25,
        spendType = "energy",

        startsCombat = true,
        texture = 132306,

        usable = function() return combo_points.current > 0, "requires combo_points" end,

        handler = function ()
            applyBuff( "slice_and_dice" )
            spend( combo_points.current, "combo_points" )
        end,

        copy = { 5171, 6774 },
    },


    -- Increases the rogue's movement speed by 70% for 15 sec.  Does not break stealth.
    sprint = {
        id = 2983,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        startsCombat = false,
        texture = 132307,

        toggle = "interrupts",

        handler = function ()
            applyBuff( "sprint" )
        end,

        copy = { 2983, 8696, 11305 },
    },


    -- Allows the rogue to sneak around, but reduces your speed by 30%.  Lasts until cancelled.
    stealth = {
        id = 1784,
        cast = 0,
        cooldown = function() return 10 - talent.camouflage.rank end,
        gcd = "off",

        startsCombat = false,
        texture = 132320,

        usable = function() return time == 0, "cannot be in combat" end,

        handler = function ()
            applyBuff( "stealth" )
        end,
    },


    -- The current party or raid member becomes the target of your Tricks of the Trade.  The threat caused by your next damaging attack and all actions taken for 6 sec afterwards will be transferred to the target.  In addition, all damage caused by the target is increased by 15% during this time.
    tricks_of_the_trade = {
        id = 57934,
        cast = 0,
        cooldown = function() return 30 - 5 * talent.filthy_tricks.rank end,
        gcd = "totem",

        spend = function() return 15 - 5 * talent.filthy_tricks.rank end,
        spendType = "energy",

        startsCombat = false,
        texture = 236283,

        handler = function ()
            applyBuff( "tricks_of_the_trade" )
        end,
    },


    -- Allows the rogue to vanish from sight, entering an improved stealth mode for 10 sec.  Also breaks movement impairing effects.  More effective than Vanish (Rank 2).
    vanish = {
        id = 1856,
        cast = 0,
        cooldown = function() return 180 - 30 * talent.elusiveness.rank end,
        gcd = "off",

        spend = 0,
        spendType = "energy",

        startsCombat = true,
        texture = 132331,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "stealth" )
        end,

        copy = { 1856, 1857, 26889 },

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

    -- 死亡印记 (泰坦时光服新技能)
    -- 终结技，标记目标6秒，储存期间造成的伤害，结束时释放
    -- 1点5%, 2点10%, 3点15%, 4点20%, 5点25%
    marked_for_death = {
        id = 1284398,
        name = "死亡印记",
        cast = 0,
        cooldown = 6,
        gcd = "totem",

        spend = 25,
        spendType = "energy",

        startsCombat = true,
        texture = 132094,   -- 调整死亡印记图标

        usable = function() return combo_points.current > 0, "requires combo_points" end,

        handler = function ()
            applyDebuff( "target", "marked_for_death", 6 )
            spend( combo_points.current, "combo_points" )
        end,
    },

    -- 转嫁 (泰坦时光服新技能)
    -- 移除并储存你的连击点数，如果通过技能产生了新的连击点数，储存的点数将会消失
    -- 无法对玩家使用，10秒冷却
    redirect = {
        id = 1282538,
        name = "转嫁",
        cast = 0,
        cooldown = 10,
        gcd = "off",

        startsCombat = false,
        texture = 236274,

        usable = function() 
            -- 无法对玩家使用
            if UnitIsPlayer("target") then
                return false, "cannot be used on players"
            end
            -- 没有转嫁buff时需要连击点，有转嫁buff时不需要
            if combo_points.current == 0 and not buff.redirect.up then
                return false, "转嫁需要连击点"
            end
            return true
        end,

        handler = function ()
            if buff.redirect.up then
                -- 如果已有转嫁buff，根据转嫁buff层数获得连击点
                local stack = buff.redirect.stack
                gain( stack, "combo_points" )
                removeBuff( "redirect" )
            else
                -- 如果没有转嫁buff，消耗当前连击点，获得对应层数的转嫁buff

                applyBuff( "redirect", nil, combo_points.current )
                spend( combo_points.current, "combo_points" )
            end
        end,

        copy = { 1282538, 1282540 }  
          
        end,
    },

    -- 菊花茶 (消耗品) - 立即恢复20点能量，5分钟CD
    thistle_tea = {
        name = "菊花茶",
        cast = 0,
        cooldown = 300,
        gcd = "off",

        item = 7676,
        bagItem = true,

        startsCombat = false,

        usable = function ()
            if GetItemCount( 7676 ) <= 0 then return false, "需要背包中有菊花茶" end
            if not IsUsableItem( 7676 ) then return false, "菊花茶CD中" end
            return true
        end,

        readyTime = function ()
            local start, duration = GetItemCooldown( 7676 )
            return max( 0, start + duration - query_time )
        end,

        handler = function ()
            gain( 20, "energy" )
        end,
    },
} )

spec:RegisterSetting("rogue_description", nil, {
    type = "description",
    name = "根据你的游戏风格偏好调整以下设置。"..
        "建议你始终使用Simc模拟来确定角色设置的最佳值。"
})

spec:RegisterSetting("rogue_description_footer", nil, {
    type = "description",
    name = "\n\n"
})

spec:RegisterSetting("rogue_general", nil, {
    type = "header",
    name = "通用"
})

spec:RegisterSetting("rogue_general_description", nil, {
    type = "description",
    name = "通用设置将更改常态情况下使用的参数。\n\n"
})

spec:RegisterSetting("maintain_expose", true, {  --修改 by 风雪20250704
    type = "toggle",
    name = "维持破甲",
    desc = "启用后，当 BOSS 没有护甲 debuff 时，将推荐使用破甲",
    width = "full",
    set = function( _, val )
        Hekili.DB.profile.specs[ 4 ].settings.maintain_expose = val
    end
})

spec:RegisterSetting("rogue_general_footer", nil, {
    type = "description",
    name = "\n\n"
})


spec:RegisterOptions( {
    enabled = true,

    aoe = 3,

    nameplates = true,
    nameplateRange = 8,

    damage = false,
    damageExpiration = 6,

    package = "战斗(黑科研)",
    usePackSelector = true
} )


spec:RegisterPack( "战斗(黑科研)", 20260110, [[Hekili:TRvBtnrww4FlutvuHACYReh3Tiu1oV8H1p4S1MP2pMKMKgilH0P6UJZAvuPcQqsqJGccSdOaZIJOUcOIisa5hZMB3D(0(xyo37Tt637oXbCRAl1sQq337555EVNZZ5CpXeHs8JjINHrKnX1chmC0qHd)1(dfms0bJKiU4nkWMiEbM0tWmg8H8mtc)mk(j3ihhtg8mf4kYNgEAI4JumBoX)C(eJyN5gm6vGXwGnDIRnyI4JNntgw6izfsNi(FLBSIS)XsP(wUjhHrSuQVQukPQRkT8kYRTIYbNukLVWbdenuGGdu6QsVzF0J(1wvQ3AXJKw5q0m1KwVozk)L)23R8HfrvowA9YOTFk6UllxRQ06)ByoBEe6SBH(WZLV3EamOQvq1EDPuddFS2Rv(x3u9Jl1657q(yRB(CPPpuAPgOknkDv02pt5T3HmVJLEu5WbLV579HF)TNpAaPv2u6wZejGsLdq3)0ibKF9hqvMnCauTNkT3dcfaDYXaruQVNYSZpya0SVtzRYWt3FAu99HjOC2cHGfvPuA)LUYJgcJcAMDADRDuPpHgWGBT2dLwUcWhGmsv3vET1KF5BdGQwwQwLaOxmT8toszVYYpVEI45YkikGpMsNJL56SWNUg58MnpZi5yZK4BG3WNvKLpltI49vk1ifhDu)c5YMMnjt(mjZaFWFXcLs1FPuPHZgUKf4YMxuWF6I88S5HtQHJvkvOeXzslMLlpCcByQjebNahHZoS4zNKjBEHsPgQuQiEaBy3GnIJWkYKdmH)rYXKHn5O5alEd)QdKay7DbddOybnW0)cmud6fumzasZKlBE2K8ffg3aAS5z5h7gAlmyDhni5n2FuOrdtwfZKOEXKjYMdMWyjfkWZY6fpIeTR4HbBIzXL9IfP5YLj5i544YyGcoFspOgAAZnr8IcSj5gD0KJLod2TgG(RDeAxmobCFKd(mSKvlFXcIf5PE(tnLLhR3jfM9aAStDeyQCLpAQydjS(0oCauRUSgbyVEwH0S8y5xGd)HEKdyNpDbvzZdQhS8jfe5ZobXGHcITOtdqhuIWFbT9rzkMt0orNohNm5YLK(ljXAvufRK0enG5fDxczCwMCIJ7Vq62ES6Iszb7GFp23Sah5HT1f0CDtpHrw7sWmSsXGXMXpWz9h55DCbOof3dnXt(6SjHaWjZYkyXH3n7ZW5raND2omXDY8BgcEtKUdv1uj2eU1nZwqSt0rx5hrDI7i6vuKljJOiJ5doaeq)jnP(HooCDaq9CWOHdRFiQEiMTjEh(Z5m)CoZpNZ0HKeJYKhSxYjYdQjcF059oVsGPLe1(K5Wlez4hJv0Vy2jztcAjzYYsYHgkSTzXnMWZ4I1OAsOqDTKMOMIKxAlQRHXy455en6dP(mlkzmtoc212kIUdgbhZrDTlaYUnnS3EqRcOwDWiSZ0J7mn8ZbkmP5TZiUnPEkV9)hlO4IeWqgf7)ui40UoAhkI2XisxQUoIHQR)y1XUqYr7So3fAoANvefyffHJyb)yKeH)LK9FuGtGTRo20oCMK5VZXNKHFs4N8SzksyIbFEQzPdrtJShuPbuJEXCPRqoRV197aAeXEmCU6mpwU9M7VBxSlKZLQ516SNjXvSvAc)IOospNvJ9IEoMgYoQ7i(oRb3n10y3fFVCVKDNCXvBY2YvGeMQzORZaKcEl(t5kYIVYSZo9KHRElk1barOJYZsZ7y2T0BW8uOspIcWi0HMzhqVrZ5KB954XUEcqNpC0XHZKzxoFV5GRf5qEPXKZgzWif5HRXwyCgbwY5mG0pXWNhl6MiUu1fqZTbAVtqZ8KMhp7x38ONlnxzLBDkQ6kkBTZ)P8nlD1e47VooOAghT49rlSf(oRCJMftWV4lkLQx6coE8FmDcNmVFxDdhBHpbDehdtp1vC8e66oJx6Q0jeZM)qWcvRoqA02vCymxL6Jj4Vtxh(YybuRQ3(xslq2(3bYiPNqaF3cXXHkS5HllFPSJgBmEoW50vQ2QXQk7UnAUDAE66EqvahZTB7syh7yy5kvpJx3qE5vGJgP9pG4i1807bNoTQmp4F180ZKxAh9MZMESHPTwx5gcIWPgU2Isl)s9ZfxdV67oDDLTUR8ChkvEAL3(oPA3r)4m1ljkJv3OXGzOTCud(N(HVN6Cdrmd(LYRTR0MvgWtBYWr2ZXpxRXydhBqvp(9Nx5P3wANTaJJde)QiDRDPTlZothUFJpzOyrubR(dBE6IQRbVSVG6zhAH7bURunh9tYuYk9Vsx30C3ldv9rONEhiQfn)QGZGxXeyhkW8TLFP80ukRlrKKJzFcVHg0dJPlBKQHCjz2qr8WAgtTOAqJ5Rap5(7ZP0hUBDDPn0ZvR2zQPSnfKhAvKOh14ghoxWZU5jRIMPQCJhJwUgQXXYV4oF3p8J)3tUR8Tpe8CAEY8G4U0spqA1n0woQXwWksTzdyV4(S0tc7MaTleE4vv)H0GOorRFdNGawONOSpGRlhIyKCTNHwCA0dURQKLoI0rX9s6UQySq4vGJB)wBZXqrcAYODAyHr7AAuy1nZdOZwbSY1NkcRZIoPmA9JHfY3(DONCku)aA)xHfBjd3OPDlxr)Pbx4mC)uE)2mkiCGjZnmWd5QZIM)(und5D3sEHzvrepcLB(HMhnNYmhlFWMOzFno5pMQWqbjaiXqZJVx0G46oaUVWEGRuNInOdrAPdLxBotS302oM5U3GM(nfhgny)oCzE1fM(u)09ws9nOxUkA9DAE0sD4FNuAa1Bn9zOzQRY7J)fOYjlhO6ck1XABBMJzodAh2Z5(T76idflC71cT4iYQO1m1rlunkeFk3acJxeo0mLqMsuTMKy1X3Xw7ylpGCF97ZYDUMAQ(S8S(DqfpYag96jheYnoqAUTPv3UE5wVyvvLPJFQoFpOgs6OHdjqQcv)nuVmFHGna8Vn)EdyAHBCZLOu1dB6dJJqjB5uVfaI9Nv6WQOTFf2fV67KwEFFHbWB24jquH3G7A(ihOqyJbNBEG8sqD5(qR9lTwDJwRxw5xNgiZa2PkOVPmKYICOBqoEs3Nh9)X4jj5Ec6pjjk2qgfDNHyFv6aPNWMySQZcMS2XPyr73NvpTPMYPcguVbWGDa1h2hI8jYEwpbU(neDDkX4wa9(r4f)HvvkVIYzpgKiHRNyzlapqFQBz78g0U)SnesRbgUSH0TbEdFz9Bge4PsBQU1ebUENb4DLUMcxXKi4Wxr9QaQ5CwFJwRCa1XGU)bC1N1uo0X9XXvhYZBDny4Gv)TDvliYM4ntvv7engkQ(IZD3gEuSKJxaXLQKmO42bC6nsoFKm7cB(7sjev7(OQ3Q57FLs1htc2cREHo0zZaPeSHa6)QM1L0ZUV7A1k6n9Tw3gA9fhzdoxKvYybSlMYp6SjBOZiwa)CQItAXm06y6udJnWDUwbJMFejr0rnOEp2aBxKsOxti1gAsMcRi2DQyDTI7LBdOvfmF6dJAEYpRS7ZAEY2ODFdQ6Ss3xF1mAXXDVaNxZ1DHn77wt3kQHLeal089TRpAPgTkVbAUnLQUGgZy4oNL7CYGNVAD4TgqMtFIdkWxWACuq(uiWrr6)fQBuKVaK2ODBwQ6Y2OXrb9IrGJaBN4HJAqcgWb)2F6A4)llUfDBqeRTx56hl9p3Jw9w76Bp7fqGxNs5G7u38O60GuQ27aMzqxj)zu)M2t6gZa3KxTkGxUQ0bnG6PHIeB9WZS2LAvS6cXDBUwR1(bnCiTOvtL0zZ2Qf9clFXIIjs8B)]] )
spec:RegisterPack( "刺杀(黑科研)", 20260110, [[Hekili:TV1wtTXrw4FloPwIufhbcqXEDbPQKAZdRFizRvP2hL0G0aO1cnQMzezDvuQeobljUeWMRRbFHeSXxIneBSngb2)yw1Zi9K)lSNU7rZm9CvcejUsrQk2A6P7Z5095C((oDpTJfo23flAkoz(yFtV907N3t4E6lu4i92tKyrLVAo(yrZXL8kCJa)il3yWFIkFGYTlgOr1BOU9nuV3sbX94Qze4sHfKKqEXKqVIfDO8PZi)3ZgBihKE4irUa03C8jJ9n9hl6OPtLIN2tEPKXI(pfgjp)LkK4lLK4KKsNLtoTq2cj(ScjOkxD9vRV3Hfseis4UdFXU7nyHlR8IDr3(bnknxJf3xz1xHMQIYgZrgY)4F911F7IOshOSrr0wBJMDf1kLv24xHXCV9rV7hqV9XQ)0oxcl7sOkpVqIVOqI6BwS2BMPX9VVY(7rAqzNBw7WTcOw9P0EfuR1jHwvw6MkRD3cxgAU(VCTAvNsDPhw7GFQ(2pan)nmlPakREpLxoj0eyHbF)HZsLAJI3Q(7kPSYJq7EeEYv92OTEu9xoJUYartA4snN)rcRET3eagD952PB1Yxh0dDUaMLs51uwz1WxK0JBThQu1Ur34OA7)0UvkE)gfVlUllpFJLwOxspal6hMsPcS(ufT(DQ)dhbRLnwFzLvkDPMZVUnph6g9KjvV)(13PO6JNd88IcdNod4V)4pUqIJHBdpSJJRJmUoR7dlYtrxir8)U6gXASLDLfUmDad6W)rSguL5qLUoARsU0NlZLe7ULcLtKpPWydXj)Pd2TKmpxg5rD(L5eiXho(ozX0jVIuCHHJlpkFCzrUu8Np9WdoIOq(CEBQnQUw9NTfA6hw7On8Xub9KKltM40hJNjTK85XyCdMoBAzTySNxvDLvb)JYU7zECdXljhFuyYLo7iXPteS9nkz6gkxs5b6lIMeQSOYkp18yVcm10E3rBuFZzvN(vkfNS(lFTsLzm3pX8zTBAAROyLP9t(uHGjbvGF53(108bijR)pvD9NPCVsb9vMCcKfxC7JZhNpl)yP5L(Ib7xlOD35RV9pQ8WnbHdIT3pRVwvUjZWZnUJIU3UyBzGb7ttzZTCTJwuBo4N8L0CsOf(jiUuz6IqCV5bnwE50zaQhZTXLxwioNSmh2h4vCeQ8TrBpda5GMFTgLM3VOECidi(X5etZnugEQbYNDC(ScJfxKFyrEPrp)4CzYZp4q5hE4qAVkKi)yCPZknqyFeLu2uojgPmPtYhNdEzk4h6sRpFK2OdpKfPDoI4gnF2r4fJpSGy8HYiiKku(CtmHZVr3W7XhDLkxCj8YTKMMsXteykEUuzUkK7KwsiBij)Di0KfT0ex8g4rRw9oOvQGQEG6tM5V9TFh6MZQ88kaQGHzQL4aw6iCIIcYKq0ZPzxAnfcJZqYrnrseGIBdKy12VA9hmjTvAGxqNKVreONHAZTmnLsp39ReKKWmanzdCCCejw7O3bCvQvEeAXjHPQfKkWu0bApFEjEaqD44JKm1GHXtz3C5D5UlcqfMyczoXr4LdjNEmaAwaI84hOVESOtSYslZpMeRAT0lmuO1oOVsblmMjOinXoCVyj6kPGqMucFF2qo0li6Ll1vz0LzMr1Q7Pm9wKsqGkpA8K1QD4AOPkREW2AwbHADJIqia1XPSrfTQcwUSYD2qPYCqeHY7kQSx1aOzNszMFfZG(lpPB1zFc6TVw9w)iT7bTmHS6mWZgzUm8zLT7N4ZIZXs1vGtqQBWUcylSFIj0AsmFo58ISnLoN5htXZNl(3lKpBkjMEXNnfZZCxHrkz4sYlYXQSCGuaKmygXJhBq24GR)AyXI4pAm1COfkhbN2rsmPX)ofCKeC)ARI2I81wtn6I(QjUcebCiFwzPqjZlcZfziO37ucgJvDMNbjTeJvD75uwDETk7iOebch5VGFUu1Wru3(MbDYWZG)jU4crz7w(XY(6Y1mDNiryQWQzD1ntj0d)HsoPVbkegqArZ9c0HfrlSJLjdRSjaToRtxw5dRrXtufwj7EDLxvgT1VH3Pq5xRSYUb6fcgQv9(12FARPt2vUNKMUyc9Y6EV3EQlbBZiaA9FUXA3LIcG3mGtUs()tobWdYjoMGiPKnEzzOIrPqynkd)FCApCnSRjR0yC)BWTrKdqCNkprj28uKDVqI88ylmM8HO5FmAJhQ88nb8RAvRw7OLzqXw9v0SlQCBcK9lfvE5mTgCMgcI7XTH7YvWRUStiR3KbYKrteKj9hzrMm6ffzY4zkYK(ZMqM0BZcYeZkofdIsuq4QvRwwT6IqUEa0cZIZmmTJtJuht7z8JmVPXpIUbrACTw21StcYaKuJv3JoAdSVa1lThSPq6gi7)ZIG(TRrceTedsR00nNWGrAfSdhGiW2s)oBlkv3eSLA7VeG4b1odeOTPr5nIgyYW(geh5Q6D)I94Pz6i6beytDeAWi239Eh1ODBP0a9XRzaDrg3dNXaR9UBdrk0vF0pFh11THf2zmEBBBPvyqyoNfJJdckJMM0yUmANqrBwfTB2(aA7uLgTPCWpJpXiCU324uhAkABkrhIWmVxtxeNpL576gP9O(E7LLgqdbUsrlvDAYJt359zfu6qbLmLZyFbRduVslitVbc8Pme2JTZM26qBkIwZnTCBDwnhu3FaLztRWMwwTdw0ho1p3AfKHp9wMQVy4W1Nw)zUykTAiSvZK9vHodn2jOoHoVn5mZV)1fy)8PCW28LPRFpgK38zoFyZDCUmoHZiYADIm6QvhKfZnbEkqHrv1Pa)fQCrLkLukVIdezuL2rzX8MNIQWJfj1XLgIm9j0qqoR9JU24yTP9S2BUl0kLOIULcBPJdZLfV2FLSPhNxY9QOzbPAAbOnoq5)UdaWwV4QKtv3vyFQYoP4RhhW9wuZNmSB26d8(OyC4GCSySDKceCOAaNQz437ceSUTlhIcT(YMKyXIooVOe8cJBGsSOFpNyw8bXflA9N(a0nM(9hEl0ohIM6(FcLe8tqLxT(MpKE6E12VyTdwVEPhJ)QYV7zkl9M)xXRv4YKZCCgQdc96NJDFK0j6qRT)tPNE27pC2AhDD8xO)flJ7Z83Sw1xPS8UkZ9m0blcDtPYBrL3fSayYIdfmTAIN(wnqy29bS1jj)bKXPuEb003LAz1o46xO2(p2SEiMsSO4pOSe(UlH)8LWF)nKBeLggFSVkwuHCXIkXlhlknadcO0(aN4FLjpp(UonSTZgPqIbkKimPZXP3CklFo4yYqe5XtvoJ3q0yFM1OPVAmwB912A7Cfs4gKrHetmHBVLzjOhZwKPV8m2I6VTTi3r6nRg9p6mOez8GgMlFghDUnvK1BccnUqtCKidhCxjftlZdgimV0V5huVqedj7WDfr3z0Sp4peQzj7WstZUA5Qqy2iyUrimtaT3GLBK2xU4MnUSgfs8fq1)9ZiFaucl7pVZi7ElKORcjS(MbgKeDBsRuSASIVqRQyM1e8iVOz3GbNbJR4VAUpMUbjSDtw3GCimZyc7ZUwit9afs0rY8kKiyt5zJmNkfB0(Snt45zAILRNT3u(E22OC(mTzI3NPDRC)jcASQBDI6D2yZfp7vEHxnCQ6iAGxydfYouNqpnuNVyY(O2E9sTwXbmul92WrfTFBlYqdo0fDybt7ebhc7zaS99d5ZSSFY7Dh)whxrhswxd6ylTKbEInbsVCp7Rl3IUmmDtBVZj4PwXwdtuKNWa037qMnZlmNBZ(cTSBMgTMFZoIMz4ST2mhNPvMSCM3yjp3mAnXs1HLBZvS2276HduRwnD0)tftPpxnf7OhTHbdvC1Ew8amPD6KGyrf2F6rzk9)zKENr6DgPNnGGtF6S)ijQa)SPD6WCEmNUO491XGQ)qbe(4W57k1U7fd8bmNplzdBWe7gYcBff0odLFl3Kixc5vZ9g7jbMtlTgQvRnD8zFjmLmolIwcdWZ4b)Yv6Ns4y)ABtJS7XWEnoDIEDY0A2n9l3Tf3sFEnOw4ioonr5pRSKt1YsAD6SJntARfR7gF7fAzd8eBcDCwz3PrpvQ5ZDw0wJL8ywZNhmMUDVPBPqgdOB3Uf1MiWnDHTnOKAZWK2Lf)px7C3g3SFlzWkwK2nXQfRbZ9DV4xqJx2IUbZEhrlG)3u8f7PTns3zbpjgP3lyNSsBDNqTdAXo(50ABt16xKWpt1JJc54S3i3dtCrjwH6pjf2Q)pOA9An1bF1k5LTCmMsx1kf0Hc8CVGn)QeJEwr5LhfaxJIw8gOf2K0wS))p]] )
spec:RegisterPack( "敏锐(黑科研)", 20260119, [[Hekili:fZvEpTX1w8plrpveOgi24ysAeGuxEvT9pAKEop9(NiBgShG5HXgzpoTrkYYzbSn7KqbsceGui7SLqyZq4dt9DMX)v)k8o37DwUZUHsEnvLaEUZ587SFUN7Leny0Benscor(O)CRbATTabd(vTemyRxo8xfnI4ThKpAKb5I3pxVW3KIBa4Rs)2K1MzQgRvzA5xoT8YZ0eEf3ozAUeykLnDUmXHvfns35esk(JPI2TfYF1Or4Yj2x6mrJGE00OPwjAK(esKGNUs(SXJgr5KhxD)3insbL7FC1JMhnuj5dFzTHgx(4nqlDy1dN4h47xiPG02LrJnRC5sOs7w94f(Jc3lAKKczfZIbIqkbr4V)zI8XNIR7K8jI(nrJKEqaK8IaiIlkKov0i3IlJa(P4Vlzo4VINEGUthBW0cPeZ2s8CzYWNsmFxD2r(UcNVRgY3vJ576c57kbF356PNwYKBqXCz4Bj3G576o3X2hNHFaoHuzZ3v757ku(UAIWUyufP6AIniFQecP6nQiOIo3bRdW0(NQJYoZ3vBSqK)wczJZNbmFSOm0PgLQ8BaUm9ZNiwpPZelbpNyFaCy5MqQywxbMDx(uZovMLvKptS09elBUUftYlEBlSRpUSXSVimhdFQ5OixME5fBPpEUKGynyCrQfpSjL5VYhphwtcmMhyJiwV0dxUKo6NQXQ4CjtgJ(dXWo3uxCDnMGOt(nXZiaILahiK2rKgL7MhOd(5Gzf8GiFOM1vBn9leVFwk7G5qBPzYLYmonabOJXOGprlGWysauFItk96GU4p(w8X4tXpGap19nKjYZLgRO)52QxsBczut0Gz4XXyCEAK0edgSbPiiUHztkeNpgxQeXsaFJwaO7HTTsEUrcgNIz80IlYLeiwlaUhGpHGihgHTOTsDeB6XAMDI8j6SeAsmy5hv70rGgoRs8LRpj(YS(Lo57A2nnSpYtFCjs)lGDBqnhepwCgqtbUbM89OjqvFGJcjeClexqS9ocR6jLongUo5hzqwWxotV32qbbXSbdeqRUtCGeaSt1cf(XsWLkU5ImHPLH0x4T4sjKTpRlbQdHvVP4)vrmym8kGxlwgE1I4euR5A7jQ9YNZdRF7K4vxDjD3h3WzPxUmzsl6JxgwOBG6BYQ3WkOgSvG0aqQ02PsEMD)9QaS3(168QEk8v)m9VwlkgPhjRWPKZ1puolnGObaJ2pQJGuUb6ox2(8hAmoduxB18lx5ukIU4uXAuvHeq8R6kXDVxfIIYThZA1c2sy)C(RlVCs0UEGEUS8ah7jwVXtyjhHdzBB1R3a)5G4oqwlVuiVEjx68WdhGKWxZIlkKXEIARMipDPvZMz6DytMznhn2z)Qb8YealiO)zdiRWTojBq9bjGwuWiQ9WwlMrrQt974w5Lo7aQTCAiS7XiQ6S03IpdS1SK(QV0kQ5NcZNkE4o(cCM1B0IJEhF(3UGP3wLzx46tU(k)KlOO7GCzCQGTlnqGZqhOoLG2o7MggCHLJGb8tqmAOttoAWJstU1iyqR94yn9Kn(ghucX6oz60jQJgESWBJ3LWBp735ZwR1U1IpgrU32JtWHTM0L9bz1r6qpr2zV3i)tb7Ej5gSM)STaE3cxWZEJt(JZl4fuRZq0Gb8nCpyGtVy7tVA2EN))PxCswWi29sBz5ffH9TLTfSkre()y8)6GPZY7xCUn0(FbGYLza4RW(gZrufmqUEceOmMsecQ9TUvV9LoRyYBhlRygH(5RJuuTBh5wOHPMhn9icKCVKJF6Q)k7A50Ofz2xtRUxxXp06bGA1zE5((NpL8Qo2eLpjYCBpwT6EnOZFm6kiCVSJQxDF8qaqM(469u4rBjUh6tZG)g0JWFF2ObZQnPF8ixBNDC5gA0LKSDgOb9NW2oM(JBQHl4yhGwZKDLao2Yt7DeIU5o80q9CmoN12mc5vP6ZIhviN7BSDOue1DsBUByLgtWM2C68CInNLT3vhD17(UMoT9Q0UPMe7Hlfo4T)uc3IpR3BC1VquNYU6yQk33aPFSWd6Boi)kEhJDUmYv8angKpo2ceb2)wwmLzogYFHltkCH9OrKknfAKLqBEeAO1QE4Wxr)0hrLMtzLx9hfUx(FcVNK09iGp0N)X)iFx)R09MJ)A57kIAs18D1C(UONnQ8tNtzNJY)t4Lj9HTql(cP52v(1hkx(auP3kxUezT6hGk(eojhJj9nQE8ckfgcOm9Oo1xMuP5LMDUBimy2Afhhn8JPRgEnPfEhSAvXkC(FI(GoC4paCwEF0j3xAHdrL2vzZDKMFcxwjHgkFCpPYJEnS7V08lr)PlI)j5x(q0WdjxAy512h(Gq4FE8vugFtPktRSYyOsfrLFFZkh)o0BVBZsRxP6HRGgFlLn2Isx2)t6jZHoEBP1xR2ZFGYwJI2yYMRE0KOIvAomWt23L8baDv(971CTzUlA2YoqTjwtEXcmeawFT38kxjjLonBNq0hiv(rOfEf1QIw9LO9l9n)7V)7LR8iPfbkpU8tEG0cfqtnr19laQawMBNIYRxU6HZaaq(b7cVcQ0HaWaLh9hzrf6Oc15RdFJBuq(E7BNinccuWMBT6(JIkEOYkfAsDjuxvDhSRr)aWjfT1X1koPYgVwP4Bq7TD19hx5f3fuju2aYFBuxbLvwJA0)ZJgt5KhlT8Evp6jWRv94LrtUjeibmgEzGReJcb86mrAZjLE3kQsu5XL(WRKEWKYlmkatDVd0dhd8La3nP53en8EOX3HAfa(HnbRDmWJAdnoAQs6VIYElrFLQvwdn5iG3kAYPn0ja6uvwMTW1kogO7aKkT4AON)m0il3AGVO6rRI24d6iw(DVdm54Se7wcT62yWD82kLEwniJbrJb0KATmzvahLJprEMxD2bn6f3t6zlqvvumr)Q07xr69FcTXyysxA6QvEhARTRvOS0OVM1FSznkyraaNluPTAfhxd2nipOsXDWMUTMgqlSqW8qxiq(A373REqjG8qUmuPkytf21CydoSWROKhBujQf1aMPMaCy05SJ6hGSuvKHZbX0a5tH3cTXtWUFR)caKatXbdRxgRdlojwUlxauAYt8ApEfyzaSH0yYZ9qDwuBU3JZi(PHavnQ0EsZIDSPYl1HV6bBtTAWxbP7BUEKiqWdW1qH)cGLGFk1ksV3kW7in76ajOcpAIkSIeXk(0LRU)HOvFTYhhvAHY0snsZ(APflaECGf1aAKKIGBfGc5ktJDRiMtPsZcfjOjPah2Al(C9xrzYrugzBLX2LcwQhK0clHzeJBUo(GxNkzG)U0t3bT6tWspK4R4H25LQxzLsyt6ifmS5esrxPAmr5XPHcvpzrLnVl1kb4b6KQ5GTgO6bJwBUDmYwaoBG7rL1PWfmwauQU)Iq9edEqsWaAxSGrC8avR8gRqW6YyNHN8acbFAT5jPiN8n1wOanBIkuGmqA5UaXg)IeAcEDqvlwhymEkvqQCrynF91)NynYC7Ik8yS)ZXpcN6)PBiTCr0jVL6aRVaSB8NMJw5dT(8qmoamdlpnvn9XYvaVLrPbduYbuN6WPNWftxii5JVrzNdKMOSrubjgxnC6WXWXNeDpj6Qm8Jv3VcAevJ)FEujPLpqA8nOz4bGcQE0WFaIn(ZJykIk)Bpg7WqGIJ(3QESMCu9SBJsZJDdkomA1IU1NbTHVSTOFpl(YoUK6bZ58dnDmXxuONo88WNDMeKJWYBSxRY8kBSkOdH(X8b7afTElDUi(sK0b(65OwB99vKNDoCdsBTdXaw94jOQyWAOLEWGCoC9gWskZoHcfwLWLFeKSH9DXhCM6ZGojxzSlrRTabC4mXJSRuH7YUCl3bgkWvnayEA6U7qPleqG(0BKNytOHIl)Lu)LM8LMWUpX0d)5g3zNodrjjA8FRkexrPQFukRQsfhJVArA2t2xklO3jZ8Govk2hXLtmDmorroSoYlZpQ0IOxok0xoAY5bRKxDjJ7izQxaPAGaxCkfshQgoEyNaGZAxzmQiy5U)DrY1iRdN2CvNDeUHgVGTTvDN748KvAputSOcA(ccGjj6OTC5jQSFD)8by2GL1prBggTzcuqdxmL9HAtq(iFGMd3nqvS5XWGz55Qpa2mfBbq8B5dtD(gcQYxpg9oHV04ck31J2BKM8ekqjTXhBYpZb7fguLR2Njsi)2YN9Sa0DY5LpnTVdChhB8e9MoUKE)g0YKN82AfwsAMhsQWPjjQ5loTjQDEYvH0enkIP8VrAlS4wExOCtoXz1R0aMNxW29eYzoPRejBreYjtU2X4SRM29QDEzZReyQBHlxWlFvtSxppIjHfQXdkDLtkcHmok4QHDEHHtBUeBWIKiPrk6q79E5k7inYQoIgJ0jEbOttoekyuBlL64zShbAynnBc18PT1h7qJEZCCdwgEdQZzWktmnfatJaO8J8XH0JtMYThPzoc2syFCEDmGgxCvTDv1Q2oUmACgPdfy)S1wBl0JUlRSO330fzot8ocAzj631hpxfUhfRlGrcGKN0DTqkTdT4lp1WApsDDSPZOMhYKTy3VS0IRuTYUxdekYEp6SJRgOr62Uv3dstxexDyP27ii8n1w8zMlhribt26g1BgUjvVlZTTrLm2z)YKZZPHnBB(9x1T53h0Rmhn4Cjbc8x)3r7Vpf(N7OfF1HolW1TtbjyaDBlzdK09)s23bnog8kzJbDXidWI1Ss3y63(DDgcpCd7wvwtzJUTlNMSO2OiNrHz92bDQuwEFWrHcuNg4RPnwkVh7I1rGQpuQ)ELrhpHlnhcTDqIDikI)TaYYy3(2VtTLRzEfUjpgZBTNpT8b3vlRG5Kzgh1M5MtSEFOC1JTTa(ixT5MTJnhM06RrNPOwZw6dch3OLtXR4lRKTOv2B(KUEB49G2ozcKWgFMH3yI2gxgjZzMz4K976KJgCOQUL050XSqBvqprobH2MPdKTNonh8WqoEy7dUHMF2sHwSUX0jps69Z5dZ0fm7zwlF5LtSsRUDRNnoAsdAQnuwnOrNzSlbpNw6GLzYyYoXBmB9Cs3MK3ZPMCDTdh99Qn3YM6Ld6d)GL03dl1Jq)xiqLpDFyFvFMq6f8OpnVd6dgOokXP1MZY7ipZ71TNMKe276dzqmUCnKCleKr8C(IhDk8(OD77q8RXrYHNmQlXQkRSMfz7CFFkEllKmnmas9uuOBH5K3knb(8lapn8Kxply1fy1QTSGKzWyt)P(XnRPN13vfZSbP77b75B54Q0thAeYB7mZS6zDoVVm)dRjTPiD)Hqd)rO)z8rpyzCuFwWL1uOKnmQoUqtfHiNfkZM8QUFf8S8yxVzKACdGyQoA)sj5ZU1uU)yGEGY35wMIc1MpTnuykF7MlE)zf56MuD7SY2AV7OARpK0mvW7nMW8fkRZwlm0897JryD(Ef6cN1JoTDtc17uXPr5QwR160CzmQw(dz00aX8DBUM6hrNDCP5pp6Jq38soLhAVDmNweOK1pEis7ywpfiRas7gV4EqriT2mffgGpMyAaH8gZoJDRYe9tZA7wcn0qk7(bhC2u1eFE2DOUnNCaBe4aWYRyokCmDrO8F0nQZHN2An2q)Dx)g2uT(NB3Ezid8RN3g2pIsH5mnhukdoJP08zEotonA6H1pcgQTuA7LrJnBtEEqfANlUhhIULthhxjNSfRlPFQUvpzrPXC58CneF1FzxjdnI53P0lQ9RDkDFfM9AAh700ONDx1E47Chx6UQ9WnPD3((XbGSH)aVqV9HVUCbB10N)Fesi2N9poAKFmfKLPhU4838RtK46PYEt6)ktCZBaWfmlzVj5kF1YGK)rqqmA0)3d]] )
spec:RegisterPack( "敏锐(番茄酱)", 20260110, [[Hekili:nNvxpTXrx4FlOiHa1wxBJnjiHrQv6vQLlsUW9UQS2J9ogVYR31A3XKIeYckXjM8YNnajbHusutAi0giPQkn1aLFmX7AZv5VqNzw7DN1mZIjaPnxK449mNNN5CoZzppJLIi9DsjLbiO01Jgo6WHJenCOiJeBKyxtkjAQsqPKLazlaMa)bnqr8FBV(YhV2kd0C9DATWTpU6BgKyXuQ6azINm1lBKfB1X7VAZxSAZNSwZ5EL1rZ1CPxAT7BLsMPSIk6B1KY4hZiHXRSemR01JjLmVISm0XeOzwPKTo6rnE3o23BMwZDyJdEOv1AnR)IJRUyZd316X1BuFPVbwqrvX(nZBTWgnNVMvT324WTE)m)yLXRmU9REM7ACiH9d3JLtVFMvC3kVFMvTxELg1FwZnVnE9sjvvmrMKTfqhI)NRtdwqnqgvOmHGznuqqdfa2GSiLjHPGAWIkqZkPhRs6ivs3FL0D)GrRKEihZ11WXdvGmmvo1YggtjHWHdwa(6abiHphLdOLspxQcAyJmjEAiHuTVkPlxYBLMQkzHPaAYPKXFGS0y0DCNhROHdcqJuMidLcqwFInnUquYQxmJEQs6kAiZqzX7pOgQsAmPJ75B4KkMzHgKcbSVgUteg5zrEyrDdJ80YpVWcIyImmhOSkYnT0zjfuYwWVXbevZuoxUqM5bY63kLmqllmu5s9ZJ6JYeRlzalcLvqa6)T7yTp)JagtarHqkfHPq64imC0eX5cWydH)ADvmr08timyafnZXIjkUfti6dWfOeX6VpN9TVmpENp40tlyjX7N3kAtTrtezWGQNIlKGIaRpzifpJYLqLnANu8fCWLKLCdnjIe1d)2RPtfvaNbONpfwNgJ(4a220ZY9Gv4wbr9SciJraOQObtzu2mFiYEIl5VQqYhmNs0PZd)D2O(obEYK11otjRrte1nzb)Hs6MyNzGpYsYy8RXyQIzSNG8ic3WtyOZUqCJOSfmjT7q5XhRmWTqjRh)seruNB9e3JgmHg36mQZJCMIlckIzA3qlGz3vmP(iIByH7)BmXuEWejC8(hG62IaABACuXSCgKkenf29tpT75Mjb4g55DpZeEWtnbX2gIslX956tmf6VBkps8G70Lim)oW4sn315RfS3c94UZULY6ymVxHFBsNabccur5PbnEVwyqbSkMBIEcGHHocFUgOvisyFHY2pIYN485thtbfZG7lCXXVHOGoCWGorEDtK6uUVKNT6oOxkHZjCtVCjIx6ZpCm5pcvVAWuLDKGlfAsjX1cMeYqakFQIaJc9yJzcf6QFaZtoTwiEWrQQi8BKG5hZecxI8JoBv4GzcVM1NO1oXpr(ys7CNVA6P50LKIr0lPtbX6FaH9z910QeWWxllsB4(4oeA3BHHf1vCOo5nViKhXI3BN5Io0htW)F)Gs8apehvqNFM547an3T1zI00ajI6ucLaUct6wsd3de(evfLZQA39VlHnIf51BJm5tPNFzn(bsSoptDvDrdnXtrhJf(H4Q8m2)4PDjbeB4KqdtILm3JWTagAkAtykLeR935AcS34Un2)TnpOU1Rx1AV)64z2S5ABF8ZFT19NfR03ET9SxywSEFR9R3A3DT3B5gVBhVlAyUdpERzA9lZATqv7))V9Hd2SY4vs)fvs)9no8iSBAo)lXU5MF4GfWgyTYV2y)9BC462)(tT3AENVXARTD9wJ39kmIoqJxIDTnAnt1oo05RJCtRFAH2FokXVTo6r2p5pTMDtRxFh7L2U1IRG3dw1xZXKw)CvRNDx7NSmRRPx(HDTvSU3JT27aRQpVr97mK7LOyv7bTE62uBizD9CkQ4y7vUcw2dN)ujTDThAn)Iw39oyGeyZ4ozmZqUL)FwIVSDnl)h6RAtW6Dlvi3KJy(zT46no8(w)9onxAVtHFDd8NRKlXz4oay9J3Ryjo5IuOplk(pbqq6tOOEwI0EQacdoTPv6Dv7(INmYbfHYzxUPVyPlhi(V31eE(ddNu33j5LtvaXXx(A8yr3zn0iY)neXXsU26MO19NlvqbOsJfphXxNF481PW)KxoLoxyQvo9b8yPI3GCxW0Gfep1kETxV4eDWxuK4oZx04ZIeNXQiqsh(sCyV3fTCUQI(em)9LMOKp6A2pbBAXIo6AmJoq4J2Njsrcebn5ZxDJ)xpn2tiGoeZjF)irewrES3pQ0ym7G2RGv4xgGju(g4PYXZdAVXdA9hhmG7VYh5()lJYRBiL09xtJoHU0)8]] )

spec:RegisterPackSelector( "assassination", "刺杀(黑科研)", "|T132292:0|t 刺杀",
    "如果你在|T132292:0|t刺杀天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    function( tab1, tab2, tab3 )
        return tab1 > max( tab2, tab3 )
    end )

spec:RegisterPackSelector( "combat", "战斗(黑科研)", "|T132090:0|t 战斗",
    "如果你在|T132090:0|t战斗天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    function( tab1, tab2, tab3 )
        return tab2 > max( tab1, tab3 )
    end )

spec:RegisterPackSelector( "subtlety", nil, "|T132320:0|t 敏锐",
    "如果你在|T132320:0|t敏锐天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    function( tab1, tab2, tab3 )
        return tab3 > max( tab1, tab2 )
    end )


spec:RegisterPackSelector( "assassination_pvp", nil, "|T132292:0|t 刺杀PVP",
    "PVP专用刺杀天赋优先级，适用于战场和竞技场。",
    function( tab1, tab2, tab3 )
        return false
    end )

spec:RegisterPackSelector( "combat_pvp", nil, "|T132090:0|t 战斗PVP",
    "PVP专用战斗天赋优先级，适用于战场和竞技场。",
    function( tab1, tab2, tab3 )
        return false
    end )

spec:RegisterPackSelector( "subtlety_pvp", nil, "|T132320:0|t 敏锐PVP",
    "PVP专用敏锐天赋优先级，适用于战场和竞技场。",
    function( tab1, tab2, tab3 )
        return false
    end )
