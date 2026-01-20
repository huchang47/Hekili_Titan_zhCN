if UnitClassBase( 'player' ) ~= 'DRUID' then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State
local currentBuild = select( 4, GetBuildInfo() )

local FindUnitDebuffByID = ns.FindUnitDebuffByID
local round = ns.round

local strformat = string.format

local spec = Hekili:NewSpecialization( 11 )

-- Trinkets
spec:RegisterGear( "grim_toll", 40256 )
spec:RegisterGear( "mjolnir_runestone", 45931 )
spec:RegisterGear( "dark_matter", 46038 )
spec:RegisterGear( "deaths_choice", 47303 )
spec:RegisterGear( "deaths_choice_heroic", 47464 )
spec:RegisterGear( "deaths_verdict", 47115 )
spec:RegisterGear( "deaths_verdict_heroic", 47131 )
spec:RegisterGear( "whispering_fanged_skull", 50342 )
spec:RegisterGear( "whispering_fanged_skull", 50343 )

-- Idols
spec:RegisterGear( "idol_of_worship", 39757 )
spec:RegisterGear( "idol_of_the_ravenous_beast", 40713 )
spec:RegisterGear( "idol_of_the_corruptor", 45509 )
spec:RegisterGear( "idol_of_mutilation", 47668 )

-- 泰坦时光服套装by风雪20251124
-- 野性
spec:RegisterGear( "tier1feral", 257651, 257652, 257653, 257654, 257655, 257656, 257657, 257658 )

-- 平衡
spec:RegisterGear( "tier1balance", 257659, 257660, 257661, 257662, 257663, 257664, 257665, 257666 )

-- WLK版套装
spec:RegisterGear( "tier7feral", 39557, 39553, 39555, 39554, 39556, 40472, 40473, 40493, 40471, 40494 )
spec:RegisterGear( "tier8feral", 45355, 45356, 45357, 45358, 45359, 46158, 46161, 46160, 46159, 46157 )
spec:RegisterGear( "tier9feral", 48188, 48189, 48190, 48191, 48192, 48193, 48194, 48195, 48196, 48197, 48198, 48199, 48200, 48201, 48202, 48203, 48204, 48205, 48206, 48207, 48208, 48209, 48210, 48211, 48212, 48213, 48214, 48215, 48216, 48217)
spec:RegisterGear( "tier10feral", 50824, 50825, 50826, 50827, 50828, 51140, 51141, 51142, 51143, 51144, 51295, 51296, 51297, 51298, 51299 )
spec:RegisterGear( "tier7balance", 39545, 39544, 39548, 39546, 39547, 40467, 40466, 40470, 40468, 40469 )
spec:RegisterGear( "tier8balance", 46313, 45351, 45352, 45353, 45354, 46191, 46189, 46196, 46192, 46194 )
spec:RegisterGear( "tier9balance", 48158, 48159, 48160, 48161, 48162, 48163, 48164, 48165, 48166, 48167, 48168, 48169, 48170, 48171, 48172, 48173, 48174, 48175, 48176, 48177, 48178, 48179, 48180, 48181, 48182, 48183, 48184, 48185, 48186, 48187 )
spec:RegisterGear( "tier10balance", 50819, 50820, 50821, 50822, 50823, 51145, 51146, 51147, 51148, 51149, 51290, 51291, 51292, 51293, 51294)

local function rage_amount()
    local d = UnitDamage( "player" ) * 0.7
    local c = ( state.level > 70 and 1.4139 or 1 ) * ( 0.0091107836 * ( state.level ^ 2 ) + 3.225598133 * state.level + 4.2652911 )
    local f = 3.5
    local s = 2.5

    return min( ( 15 * d ) / ( 4 * c ) + ( f * s * 0.5 ), 15 * d / c )
end

-- Glyph of Shred helper
local tracked_rips = {}
Hekili.TR = tracked_rips;

local function NewRip( target )
    tracked_rips[ target ] = {
        extension = 0,
        applications = 0
    }
end

local function RipShred( target )
    if not tracked_rips[ target ] then
        NewRip( target )
    end
    if tracked_rips[ target ].applications < 3 then
        tracked_rips[ target ].extension = tracked_rips[ target ].extension + 2
        tracked_rips[ target ].applications = tracked_rips[ target ].applications + 1
    end
end

local function RemoveRip( target )
    tracked_rips[ target ] = nil
end

local function GetTrackedRip( target )
    if not tracked_rips[ target ] then
        NewRip( target )
    end
    return tracked_rips[ target ]
end


-- Combat log handlers
local attack_events = {
    SPELL_CAST_SUCCESS = true
}

local application_events = {
    SPELL_AURA_APPLIED      = true,
    SPELL_AURA_APPLIED_DOSE = true,
    SPELL_AURA_REFRESH      = true,
}

local removal_events = {
    SPELL_AURA_REMOVED      = true,
    SPELL_AURA_BROKEN       = true,
    SPELL_AURA_BROKEN_SPELL = true,
}

local death_events = {
    UNIT_DIED               = true,
    UNIT_DESTROYED          = true,
    UNIT_DISSIPATES         = true,
    PARTY_KILL              = true,
    SPELL_INSTAKILL         = true,
}

local eclipse_lunar_last_applied = 0
local eclipse_solar_last_applied = 0
spec:RegisterCombatLogEvent( function( _, subtype, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName )
    if sourceGUID ~= state.GUID then
        return
    end

    if subtype == "SPELL_AURA_APPLIED" then
        if spellID == 48518 then
            eclipse_lunar_last_applied = GetTime()
        elseif spellID == 48517 then
            eclipse_solar_last_applied = GetTime()
        end
    end

    if state.glyph.shred.enabled then
        if attack_events[subtype] then
            -- Track rip time extension from Glyph of Rip
            local rip = FindUnitDebuffByID( "target", 49800 )
            if rip and spellID == 48572 then
                RipShred( destGUID )
            end
        end

        if application_events[subtype] then
            -- Remove previously tracked rip
            if spellID == 49800 then
                RemoveRip( destGUID )
            end
        end

        if removal_events[subtype] then
            -- Remove previously tracked rip
            if spellID == 49800 then
                RemoveRip( destGUID )
            end
        end

        if death_events[subtype] then
            -- Remove previously tracked rip
            if spellID == 49800 then
                RemoveRip( destGUID )
            end
        end
    end
end, false )

spec:RegisterHook( "UNIT_ELIMINATED", function( guid )
    RemoveRip( guid )
end )

local LastFinisherCp = 0
local LastSeenCp = 0
local CurrentCp = 0
local DruidFinishers = {
    [52610] = true,
    [48577] = true,
    [49800] = true,
    [49802] = true
}

-- 新增by风雪20251129
spec:RegisterStateExpr( "behind_target", function () --目标没有目标，或目标的目标不是玩家，则判断为在目标身后
    return UnitExists("target") and (not UnitExists("targettarget") or UnitGUID("targettarget") ~= UnitGUID("player"))
end )
-- 新增结束

spec:RegisterUnitEvent( "UNIT_SPELLCAST_SUCCEEDED", "player", "target", function(event, unit, _, spellID )
    if DruidFinishers[spellID] then
        LastSeenCp = GetComboPoints("player", "target")
    end
end)

spec:RegisterUnitEvent( "UNIT_POWER_UPDATE", "player", "COMBO_POINTS", function(event, unit)
    CurrentCp = GetComboPoints("player", "target")
    if CurrentCp == 0 and LastSeenCp > 0 then
        LastFinisherCp = LastSeenCp
    end
end)

spec:RegisterStateTable( "rip_tracker", setmetatable( {
    cache = {},
    reset = function( t )
        table.wipe(t.cache)
    end
    }, {
    __index = function( t, k )
        if not t.cache[k] then
            local tr = GetTrackedRip( k )
            if tr then
                t.cache[k] = { extension = tr.extension }
            end
        end
        return t.cache[k]
    end
}))

local lastfinishercp = nil
spec:RegisterStateExpr("last_finisher_cp", function()
    return lastfinishercp
end)

spec:RegisterStateFunction("set_last_finisher_cp", function(val)
    lastfinishercp = val
end)

local training_dummy_cache = {}
local avg_rage_amount = rage_amount()
spec:RegisterHook( "reset_precast", function()
    stat.spell_haste = stat.spell_haste * ( 1 + ( 0.01 * talent.celestial_focus.rank ) + ( buff.natures_grace.up and 0.2 or 0 ) + ( buff.moonkin_form.up and ( talent.improved_moonkin_form.rank * 0.01 ) or 0 ) )

    rip_tracker:reset()
    set_last_finisher_cp(LastFinisherCp)

    if IsCurrentSpell( class.abilities.maul.id ) then
        start_maul()
    end

    avg_rage_amount = rage_amount()

    buff.eclipse_lunar.last_applied = eclipse_lunar_last_applied
    buff.eclipse_solar.last_applied = eclipse_solar_last_applied

    if debuff.training_dummy.up and not training_dummy_cache[target.unit] then
        training_dummy_cache[target.unit] = true
    end
end )

spec:RegisterStateExpr("rage_gain", function()
    return avg_rage_amount
end)

spec:RegisterStateExpr("rip_canextend", function()
    return debuff.rip.up and glyph.shred.enabled and rip_tracker[target.unit].extension < 6
end)

spec:RegisterStateExpr("rip_maxremains", function()
    if debuff.rip.remains == 0 then
        return 0
    else
        return debuff.rip.remains + ((debuff.rip.up and glyph.shred.enabled and (6 - rip_tracker[target.unit].extension)) or 0)
    end
end)

spec:RegisterStateExpr("sr_new_duration", function()
    if combo_points.current == 0 then
        return 0
    end
    return 14 + (set_bonus.tier8feral_4pc == 1 and 8 or 0) + ((combo_points.current - 1) * 5)
end)

spec:RegisterStateExpr( "mainhand_remains", function()
    local next_swing, real_swing, pseudo_swing = 0, 0, 0
    if now == query_time then
        real_swing = nextMH - now
        next_swing = real_swing > 0 and real_swing or 0
    else
        if query_time <= nextMH then
            pseudo_swing = nextMH - query_time
        else
            pseudo_swing = (query_time - nextMH) % mainhand_speed
        end
        next_swing = pseudo_swing
    end
    return next_swing
end)

spec:RegisterStateExpr("should_rake", function()
    if set_bonus.tier9feral_2pc == 1 or set_bonus.tier10feral_4pc == 1 then
        return true
    end

    local r, s = calc_rake_dpe()
    return r >= s
end)

spec:RegisterStateExpr("is_training_dummy", function()
    return training_dummy_cache[target.unit] == true
end)

spec:RegisterStateExpr("ttd", function()
    if is_training_dummy then
        return Hekili.Version:match( "^Dev" ) and settings.dummy_ttd or 300
    end

    return target.time_to_die
end)

spec:RegisterStateExpr("end_thresh", function()
    return 10
end)

spec:RegisterStateExpr("bite_at_end", function()
    --combo_points.current=5&(ttd<end_thresh|debuff.rip.up&ttd-debuff.rip.remains<end_thresh)
    return combo_points.current == 5 and (ttd < end_thresh or debuff.rip.up and ttd - debuff.rip.remains < end_thresh)
end)

spec:RegisterStateExpr("bite_before_rip", function()
    --combo_points.current=5&debuff.rip.remains>=settings.min_bite_rip_remains&buff.savage_roar.remains>=settings.min_bite_sr_remains
    return combo_points.current == 5 and debuff.rip.remains >= settings.min_bite_rip_remains and buff.savage_roar.remains >= settings.min_bite_sr_remains
end)

spec:RegisterStateExpr("bite_during_berserk", function()
    --buff.berserk.up&energy.current<=settings.max_bite_energy
    return buff.berserk.up and energy.current <= settings.max_bite_energy
end)

spec:RegisterStateExpr("ff_during_berserk", function()
    local end_energy = energy.current + (buff.berserk.remains * 10)
    local will_use_roar = buff.savage_roar.remains < buff.berserk.remains
        and combo_points.current > 0
        and end_energy >= action.savage_roar.spend
    local will_use_rip = debuff.rip.remains < buff.berserk.remains
        and combo_points.current == 5
        and end_energy >= action.rip.spend
    local will_use_mangle = buff.mangle.remains < buff.berserk.remains
        and end_energy >= action.mangle_cat.spend
    local will_use_rake = debuff.rake.remains < buff.berserk.remains
        and end_energy >= action.rake.spend
    local will_use_shred = end_energy >= action.shred.spend

    return energy.current <= settings.max_ff_energy or
        not (will_use_roar or will_use_rip or will_use_mangle or will_use_rake or will_use_shred)
end)

spec:RegisterStateExpr("wait_for_tf", function()
    --cooldown.tigers_fury.remains<=buff.berserk.duration&cooldown.tigers_fury.remains+1<ttd-buff.berserk.duration
    return cooldown.tigers_fury.remains <= buff.berserk.duration and cooldown.tigers_fury.remains + 1 < ttd - buff.berserk.duration
end)

spec:RegisterStateExpr("rip_now", function()
    --!debuff.rip.up&combo_points.current=5&ttd>=end_thresh
    local rtn = (not debuff.rip.up)
        and combo_points.current == 5
        and ttd >= end_thresh

    if rtn and buff.clearcasting.up then
        local rip_cast_time = max(1.0, (action.rip.spend - energy.current) / 10 + latency)
        rtn = buff.savage_roar.up and rip_cast_time >= buff.savage_roar.remains
    end

    return rtn
end)

spec:RegisterStateExpr("mangle_refresh_now", function()
    --!debuff.mangle.up&ttd>=1
    return (not debuff.mangle.up) and ttd >= 1
end)

spec:RegisterStateExpr("mangle_refresh_pending", function()
    --debuff.mangle.up&debuff.mangle.remains<ttd-1
    return debuff.mangle.up and debuff.mangle.remains < ttd - 1
end)

spec:RegisterStateExpr("clip_mangle", function()
    local num_mangles_remaining = floor(1 + (ttd - 1 - debuff.mangle.remains) / 60)
    local earliest_mangle = ttd - num_mangles_remaining * 60
    return earliest_mangle <= 0
end)

spec:RegisterStateExpr("ff_procs_ooc", function()
    return glyph.omen_of_clarity.enabled
end)

spec:RegisterStateFunction("calc_rake_dpe", function()
    local armor_pen = stat.armor_pen_rating
    local att_power = stat.attack_power
    local crit_pct = stat.crit / 100
    local boss_armor = 10643*(1-0.05*(debuff.armor_reduction.up and 1 or 0))*(1-0.2*(debuff.major_armor_reduction.up and 1 or 0))*(1-0.2*(debuff.shattering_throw.up and 1 or 0))
    local tigers_fury = buff.tigers_fury.up and 80 or 0
    local shred_idol = set_bonus.idol_of_the_ravenous_beast == 1 and 203 or 0
    local rake_dpe = 3*(358 + 6*att_power/100)/35
    local shred_dpe = ((54.5 + tigers_fury + att_power/14)*2.25 + 666 + shred_idol - 42/35*(att_power/100 + 176))*(1 + 1.266*crit_pct)*(1 - (boss_armor*(1 - armor_pen/1399))/((boss_armor*(1 - armor_pen/1399)) + 15232.5))/42
    return rake_dpe, shred_dpe
end)

spec:RegisterStateFunction("tf_expected_before", function(current_time, future_time)
    if cooldown.tigers_fury.remains > 0 then
        return current_time + cooldown.tigers_fury.remains < future_time
    end
    if buff.berserk.up then
        return current_time + buff.berserk.remains < future_time
    end
    return true
end)

spec:RegisterStateFunction("ff_expected_before", function(current_time, future_time)
    if cooldown.faerie_fire_feral.remains > 0 then
        return current_time + cooldown.faerie_fire_feral.remains < future_time
    end
    return true
end)

spec:RegisterStateFunction("berserk_expected_at", function(current_time, future_time)
    if buff.berserk.up then
        return (
            (future_time < current_time + buff.berserk.remains)
            or (future_time > current_time + cooldown.berserk.remains)
        )
    end
    if cooldown.berserk.remains > 0 then
        return (future_time > current_time + cooldown.berserk.remains)
    end
    if buff.tigers_fury.up then
        return (future_time > current_time + buff.tigers_fury.remains)
    end

    return false
end)

spec:RegisterStateExpr("can_spend_ff", function()
    local max_shreds_without_ff = floor((energy.current + ttd * 10) / (active_enemies > 2 and action.swipe_cat.spend or action.shred.spend))
    local num_shreds_without_ff = min(max_shreds_without_ff, floor(ttd) + 1)
    local num_shreds_with_ff = min(max_shreds_without_ff + 1, floor(ttd))
    return num_shreds_with_ff > num_shreds_without_ff
end)

spec:RegisterStateExpr("wait_for_ff", function()
    local next_ff_energy = energy.current + 10 * (cooldown.faerie_fire_feral.remains + latency)
    local ff_energy_threshold = buff.berserk.up and settings.max_ff_energy or 87
    return ff_procs_ooc
        and can_spend_ff
        and cooldown.faerie_fire_feral.remains < 1.0 - settings.max_ff_delay
        and (next_ff_energy < ff_energy_threshold)
        and (not buff.clearcasting.up)
        and ((not debuff.rip.up) or (debuff.rip.remains > 1.0) or active_enemies > 2)
end)

local pending_actions = {
    mangle_cat = {
        refresh_time = 0,
        refresh_cost = 0
    },
    rake = {
        refresh_time = 0,
        refresh_cost = 0
    },
    rip = {
        refresh_time = 0,
        refresh_cost = 0
    },
    savage_roar = {
        refresh_time = 0,
        refresh_cost = 0
    }
}
local sorted_actions = {}
for entry in pairs(pending_actions) do
    table.insert(sorted_actions, entry)
end
spec:RegisterStateExpr("excess_e", function()
    if active_enemies <= 2 then
        if debuff.rip.up and combo_points.current == 5 then
            pending_actions.rip.refresh_time = query_time + debuff.rip.remains
            pending_actions.rip.refresh_cost = (30 - (set_bonus.tier10feral_2pc == 1 and 10 or 0)) * (berserk_expected_at(query_time, query_time + debuff.rip.remains) and 0.5 or 1)
        else
            pending_actions.rip.refresh_time = 0
            pending_actions.rip.refresh_cost = 0
        end

        if debuff.rake.up and debuff.rake.remains < ttd - 9 and should_rake then
            pending_actions.rake.refresh_time = query_time + debuff.rake.remains
            pending_actions.rake.refresh_cost = (40 - talent.ferocity.rank) * (berserk_expected_at(query_time, query_time + debuff.rake.remains) and 0.5 or 1)
        else
            pending_actions.rake.refresh_time = 0
            pending_actions.rake.refresh_cost = 0
        end

        if debuff.mangle.up and debuff.mangle.remains < ttd - 1 then
            pending_actions.mangle_cat.refresh_time = query_time + debuff.mangle.remains
            pending_actions.mangle_cat.refresh_cost = 40 * (berserk_expected_at(query_time, query_time + debuff.mangle.remains) and 0.5 or 1)
        else
            pending_actions.mangle_cat.refresh_time = 0
            pending_actions.mangle_cat.refresh_cost = 0
        end

        if buff.savage_roar.up and combo_points.current > 0 then
            pending_actions.savage_roar.refresh_time = query_time + buff.savage_roar.remains
            pending_actions.savage_roar.refresh_cost = 25 * (berserk_expected_at(query_time, query_time + buff.savage_roar.remains) and 0.5 or 1)
        else
            pending_actions.savage_roar.refresh_time = 0
            pending_actions.savage_roar.refresh_cost = 0
        end

        if pending_actions.rip.refresh_time > 0 and pending_actions.savage_roar.refresh_time > 0 then
            if pending_actions.rip.refresh_time < pending_actions.savage_roar.refresh_time then
                pending_actions.savage_roar.refresh_time = 0
                pending_actions.savage_roar.refresh_cost = 0
            else
                pending_actions.rip.refresh_time = 0
                pending_actions.rip.refresh_cost = 0
            end
        end
    else
        if buff.savage_roar.up then
            pending_actions.savage_roar.refresh_time = query_time + buff.savage_roar.remains
            pending_actions.savage_roar.refresh_cost = 25 * (berserk_expected_at(query_time, query_time + buff.savage_roar.remains) and 0.5 or 1)
            if combo_points.current == 0 and buff.savage_roar.remains > 1 then
                if set_bonus.idol_of_the_corruptor == 1 or set_bonus.idol_of_mutilation == 1 then
                    pending_actions.mangle_cat.refresh_time = query_time + buff.savage_roar.remains - 1
                    pending_actions.mangle_cat.refresh_cost = 40 * (berserk_expected_at(query_time, query_time + debuff.mangle.remains) and 0.5 or 1)
                    pending_actions.rake.refresh_time = 0
                    pending_actions.rake.refresh_cost = 0
                else
                    pending_actions.rake.refresh_time = query_time + buff.savage_roar.remains - 1
                    pending_actions.rake.refresh_cost = (40 - talent.ferocity.rank) * (berserk_expected_at(query_time, query_time + debuff.rake.remains) and 0.5 or 1)
                    pending_actions.mangle_cat.refresh_time = 0
                    pending_actions.mangle_cat.refresh_cost = 0
                end
            else
                pending_actions.rake.refresh_time = 0
                pending_actions.rake.refresh_cost = 0
                pending_actions.mangle_cat.refresh_time = 0
                pending_actions.mangle_cat.refresh_cost = 0
            end
        else
            pending_actions.savage_roar.refresh_time = 0
            pending_actions.savage_roar.refresh_cost = 0
            pending_actions.rake.refresh_time = 0
            pending_actions.rake.refresh_cost = 0
            pending_actions.mangle_cat.refresh_time = 0
            pending_actions.mangle_cat.refresh_cost = 0
        end
    end

    table.sort(sorted_actions, function(a,b)
        return pending_actions[a].refresh_time < pending_actions[b].refresh_time
    end)

    local floating_energy = 0
    local previous_time = query_time
    local tf_pending = false
    for i = 1, #sorted_actions do
        local entry = sorted_actions[i]
        if pending_actions[entry].refresh_time > 0 then
            local delta_t = pending_actions[entry].refresh_time - previous_time
            if not tf_pending then
                tf_pending = tf_expected_before(query_time, pending_actions[entry].refresh_time)
                if tf_pending then
                    pending_actions[entry].refresh_cost = pending_actions[entry].refresh_cost - 60
                end
            end

            if delta_t < pending_actions[entry].refresh_cost / 10 then
                floating_energy = floating_energy + pending_actions[entry].refresh_cost - 10 * delta_t
                previous_time = pending_actions[entry].refresh_time
            else
                previous_time = previous_time + pending_actions[entry].refresh_cost / 10
            end
        end
    end

    local time_to_cap = query_time + (100 - energy.current) / 10
    local time_to_end = query_time + ttd
    local trinket_active = false
    local earliest_proc = 0
    local earliest_proc_end = 0
    if settings.optimize_trinkets and debuff.rip.up then
        for entry in pairs(trinket) do
            if tonumber(entry) then
                local t = trinket[entry]
                if t.proc and t.ability then
                    local t_action = action[t.ability]
                    if t_action and t_action.cooldown > 0 then
                        local t_buff = nil

                        -- Find the trinket buff to inspect
                        local aura_type = type(t_action.aura)
                        local auras_type = type(t_action.auras)
                        if aura_type == "number" and t_action.aura > 0 
                        or aura_type == "string" and #t_action.aura > 0 then
                            t_buff = buff[t_action.aura]
                        elseif auras_type == "table" then
                            for a in pairs(t_action.auras) do
                                if buff[a].up then
                                    t_buff = buff[a]
                                    break
                                elseif t_buff == nil 
                                or buff[a].last_application > t_buff.last_application then
                                    t_buff = buff[a]
                                end
                            end
                        end

                        if t_buff then
                            local t_earliest_proc = t_buff.last_application > 0 and (t_buff.last_application + t_action.cooldown) or 0
                            if t_earliest_proc > 0 and (earliest_proc == 0 or t_earliest_proc < earliest_proc) then
                                earliest_proc = t_earliest_proc
                                earliest_proc_end = t_earliest_proc + t_buff.duration
                            end
                            trinket_active = trinket_active or t_buff.up
                        end
                    end
                end
            end
        end
        
        if (not trinket_active) and earliest_proc > 0 and earliest_proc < time_to_cap and earliest_proc_end <= time_to_end then
            floating_energy = max(floating_energy, 100)
        end
    end

    if combo_points.current == 5 and not (bite_before_rip or bite_at_end)
        and (not trinket_active) and buff.savage_roar.up and buff.savage_roar.remains < ttd
        and rip_refresh_pending
        and min(buff.savage_roar.remains, debuff.rip.remains) < time_to_cap - query_time then
            floating_energy = max(floating_energy, 100)
    end

    return energy.current - floating_energy
end)

-- 割裂刷新判断 - 优化版 by 哑吡 20260113
-- 修改 by Kiro 20260117 - 添加快照伤害对比逻辑
-- 核心：比较 [新割裂总伤害] vs [旧割裂剩余伤害]，只有新的更好才覆盖
spec:RegisterStateExpr("rip_refresh_pending", function()
    -- 割裂不存在时不需要刷新
    if not debuff.rip.up then return false end
    -- 5星时才考虑刷新
    if combo_points.current < 5 then return false end
    -- 目标即将死亡时不刷新
    if ttd < end_thresh then return false end
    
    -- 计算刷新阈值
    local refresh_threshold = 5 + (settings.rip_leeway or 3)
    
    -- 如果割裂剩余时间充足，不需要刷新
    if debuff.rip.remains >= refresh_threshold then return false end
    
    -- === 计算当前快照强度 ===
    local current_snapshot = 1.0
    
    -- 老虎之怒 (+15% 物理伤害)
    if buff.tigers_fury.up then
        current_snapshot = current_snapshot * 1.15
    end
    
    -- 野蛮咆哮 (+30% 物理伤害)
    if buff.savage_roar.up then
        current_snapshot = current_snapshot * 1.30
    end
    
    -- 饰品buff (+10% 估算)
    if settings.optimize_trinkets then
        if buff.greatness.up or buff.grim_toll.up or buff.mjolnir_runestone.up then
            current_snapshot = current_snapshot * 1.10
        end
    end
    
    -- === 估算旧割裂的快照强度 ===
    -- 假设旧割裂至少有野蛮咆哮（正常循环应该一直保持）
    -- 但可能没有老虎之怒和饰品
    local old_snapshot = 1.30
    
    -- === 关键：伤害对比 ===
    -- 新割裂持续时间：22秒（5星）
    local new_rip_duration = 22
    -- 旧割裂剩余时间
    local old_rip_remains = debuff.rip.remains
    
    -- 新割裂总伤害 = 新快照 × 新持续时间
    local new_rip_total_damage = current_snapshot * new_rip_duration
    
    -- 旧割裂剩余伤害 = 旧快照 × 剩余时间
    local old_rip_remaining_damage = old_snapshot * old_rip_remains
    
    -- === 决策逻辑 ===
    
    -- 情况1：割裂即将过期（<2秒），必须刷新
    if debuff.rip.remains < 2 then
        return true
    end
    
    -- 情况2：新割裂总伤害 > 旧割裂剩余伤害，提前覆盖有收益
    -- 但要留一定余量（1.05倍），避免频繁刷新
    if new_rip_total_damage > old_rip_remaining_damage * 1.05 then
        return true
    end
    
    -- 情况3：新割裂伤害不如旧割裂剩余伤害
    -- 等到割裂自然结束（剩余<2秒）再补，避免损失
    -- 但如果剩余时间<5秒，为了防止断档，还是要刷新
    if debuff.rip.remains < 5 then
        return true
    end
    
    -- 默认：不刷新
    return false
end)

-- 花织（治疗织入）条件 by 哑吡 20251225
spec:RegisterStateExpr("should_flowerweave", function()
    -- 检查是否启用花织
    if not settings.enable_flowerweave then return false end
    -- 检查是否在猫形态
    if not buff.cat_form.up then return false end
    -- 检查法力值是否足够
    if mana.percent < (settings.min_weave_mana or 20) then return false end
    -- 检查能量是否较低（适合切出去治疗）
    if energy.current >= 45 then return false end
    return true
end)

-- 熊织（熊形态织入）条件 by 哑吡 20251225
spec:RegisterStateExpr("should_bearweave", function()
    -- 检查是否启用熊织
    if not settings.enable_bearweave then return false end
    -- 检查是否在猫形态
    if not buff.cat_form.up then return false end
    -- 检查能量是否较低（适合切熊）
    if energy.current >= 30 then return false end
    return true
end)

-- 爪击/撕碎选择条件 by 哑吡 20251227
-- 修改 by Kiro 20260116: 野外单独用爪击，团队/副本/城市木桩用撕碎
spec:RegisterStateExpr("should_use_claw", function()
    -- 检测目标是否是训练假人（多种方式检测）
    -- 1. 通过缓存检测
    if is_training_dummy then return false end
    
    -- 2. 通过目标名称检测（包含 "Training Dummy" 或 "训练假人"）
    if UnitExists("target") then
        local targetName = UnitName("target") or ""
        -- 检测常见的训练假人名称
        if targetName:find("Training Dummy") or targetName:find("训练假人") or targetName:find("假人") or targetName:find("Dummy") then
            return false
        end
        -- 检测目标是否不会反击（训练假人的特征）
        local classification = UnitClassification("target") or ""
        if classification == "worldboss" and not UnitCanAttack("target", "player") then
            return false
        end
    end
    
    -- 获取实例类型
    local instanceType = select(2, GetInstanceInfo()) or "none"
    
    -- 副本内（party/raid）使用撕碎
    if instanceType == "party" or instanceType == "raid" then
        return false
    end
    
    -- 主城/休息区内使用撕碎（方便打木桩测试）
    if IsResting() then
        return false
    end
    
    -- 竞技场和战场使用爪击
    if instanceType == "arena" or instanceType == "pvp" then
        return true
    end
    
    -- 野外（none）使用爪击
    if instanceType == "none" then
        return true
    end
    
    -- 默认使用撕碎
    return false
end)

-- 熊织启用标志 - APL 使用 by 哑吡 20260101
spec:RegisterStateExpr("bearweaving_enabled", function()
    return settings.enable_bearweave or false
end)

-- 熊坦模式启用标志 - APL 使用 by 哑吡 20260101
spec:RegisterStateExpr("bear_mode_tank_enabled", function()
    return settings.enable_bear_tank or false
end)

-- 熊织时判断是否应该切回猫形态 by 哑吡 20260101
spec:RegisterStateExpr("should_cat", function()
    -- 在熊形态下，判断是否应该切回猫形态
    if not buff.dire_bear_form.up then return false end
    -- 能量恢复到一定程度时切回猫
    if energy.current >= 80 then return true end
    -- 清晰预兆触发时切回猫
    if buff.clearcasting.up then return true end
    return false
end)

-- Resources
spec:RegisterResource( Enum.PowerType.Rage, {
    enrage = {
        aura = "enrage",

        last = function ()
            local app = state.buff.enrage.applied
            local t = state.query_time

            return app + floor( t - app )
        end,

        interval = 1,
        value = 2
    },

    mainhand = {
        swing = "mainhand",
        aura = "dire_bear_form",

        last = function ()
            local swing = state.combat == 0 and state.now or state.swings.mainhand
            local t = state.query_time

            return swing + ( floor( ( t - swing ) / state.swings.mainhand_speed ) * state.swings.mainhand_speed )
        end,

        interval = "mainhand_speed",

        stop = function () return state.swings.mainhand == 0 end,
        value = function( now )
            return state.buff.maul.expires < now and rage_amount() or 0
        end,
    },
} )
spec:RegisterResource( Enum.PowerType.Mana )
spec:RegisterResource( Enum.PowerType.ComboPoints )
spec:RegisterResource( Enum.PowerType.Energy )


-- Talents
spec:RegisterTalents( {
    balance_of_power            = {  1783, 2, 33592, 33596 },
    berserk                     = {  1927, 1, 50334 },
    brambles                    = {   782, 3, 16836, 16839, 16840 },
    brutal_impact               = {   797, 2, 16940, 16941 },
    celestial_focus             = {   784, 3, 16850, 16923, 16924 },
    dreamstate                  = {  1784, 3, 33597, 33599, 33956 },
    earth_and_moon              = {  1928, 3, 48506, 48510, 48511 },
    eclipse                     = {  1924, 3, 48516, 48521, 48525 },
    empowered_rejuvenation      = {  1789, 5, 33886, 33887, 33888, 33889, 33890 },
    empowered_touch             = {  1788, 2, 33879, 33880 },
    feral_aggression            = {   795, 5, 16858, 16859, 16860, 16861, 16862 },
    feral_charge                = {   804, 1, 49377 },
    feral_instinct              = {   799, 3, 16947, 16948, 16949 },
    feral_swiftness             = {   807, 2, 17002, 24866 },
    ferocity                    = {   796, 5, 16934, 16935, 16936, 16937, 16938 },
    force_of_nature             = {  1787, 1, 33831 },
    furor                       = {   822, 5, 17056, 17058, 17059, 17060, 17061 },
    gale_winds                  = {  1925, 2, 48488, 48514 },
    genesis                     = {  2238, 5, 57810, 57811, 57812, 57813, 57814 },
    gift_of_nature              = {   828, 5, 17104, 24943, 24944, 24945, 24946 },
    gift_of_the_earthmother     = {  1916, 5, 51179, 51180, 51181, 51182, 51183 },
    heart_of_the_wild           = {   808, 5, 17003, 17004, 17005, 17006, 24894 },
    improved_barkskin           = {  2264, 2, 63410, 63411 },
    improved_faerie_fire        = {  1785, 3, 33600, 33601, 33602 },
    improved_insect_swarm       = {  2239, 3, 57849, 57850, 57851 },
    improved_leader_of_the_pack = {  1798, 2, 34297, 34300 },
    improved_mangle             = {  1920, 3, 48532, 48489, 48491 },
    improved_mark_of_the_wild   = {   821, 2, 17050, 17051 },
    improved_moonfire           = {   763, 2, 16821, 16822 },
    improved_moonkin_form       = {  1912, 3, 48384, 48395, 48396 },
    improved_rejuvenation       = {   830, 3, 17111, 17112, 17113 },
    improved_tranquility        = {   842, 2, 17123, 17124 },
    improved_tree_of_life       = {  1930, 3, 48535, 48536, 48537 },
    infected_wounds             = {  1919, 3, 48483, 48484, 48485 },
    insect_swarm                = {   788, 1,  5570 },
    intensity                   = {   829, 3, 17106, 17107, 17108 },
    king_of_the_jungle          = {  1921, 3, 48492, 48494, 48495 },
    leader_of_the_pack          = {   809, 1, 17007 },
    living_seed                 = {  1922, 3, 48496, 48499, 48500 },
    living_spirit               = {  1797, 3, 34151, 34152, 34153 },
    lunar_guidance              = {  1782, 3, 33589, 33590, 33591 },
    mangle                      = {  1796, 1, 33917 },
    master_shapeshifter         = {  1915, 2, 48411, 48412 },
    moonfury                    = {   790, 3, 16896, 16897, 16899 },
    moonglow                    = {   783, 3, 16845, 16846, 16847 },
    moonkin_form                = {   793, 1, 24858 },
    natural_perfection          = {  1790, 3, 33881, 33882, 33883 },
    natural_reaction            = {  2242, 3, 57878, 57880, 57881 },
    natural_shapeshifter        = {   826, 3, 16833, 16834, 16835 },
    naturalist                  = {   824, 5, 17069, 17070, 17071, 17072, 17073 },
    natures_bounty              = {   825, 5, 17074, 17075, 17076, 17077, 17078 },
    natures_focus               = {   823, 3, 17063, 17065, 17066 },
    natures_grace               = {   789, 3, 16880, 61345, 61346 },
    natures_majesty             = {  1822, 2, 35363, 35364 },
    natures_reach               = {   764, 2, 16819, 16820 },
    natures_splendor            = {  2240, 1, 57865 },
    natures_swiftness           = {   831, 1, 17116 },
    nurturing_instinct          = {  1792, 2, 33872, 33873 },
    omen_of_clarity             = {   827, 1, 16864 },
    owlkin_frenzy               = {  1913, 3, 48389, 48392, 48393 },
    predatory_instincts         = {  1795, 3, 33859, 33866, 33867 },
    predatory_strikes           = {   803, 3, 16972, 16974, 16975 },
    primal_fury                 = {   801, 2, 37116, 37117 },
    primal_gore                 = {  2266, 1, 63503 },
    primal_precision            = {  1914, 2, 48409, 48410 },
    primal_tenacity             = {  1793, 3, 33851, 33852, 33957 },
    protector_of_the_pack       = {  2241, 3, 57873, 57876, 57877 },
    rend_and_tear               = {  1918, 5, 48432, 48433, 48434, 51268, 51269 },
    revitalize                  = {  1929, 3, 48539, 48544, 48545 },
    savage_fury                 = {   805, 2, 16998, 16999 },
    sharpened_claws             = {   798, 3, 16942, 16943, 16944 },
    shredding_attacks           = {   802, 2, 16966, 16968 }, --撕碎攻击
    starfall                    = {  1926, 1, 48505 },
    starlight_wrath             = {   762, 5, 16814, 16815, 16816, 16817, 16818 },
    subtlety                    = {   841, 3, 17118, 17119, 17120 },
    survival_instincts          = {  1162, 1, 61336 },
    survival_of_the_fittest     = {  1794, 3, 33853, 33855, 33856 },
    swiftmend                   = {   844, 1, 18562 },
    thick_hide                  = {   794, 3, 16929, 16930, 16931 },
    tranquil_spirit             = {   843, 5, 24968, 24969, 24970, 24971, 24972 },
    tree_of_life                = {  1791, 1, 65139 },
    typhoon                     = {  1923, 1, 50516 },
    vengeance                   = {   792, 5, 16909, 16910, 16911, 16912, 16913 },
    wild_growth                 = {  1917, 1, 48438 },
    wrath_of_cenarius           = {  1786, 5, 33603, 33604, 33605, 33606, 33607 },
} )


-- Glyphs
spec:RegisterGlyphs( {
    [57856] = "aquatic_form",
    [63057] = "barkskin",
    [62969] = "berserk",
    [57858] = "challenging_roar",
    [67598] = "claw",
    [59219] = "dash",
    [54760] = "entangling_roots",
    [62080] = "focus",
    [54810] = "frenzied_regeneration",
    [54812] = "growling",
    [54825] = "healing_touch",
    [54831] = "hurricane",
    [54832] = "innervate",
    [54830] = "insect_swarm",
    [54826] = "lifebloom",
    [54813] = "mangle",
    [54811] = "maul",
    [63056] = "monsoon",
    [54829] = "moonfire",
    [52084] = "natural_force",
    [62971] = "nourish",
    [413895] = "omen_of_clarity",
    [54821] = "rake",
    [71013] = "rapid_rejuvenation",
    [54733] = "rebirth",
    [54743] = "regrowth",
    [54754] = "rejuvenation",
    [54818] = "rip",
    [63055] = "savage_roar",
    [54815] = "shred",
    [54828] = "starfall",
    [54845] = "starfire",
    [65243] = "survival_instincts",
    [54824] = "swiftmend",
    [58136] = "bear_cub",
    [58133] = "forest_lynx",
    [52648] = "penguin",
    [54912] = "red_lynx",
    [57855] = "wild",
    [57862] = "thorns",
    [62135] = "typhoon",
    [57857] = "unburdened_rebirth",
    [62970] = "wild_growth",
    [54756] = "wrath",
} )


-- Auras
spec:RegisterAuras( {
    -- Attempts to cure $3137s1 poison every $t1 seconds.
    abolish_poison = {
        id = 2893,
        duration = 12,
        tick_time = 3,
        max_stack = 1,
    },
    -- Immune to Polymorph effects.  Increases swim speed by $5421s1% and allows underwater breathing.
    aquatic_form = {
        id = 1066,
        duration = 3600,
        max_stack = 1,
    },
    -- All damage taken is reduced by $s2%.  While protected, damaging attacks will not cause spellcasting delays.
    barkskin = {
        id = 22812,
        duration = function() return 12 + ((set_bonus.tier7feral_4pc == 1 and 3) or 0) end,
        max_stack = 1,
    },
    -- Stunned.
    bash = {
        id = 5211,
        duration = function() return 4 + ( 0.5 * talent.brutal_impact.rank ) end,
        max_stack = 1,
        copy = { 5211, 6798, 8983, 58861 },
    },
    bear_form = {
        id = 5487,
        duration = 3600,
        max_stack = 1,
        copy = { 5487, 9634 }
    },
    -- Immune to Fear effects.
    berserk = { --狂暴 修改by风雪 20251201
        id = 50334,
        duration = function()
            local base = 15
            if glyph.berserk.enabled then base = base + 5 end
            if set_bonus.tier1feral_4pc == 1 then base = base + 3 end --考虑T1套装4件套
            return base
        end,
        max_stack = 1,
    },
    -- Immunity to Polymorph effects.  Increases melee attack power by $3025s1 plus Agility.
    cat_form = {
        id = 768,
        duration = 3600,
        max_stack = 1,
    },
    -- Taunted.
    challenging_roar = {
        id = 5209,
        duration = 6,
        max_stack = 1,
    },
    -- Your next damage or healing spell or offensive ability has its mana, rage or energy cost reduced by $s1%.
    clearcasting = {
        id = 16870,
        duration = 15,
        max_stack = 1,
        copy = "omen_of_clarity"
    },
    -- Invulnerable, but unable to act.
    cyclone = {
        id = 33786,
        duration = 6,
        max_stack = 1,
    },
    -- Increases movement speed by $s1% while in Cat Form.
    dash = {
        id = 33357,
        duration = 15,
        max_stack = 1,
        copy = { 1850, 9821, 33357 },
    },
    -- Dazed.
    dazed = {
        id = 50411,
        duration = 3,
        max_stack = 1,
        copy = { 50411, 50259 },
    },
    -- Decreases melee attack power by $s1.
    demoralizing_roar = {
        id = 48560,
        duration = 30,
        max_stack = 1,
        copy = { 99, 1735, 9490, 9747, 9898, 26998, 48559, 48560 },
    },
    -- Immune to Polymorph effects.  Increases melee attack power by $9635s3, armor contribution from cloth and leather items by $9635s1%, and Stamina by $9635s2%.
    dire_bear_form = {
        id = 9634,
        duration = 3600,
        max_stack = 1,
        copy = { 9634, 5487, "bear_form" }, -- 添加普通熊形态ID，让40级前也能识别
    },
    -- Increases spell damage taken by $s1%.
    earth_and_moon = {
        id = 60433,
        duration = 12,
        max_stack = 1,
        copy = { 60433, 60432, 60431 },
    },
    -- Starfire critical hit +40%.
    eclipse_lunar = {
        id = 48518,
        duration = 15,
        max_stack = 1,
        last_applied = 0,
        copy = "lunar_eclipse",
    },
    -- Wrath damage bonus.
    eclipse_solar = {
        id = 48517,
        duration = 15,
        max_stack = 1,
        last_applied = 0,
        copy = "eclipse_solar",
    },
    eclipse = {
        alias = { "eclipse_lunar", "eclipse_solar" },
        aliasType = "buff",
        aliasMode = "first"
    },
    -- Your next Starfire will be an instant cast spell.
    elunes_wrath = {
        id = 64823,
        duration = 10,
        max_stack = 1,
    },
    -- Gain $/10;s1 rage per second.  Base armor reduced.
    enrage = {
        id = 5229,
        duration = 10,
        tick_time = 1,
        max_stack = 1,
    },
    -- Rooted.  Causes $s2 Nature damage every $t2 seconds.
    entangling_roots = {
        id = 19975,
        duration = 12,
        max_stack = 1,
        copy = { 339, 1062, 5195, 5196, 9852, 9853, 19970, 19971, 19972, 19973, 19974, 19975, 26989, 27010, 53308, 53313, 65857, 66070 },
    },
    feline_grace = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=20719)
        id = 20719,
        duration = 3600,
        max_stack = 1,
    },
    feral_aggression = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=16862)
        id = 16862,
        duration = 3600,
        max_stack = 1,
        copy = { 16862, 16861, 16860, 16859, 16858 },
    },
    -- Immobilized.
    feral_charge_effect = {
        id = 45334,
        duration = 4,
        max_stack = 1,
        copy = { 45334, 19675 },
    },
    flight_form = {
        id = 33943,
        duration = 3600,
        max_stack = 1,
    },
    force_of_nature = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=33831)
        id = 33831,
        duration = 30,
        max_stack = 1,
    },
    form = {
        alias = { "aquatic_form", "cat_form", "bear_form", "dire_bear_form", "flight_form", "moonkin_form", "swift_flight_form", "travel_form"  },
        aliasType = "buff",
        aliasMode = "first"
    },
    -- Converting rage into health.
    frenzied_regeneration = {
        id = 22842,
        duration = 10,
        tick_time = 1,
        max_stack = 1,
        copy = { 22842, 22895, 22896, 26999 },
    },
    -- Taunted.
    growl = {
        id = 6795,
        duration = 3,
        max_stack = 1,
    },
    -- Asleep.
    hibernate = {
        id = 2637,
        duration = 20,
        max_stack = 1,
        copy = { 2637, 18657, 18658 },
    },
    -- $42231s1 damage every $t3 seconds, and time between attacks increased by $s2%.$?$w1<0[ Movement slowed by $w1%.][]
    hurricane = {
        id = 16914,
        duration = function() return 10 * haste end,
        tick_time = function() return 1 * haste end,
        max_stack = 1,
        copy = { 16914, 17401, 17402, 27012, 48467 },
    },
    improved_moonfire = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=16822)
        id = 16822,
        duration = 3600,
        max_stack = 1,
        copy = { 16822, 16821 },
    },
    improved_rejuvenation = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=17113)
        id = 17113,
        duration = 3600,
        max_stack = 1,
        copy = { 17113, 17112, 17111 },
    },
    -- Movement speed slowed by $s1% and attack speed slowed by $s2%.
    infected_wounds = {
        id = 58181,
        duration = 12,
        max_stack = 1,
        copy = { 58181, 58180, 58179 },
    },
    -- Regenerating mana.
    innervate = {
        id = 29166,
        duration = 10,
        tick_time = 1,
        max_stack = 1,
    },
    -- Chance to hit with melee and ranged attacks decreased by $s2% and $s1 Nature damage every $t1 sec.
    insect_swarm = {
        id = 5570,
        duration = function() return 12 + (talent.natures_splendor.enabled and 2 or 0) end,
        tick_time = 2,
        max_stack = 1,
        copy = { 5570, 24974, 24975, 24976, 24977, 27013, 48468 },
    },
    -- $s1 damage every $t sec
    lacerate = {
        id = 48568,
        duration = 15,
        tick_time = 3,
        max_stack = 5,
        copy = { 33745, 48567, 48568 },
    },
    -- Heals $s1 every second and $s2 when effect finishes or is dispelled.
    lifebloom = {
        id = 33763,
        duration = function() return glyph.lifebloom.enabled and 8 or 7 end,
        tick_time = 1,
        max_stack = 3,
        copy = { 33763, 48450, 48451 },
    },
    living_spirit = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=34153)
        id = 34153,
        duration = 3600,
        max_stack = 1,
        copy = { 34153, 34152, 34151 },
    },
    maul = {
        duration = function () return swings.mainhand_speed end,
        max_stack = 1,
    },
    -- $s1 Arcane damage every $t1 seconds.
    moonfire = {
        id = 8921,
        duration = function() return 9 + (talent.natures_splendor.enabled and 3 or 0) end,
        tick_time = 3,
        max_stack = 1,
        copy = { 8921, 8924, 8925, 8926, 8927, 8928, 8929, 9833, 9834, 9835, 26987, 26988, 48462, 48463, 65856 },
    },
    -- Increases spell critical chance by $s1%.
    moonkin_aura = {
        id = 24907,
        duration = 3600,
        max_stack = 1,
    },
    -- Immune to Polymorph effects.  Armor contribution from items is increased by $24905s1%.  Damage taken while stunned reduced $69366s1%.  Single target spell criticals instantly regenerate $53506s1% of your total mana.
    moonkin_form = {
        id = 24858,
        duration = 3600,
        max_stack = 1,
    },
    -- Reduces all damage taken by $s1%.
    natural_perfection = {
        id = 45283,
        duration = 8,
        max_stack = 3,
        copy = { 45281, 45282, 45283 },
    },
    natural_shapeshifter = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=16835)
        id = 16835,
        duration = 6,
        max_stack = 1,
        copy = { 16835, 16834, 16833 },
    },
    naturalist = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=17073)
        id = 17073,
        duration = 3600,
        max_stack = 1,
        copy = { 17073, 17072, 17071, 17070, 17069 },
    },
    -- Spell casting speed increased by $s1%.
    natures_grace = {
        id = 16886,
        duration = 3,
        max_stack = 1,
    },
    -- Melee damage you take has a chance to entangle the enemy.
    natures_grasp = {
        id = 16689,
        duration = 45,
        max_stack = 1,
        copy = { 16689, 16810, 16811, 16812, 16813, 17329, 27009, 53312, 66071 },
    },
    -- Your next Nature spell will be an instant cast spell.
    natures_swiftness = {
        id = 17116,
        duration = 3600,
        max_stack = 1,
    },
    -- Damage increased by $s2%, $s3% base mana is restored every $T3 sec, and damage done to you no longer causes pushback.
    owlkin_frenzy = {
        id = 48391,
        duration = 10,
        max_stack = 1,
    },
    -- Stunned.
    pounce = {
        id = 49803,
        duration = 3,
        max_stack = 1,
        copy = { 9005, 9823, 9827, 27006, 49803 },
    },
    -- Bleeding for $s1 damage every $t1 seconds.
    pounce_bleed = {
        id = 49804,
        duration = 18,
        tick_time = 3,
        max_stack = 1,
        copy = { 9007, 9824, 9826, 27007, 49804 },
    },
    -- Your next Nature spell will be an instant cast spell.
    predators_swiftness = {
        id = 69369,
        duration = 8,
        max_stack = 1,
    },
    -- Stealthed.  Movement speed slowed by $s2%.
    prowl = {
        id = 5215,
        duration = 3600,
        max_stack = 1,
    },
    -- Bleeding for $s2 damage every $t2 seconds.
    rake = {
        id = 48574,
        duration = function() return 9 + ((set_bonus.tier9feral_2pc == 1 and 3) or 0) end,
        max_stack = 1,
        copy = { 1822, 1823, 1824, 9904, 27003, 48573, 48574, 59881, 59882, 59883, 59884, 59885, 59886 },
    },
    -- Heals $s2 every $t2 seconds.
    regrowth = {
        id = 8936,
        duration = 21,
        max_stack = 1,
        copy = { 8936, 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858, 26980, 48442, 48443, 66067 },
    },
    -- Heals $s1 damage every $t1 seconds.
    rejuvenation = {
        id = 774,
        duration = 15,
        tick_time = 3,
        max_stack = 1,
        copy = { 774, 1058, 1430, 2090, 2091, 3627, 8070, 8910, 9839, 9840, 9841, 25299, 26981, 26982, 48440, 48441 },
    },
    -- Bleed damage every $t1 seconds.
    rip = {
        id = 49800,
        duration = function() return 12 + ((glyph.rip.enabled and 4) or 0) + ((set_bonus.tier7feral_2pc == 1 and 4) or 0) end,
        tick_time = 2,
        max_stack = 1,
        copy = { 1079, 9492, 9493, 9752, 9894, 9896, 27008, 49799, 49800 },
    },
    -- Absorbs physical damage equal to $s1% of your attack power for 1 hit.
    savage_defense = {
        id = 62606,
        duration = 10,
        max_stack = 1,
    },
    -- Physical damage done increased by $s2%.
    savage_roar = {
        id = 52610,
        duration = function()
            if combo_points.current == 0 then
                return 0
            end
            return 14 + (set_bonus.tier8feral_4pc == 1 and 8 or 0) + ((combo_points.current - 1) * 5)
        end,
        max_stack = 1,
        copy = { 52610 },
    },
    sharpened_claws = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=16944)
        id = 16944,
        duration = 3600,
        max_stack = 1,
        copy = { 16944, 16943, 16942 },
    },
    shredding_attacks = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=16968)
        id = 16968,
        duration = 3600,
        max_stack = 1,
        copy = { 16968, 16966 },
    },
    -- Reduced distance at which target will attack.
    soothe_animal = {
        id = 2908,
        duration = 15,
        max_stack = 1,
        copy = { 2908, 8955, 9901, 26995 },
    },
    -- Summoning stars from the sky.
    starfall = {
        id = 48505,
        duration = 10,
        tick_time = 1,
        max_stack = 1,
        copy = { 48505, 50286, 50288, 50294, 53188, 53189, 53190, 53191, 53194, 53195, 53196, 53197, 53198, 53199, 53200, 53201 },
    },
    starlight_wrath = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=16818)
        id = 16818,
        duration = 3600,
        max_stack = 1,
        copy = { 16818, 16817, 16816, 16815, 16814 },
    },
    -- Health increased by 30% of maximum while in Bear Form, Cat Form, or Dire Bear Form.
    survival_instincts = {
        id = 61336,
        duration = 20,
        max_stack = 1,
    },
    -- Immune to Polymorph effects.  Movement speed increased by $40121s2% and allows you to fly.
    swift_flight_form = {
        id = 40120,
        duration = 3600,
        max_stack = 1,
    },
    -- Causes $s1 Nature damage to attackers.
    thorns = {
        id = 467,
        duration = function() return glyph.thorns.enabled and 6000 or 600 end,
        max_stack = 1,
        copy = { 467, 782, 1075, 8914, 9756, 9910, 16877, 26992, 53307, 66068 },
    },
    -- Increases damage done by $s1.
    tigers_fury = {
        id = 50213,
        duration = 6,
        max_stack = 1,
        copy = { 5217, 6793, 9845, 9846, 50212, 50213 },
    },
    -- Tracking humanoids.
    track_humanoids = {
        id = 5225,
        duration = 3600,
        max_stack = 1,
    },
    -- Heals nearby party members for $s1 every $t2 seconds.
    tranquility = {
        id = 740,
        duration = 8,
        max_stack = 1,
        copy = { 740, 8918, 9862, 9863, 26983, 48446, 48447 },
    },
    -- Immune to Polymorph effects.  Movement speed increased by $5419s1%.
    travel_form = {
        id = 783,
        duration = 3600,
        max_stack = 1,
    },
    -- Immune to Polymorph effects. Increases healing received by $34123s1% for all party and raid members within $34123a1 yards.
    tree_of_life = {
        id = 33891,
        duration = 3600,
        max_stack = 1,
    },
    -- Dazed.
    typhoon = {
        id = 61391,
        duration = 6,
        max_stack = 1,
        copy = { 53227, 61387, 61388, 61390, 61391 },
    },
    -- Stunned.
    war_stomp = {
        id = 20549,
        duration = 2,
        max_stack = 1,
    },
    -- Heals $s1 damage every $t1 second.
    wild_growth = {
        id = 48438,
        duration = 7,
        tick_time = 1,
        max_stack = 1,
        copy = { 48438, 53248, 53249, 53251 },
    },
    wrath_of_cenarius = { -- TODO: Check Aura (https://wowhead.com/wotlk/spell=33607)
        id = 33607,
        duration = 3600,
        max_stack = 1,
        copy = { 33607, 33606, 33605, 33604, 33603 },
    },

    rupture = {
        id = 48672,
        duration = 6,
        max_stack = 1,
        shared = "target",
        copy = { 1943, 8639, 8640, 11273, 11274, 11275, 26867, 48671 }
    },
    garrote = {
        id = 48676,
        duration = 18,
        max_stack = 1,
        shared = "target",
        copy = { 703, 8631, 8632, 8633, 11289, 11290, 26839, 26884, 48675 }
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
        shared = "target"
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
} )


-- Form Helper
spec:RegisterStateFunction( "swap_form", function( form )
    removeBuff( "form" )
    removeBuff( "maul" )

    if form == "bear_form" or form == "dire_bear_form" then
        spend( rage.current, "rage" )
        if talent.furor.rank==5 then
            gain( 10, "rage" )
        end
    end

    if form then
        applyBuff( form )
    end
end )

-- Maul Helper
local finish_maul = setfenv( function()
    spend( (buff.clearcasting.up and 0) or ((15 - talent.ferocity.rank) * ((buff.berserk.up and 0.5) or 1)), "rage" )
end, state )

spec:RegisterStateFunction( "start_maul", function()
    local next_swing = mainhand_remains
    if next_swing <= 0 then
        next_swing = mainhand_speed
    end
    applyBuff( "maul", next_swing )
    state:QueueAuraExpiration( "maul", finish_maul, buff.maul.expires )
end )


-- Abilities
spec:RegisterAbilities( {
    -- Attempts to cure 1 poison effect on the target, and 1 more poison effect every 3 seconds for 12 sec.
    abolish_poison = {
        id = 2893,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.13,
        spendType = "mana",

        startsCombat = false,
        texture = 136068,

        handler = function ()
            applyBuff( "abolish_poison" )
        end,
    },


    -- Shapeshift into aquatic form, increasing swim speed by 50% and allowing the druid to breathe underwater.  Also protects the caster from Polymorph effects.    The act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.
    aquatic_form = {
        id = 1066,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.13,
        spendType = "mana",

        startsCombat = true,
        texture = 132112,

        handler = function ()
            swap_form( "aquatic_form" )
        end,
    },


    -- The druid's skin becomes as tough as bark.  All damage taken is reduced by 20%.  While protected, damaging attacks will not cause spellcasting delays.  This spell is usable while stunned, frozen, incapacitated, feared or asleep.  Usable in all forms.  Lasts 12 sec.
    barkskin = {
        id = 22812,
        cast = 0,
        cooldown = function() return 60 - ((set_bonus.tier9feral_4pc == 1 and 12) or 0) end,
        gcd = "off",

        startsCombat = false,
        texture = 136097,

        toggle = "defensives",

        handler = function ()
            applyBuff( "barkskin" )
        end,
    },


    -- Stuns the target for 4 sec and interrupts non-player spellcasting for 3 sec.
    bash = {
        id = 8983,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 10 end,
        spendType = "rage",

        startsCombat = true,
        texture = 132114,

        toggle = "interrupts",

        handler = function ()
            removeBuff( "clearcasting" )
            applyDebuff( "target", "bash" )
            interrupt()
        end,
    },

    -- When activated, this ability causes your Mangle (Bear) ability to hit up to 3 targets and have no cooldown, and reduces the energy cost of all your Cat Form abilities by 50%.  Lasts 15 sec.  You cannot use Tiger's Fury while Berserk is active.     Clears the effect of Fear and makes you immune to Fear for the duration.
    berserk = { --狂暴
        id = 50334,
        cast = 0,
        cooldown = 180,
        gcd = "totem",

        spend = 0,
        spendType = "energy",

        talent = "berserk",
        startsCombat = false,
        texture = 236149,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "berserk" )
        end,
    },


    -- Shapeshift into cat form, increasing melee attack power by 160 plus Agility.  Also protects the caster from Polymorph effects and allows the use of various cat abilities.    The act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.
    cat_form = {
        id = 768,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return 0.35 * ((talent.king_of_the_jungle.rank > 0 and 0.60) or 1) * ((talent.natural_shapeshifter.rank > 0 and 0.30) or 1) end,
        spendType = "mana",

        startsCombat = true,
        texture = 132115,

        handler = function ()
            swap_form( "cat_form" )
        end,
    },


    -- Forces all nearby enemies within 10 yards to focus attacks on you for 6 sec.
    challenging_roar = {
        id = 5209,
        cast = 0,
        cooldown = function() return glyph.challenging_roar.enabled and 150 or 180 end,
        gcd = "spell",

        spend = 15,
        spendType = "rage",

        startsCombat = true,
        texture = 132117,

        toggle = "defensives",

        handler = function ()
            applyDebuff( "target", "challenging_roar" )
        end,
    },


    -- 爪击Claw the enemy, causing 370 additional damage.  Awards 1 combo point.
    -- 修改 by 哑吡 20251230: 连击点少于5时使用爪击攒星
    -- 修改 by Kiro 20260116: 恢复简单usable，通过APL的should_use_claw控制
    claw = {
        id = 48570,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function()
            if buff.clearcasting.up then return 0 end
            local base = 45
            local talent_reduction = talent.ferocity.rank or 0
            local glyph_reduction = glyph.claw.enabled and 5 or 0
            local cost = base - talent_reduction - glyph_reduction
            return buff.berserk.up and cost * 0.5 or cost
        end,
        spendType = "energy",

        startsCombat = true,
        texture = 132140,

        usable = function() return true end,

        handler = function ()
            removeBuff( "clearcasting" )
            gain( 1, "combo_points" )
        end,

        copy = { 1062, 3029, 5201, 9849, 9850, 27000, 48569, 48570 },

    },


    -- Cower, causing no damage but lowering your threat a large amount, making the enemy less likely to attack you.
    cower = {
        id = 48575,
        cast = 0,
        cooldown = 10,
        gcd = "totem",

        spend = function() return 20 * ((buff.berserk.up and 0.5) or 1) end,
        spendType = "energy",

        startsCombat = false,
        texture = 132118,

        handler = function ()
            -- 降低仇恨，无需状态变化
        end,
    },


    -- Cures 1 poison effect on the target.
    cure_poison = {
        id = 8946,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.13,
        spendType = "mana",

        startsCombat = false,
        texture = 136067,

        handler = function ()
            -- 驱散毒素，无需状态变化
        end,
    },


    -- Tosses the enemy target into the air, preventing all action but making them invulnerable for up to 6 sec.  Only one target can be affected by your Cyclone at a time.
    cyclone = {
        id = 33786,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",

        spend = 0.08,
        spendType = "mana",

        startsCombat = true,
        texture = 136022,

        handler = function ()
            applyDebuff( "target", "cyclone" )
        end,
    },


    -- Increases movement speed by 70% while in Cat Form for 15 sec.  Does not break prowling.
    dash = {
        id = 33357,
        cast = 0,
        cooldown = function() return 180 * ( glyph.dash.enabled and 0.8 or 1 ) end,
        gcd = "off",

        spend = 0,
        spendType = "energy",

        startsCombat = false,
        texture = 132120,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "dash" )
        end,
    },


    -- The druid roars, decreasing nearby enemies' melee attack power by 411.  Lasts 30 sec.
    demoralizing_roar = {
        id = 48560,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 10 end,
        spendType = "rage",

        startsCombat = true,
        texture = 132121,

        handler = function ()
            removeBuff( "clearcasting" )
            applyDebuff( "target", "demoralizing_roar" )
        end,
    },


    -- Shapeshift into dire bear form, increasing melee attack power, armor contribution from cloth and leather items, and Stamina. Also protects the caster from Polymorph effects and allows the use of various bear abilities. The act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.
    dire_bear_form = {
        id = 9634,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return 0.35 * ( talent.king_of_the_jungle.enabled and 0.6 or 1 ) * ( talent.natural_shapeshifter.enabled and 0.3 or 1 ) end,
        spendType = "mana",

        startsCombat = true,
        texture = 132276,

        handler = function ()
            swap_form( "dire_bear_form" )
        end,

        copy = { 5487, "bear_form" }
    },


    -- Generates 20 rage, and then generates an additional 10 rage over 10 sec, but reduces base armor by 27% in Bear Form and 16% in Dire Bear Form.
    enrage = {
        id = 5229,
        cast = 0,
        cooldown = 60,
        gcd = "off",

        spend = 0,
        spendType = "rage",

        startsCombat = true,
        texture = 132126,

        toggle = "cooldowns",

        handler = function ()
            gain(20, "rage" )
            applyBuff( "enrage" )
        end,
    },

    -- Roots the target in place and causes 20 Nature damage over 12 sec.  Damage caused may interrupt the effect.
    entangling_roots = {
        id = 339,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.07 end,
        spendType = "mana",

        startsCombat = true,
        texture = 136100,

        handler = function ()
            removeBuff( "clearcasting" )
            applyDebuff( "target", "entangling_roots", 27 )
        end,

        copy = { 1062, 5195, 5196, 9852, 9853, 26989, 53308 },
    },


    -- Decrease the armor of the target by 5% for 5 min.  While affected, the target cannot stealth or turn invisible.
    faerie_fire = {
        id = 770,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        cycle = "faerie_fire",

        spend = 0.08,
        spendType = "mana",

        startsCombat = true,
        texture = 136033,

        handler = function ()
            removeDebuff( "armor_reduction" )
            applyDebuff( "target", "faerie_fire", 300 )
        end,
    },


    -- Decrease the armor of the target by 5% for 5 min.  While affected, the target cannot stealth or turn invisible.  Deals 26 damage and additional threat when used in Bear Form or Dire Bear Form.
    faerie_fire_feral = {
        id = 16857,
        cast = 0,
        cooldown = 6,
        gcd = "totem",

        spend = 0,
        spendType = "energy",

        startsCombat = true,
        texture = 136033,

        handler = function ()
            removeDebuff( "armor_reduction" )
            applyDebuff( "target", "faerie_fire_feral", 300 )
            if glyph.omen_of_clarity.enabled then
                applyBuff("clearcasting")
            end
        end,
    },


    -- 野性冲锋 - 熊 (Feral Charge - Bear)
    -- Causes you to charge an enemy, immobilizing and interrupting any spell being cast for 4 sec.
    feral_charge_bear = {
        id = 16979,
        cast = 0,
        cooldown = 15,
        gcd = "off",

        spend = 5,
        spendType = "rage",

        talent = "feral_charge",
        startsCombat = true,
        texture = 132183,

        range = 25,

        usable = function()
            return buff.bear_form.up or buff.dire_bear_form.up, "requires bear form"
        end,

        handler = function ()
            applyDebuff( "target", "feral_charge_effect" )
            setDistance( 5 )
        end,

        copy = { 16979, "feral_charge" },
    },


    -- 野性冲锋 - 豹 (Feral Charge - Cat)
    -- Causes you to leap behind an enemy, dazing them for 3 sec.
    feral_charge_cat = {
        id = 49376,
        cast = 0,
        cooldown = 30,
        gcd = "off",

        spend = 10,
        spendType = "energy",

        talent = "feral_charge",
        startsCombat = true,
        texture = 132185,

        range = 25,

        usable = function()
            return buff.cat_form.up, "requires cat form"
        end,

        handler = function ()
            applyDebuff( "target", "dazed", 3 )
            setDistance( 5 )
        end,
    },


    -- Finishing move that causes damage per combo point and converts each extra point of energy (up to a maximum of 30 extra energy) into 9.8 additional damage.  Damage is increased by your attack power.     1 point  : 422-562 damage     2 points: 724-864 damage     3 points: 1025-1165 damage     4 points: 1327-1467 damage     5 points: 1628-1768 damage
    ferocious_bite = {
        id = 48577,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function() return (buff.clearcasting.up and 0) or (35 * ((buff.berserk.up and 0.5) or 1)) end,
        spendType = "energy",

        startsCombat = true,
        texture = 132127,

        usable = function() return combo_points.current > 0, "requires combo_points" end,

        handler = function ()
            removeBuff( "clearcasting" )
            if combo_points.current == 5 then
                applyBuff("predators_swiftness")
            end
            set_last_finisher_cp(combo_points.current)
            spend( combo_points.current, "combo_points" )
            spend( min( 30, energy.current ), "energy" )
        end,
    },


    -- Summons 3 treants to attack enemy targets for 30 sec.
    force_of_nature = {
        id = 33831,
        cast = 0,
        cooldown = 180,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.12 end,
        spendType = "mana",

        talent = "force_of_nature",
        startsCombat = true,
        texture = 132129,

        toggle = "cooldowns",

        handler = function ()
            removeBuff( "clearcasting" )
        end,
    },


    -- Converts up to 10 rage per second into health for 10 sec.  Each point of rage is converted into 0.3% of max health.
    frenzied_regeneration = {
        id = 22842,
        cast = 0,
        cooldown = 180,
        gcd = "spell",

        spend = 0,
        spendType = "rage",

        startsCombat = true,
        texture = 132091,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "frenzied_regeneration" )
        end,
    },


    -- Gives the Gift of the Wild to all party and raid members, increasing armor by 240, all attributes by 10 and all resistances by 15 for 1 |4hour:hrs;.
    gift_of_the_wild = {
        id = 21849,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return glyph.wild.enabled and 0.32 or 0.64 end,
        spendType = "mana",

        startsCombat = true,
        texture = 136038,

        handler = function ()
            applyBuff( "gift_of_the_wild" )
            swap_form( "" )
        end,

        copy = { 21850, 26991, 48470 },
    },


    -- Taunts the target to attack you, but has no effect if the target is already attacking you.
    growl = {
        id = 6795,
        cast = 0,
        cooldown = function() return 8 - ((set_bonus.tier9feral_2pc == 1 and 2) or 0) end,
        gcd = "off",

        spend = 0,
        spendType = "rage",

        startsCombat = true,
        texture = 132270,

        handler = function ()
            applyDebuff( "target", "growl" )
        end,
    },


    -- Heals a friendly target for 40 to 55.
    healing_touch = {
        id = 5185,
        cast = function() return glyph.healing_touch.enabled and 1.5 or 3 end,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.17 end,
        spendType = "mana",

        startsCombat = true,
        texture = 136041,

        handler = function ()
            removeBuff( "clearcasting" )
        end,

        copy = { 5186, 5187, 5188, 5189, 6778, 8903, 9758, 9888, 9889, 25297, 26978, 26979, 48377, 48378 },
    },


    -- Forces the enemy target to sleep for up to 20 sec.  Any damage will awaken the target.  Only one target can be forced to hibernate at a time.  Only works on Beasts and Dragonkin.
    hibernate = {
        id = 2637,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",

        spend = 0.07,
        spendType = "mana",

        startsCombat = true,
        texture = 136090,

        handler = function ()
            applyDebuff( "target", "hibernate" )
        end,

        copy = { 18657, 18658 },
    },


    -- Creates a violent storm in the target area causing 101 Nature damage to enemies every 1 sec, and increasing the time between attacks of enemies by 20%.  Lasts 10 sec.  Druid must channel to maintain the spell.
    hurricane = {
        id = 16914,
        cast = function() return 10 * haste end,
        channeled = true,
        breakable = true,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.81 end,
        spendType = "mana",

        startsCombat = true,
        texture = 136018,

        aura = "hurricane",
        tick_time = function () return class.auras.hurricane.tick_time end,

        start = function ()
            applyDebuff( "target", "hurricane" )
        end,

        tick = function ()
        end,

        breakchannel = function ()
            removeDebuff( "target", "hurricane" )
        end,

        handler = function ()
            removeBuff( "clearcasting" )
        end,

        copy = { 17401, 17402, 27012, 48467 },
    },


    -- Causes the target to regenerate mana equal to 225% of the casting Druid's base mana pool over 10 sec.
    innervate = {
        id = 29166,
        cast = 0,
        cooldown = 180,
        gcd = "spell",

        startsCombat = true,
        texture = 136048,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "innervate" )
        end,
    },


    -- The enemy target is swarmed by insects, decreasing their chance to hit by 3% and causing 144 Nature damage over 12 sec.
    insect_swarm = {
        id = 5570,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.08 end,
        spendType = "mana",

        talent = "insect_swarm",
        startsCombat = true,
        texture = 136045,

        handler = function ()
            applyDebuff( "target", "insect_swarm" )
            removeBuff( "clearcasting" )
        end,
    },


    -- Lacerates the enemy target, dealing 88 damage and making them bleed for 320 damage over 15 sec and causing a high amount of threat.  Damage increased by attack power.  This effect stacks up to 5 times on the same target.
    lacerate = {
        id = 48568,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or (15 - talent.shredding_attacks.rank) end,
        spendType = "rage",

        startsCombat = true,
        texture = 132131,

        handler = function ()
            removeBuff( "clearcasting" )
            applyDebuff( "target", "lacerate", 15, min( 5, debuff.lacerate.stack + 1 ) )
        end,
    },


    -- Heals the target for 224 over 7 sec.  When Lifebloom completes its duration or is dispelled, the target instantly heals themself for 480 and the Druid regains half the cost of the spell.  This effect can stack up to 3 times on the same target.
    lifebloom = {
        id = 33763,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.28 end,
        spendType = "mana",

        startsCombat = true,
        texture = 134206,

        handler = function ()
            removeBuff( "clearcasting" )
        end,

        copy = { 48450, 48451 },
    },

    -- Finishing move that causes damage and stuns the target.  Non-player victim spellcasting is also interrupted for 3 sec.  Causes more damage and lasts longer per combo point:     1 point  : 249-250 damage, 1 sec     2 points: 407-408 damage, 2 sec     3 points: 565-566 damage, 3 sec     4 points: 723-724 damage, 4 sec     5 points: 881-882 damage, 5 sec
    maim = {
        id = 49802,
        cast = 0,
        cooldown = 10,
        gcd = "totem",

        spend = function() return (buff.clearcasting.up and 0) or (35 * ((buff.berserk.up and 0.5) or 1)) end,
        spendType = "energy",

        startsCombat = true,
        texture = 132134,

        usable = function() return combo_points.current > 0, "requires combo_points" end,

        handler = function ()
            applyDebuff( "target", "maim", combo_points.current )
            removeBuff( "clearcasting" )
            if combo_points.current == 5 then
                applyBuff("predators_swiftness")
            end
            set_last_finisher_cp(combo_points.current)
            spend( combo_points.current, "combo_points" )
        end,
    },


    -- Mangle (Bear)
    mangle_bear = {
        id = 33878,
        cast = 0,
        cooldown = function() return buff.berserk.up and 1.5 or 6 end,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or (20 - talent.ferocity.rank) end,
        spendType = "rage",

        startsCombat = true,
        texture = 132135,

        handler = function()
            removeDebuff( "mangle" )
            applyDebuff( "target", "mangle_bear", 60 )
            removeBuff( "clearcasting" )
        end,

        copy = { 33878, 33986, 33987, 48563, 48564 }
    },


    -- Mangle (Cat)
    mangle_cat = {
        id = 33876,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function () return (buff.clearcasting.up and 0) or (40 * ((buff.berserk.up and 0.5) or 1)) end,
        spendType = "energy",

        startsCombat = true,
        texture = 132135,

        handler = function()
            removeDebuff( "target", "mangle" )
            applyDebuff( "target", "mangle_cat" )
            removeBuff( "clearcasting" )
            gain( 1, "combo_points" )
        end,

        copy = { 33982, 33983, 48565, 48566 }
    },


    -- A strong attack that increases melee damage and causes a high amount of threat. Effects which increase Bleed damage also increase Maul damage.
    maul = {
        id = 48480,
        cast = 0,
        cooldown = 0,
        gcd = "off",

        spend = function()
            return (buff.clearcasting.up and 0) or ((15 - talent.ferocity.rank) * ((buff.berserk.up and 0.5) or 1))
        end,
        spendType = "rage",

        startsCombat = true,
        texture = 132136,

        nobuff = "maul",

        usable = function() return not buff.maul.up end,
        readyTime = function() return buff.maul.expires end,

        handler = function( rank )
            gain( (buff.clearcasting.up and 0) or ((15 - talent.ferocity.rank) * ((buff.berserk.up and 0.5) or 1)), "rage" )
            start_maul()
        end,

        copy = { 6807, 6808, 6809, 8972, 9745, 9880, 9881, 26996, 48479 }
    },


    -- Increases the friendly target's armor by 25 for 30 min.
    mark_of_the_wild = {
        id = 1126,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return glyph.wild.enabled and 0.12 or 0.24 end,
        spendType = "mana",

        startsCombat = true,
        texture = 136078,

        handler = function ()
            applyBuff( "mark_of_the_wild" )
        end,

        copy = { 5232, 6756, 5234, 8907, 9884, 9885, 26990, 48469 },
    },


    -- Burns the enemy for 9 to 12 Arcane damage and then an additional 12 Arcane damage over 9 sec.
    moonfire = {
        id = 8921,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0 or 0.21) * (1 - talent.moonglow.rank * 0.03) end,
        spendType = "mana",

        startsCombat = true,
        texture = 136096,

        handler = function ()
            removeBuff( "clearcasting" )
            applyDebuff( "target", "moonfire" )
        end,

        copy = { 8924, 8925, 8926, 8927, 8928, 8929, 9833, 9834, 9835, 26987, 26988, 48462, 48463 },
    },


    -- Shapeshift into Moonkin Form.  While in this form the armor contribution from items is increased by 370%, damage taken while stunned is reduced by 15%, and all party and raid members within 100 yards have their spell critical chance increased by 5%.  Single target spell critical strikes in this form instantly regenerate 2% of your total mana.  The Moonkin can not cast healing or resurrection spells while shapeshifted.    The act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.
    moonkin_form = {
        id = 24858,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.13,
        spendType = "mana",

        talent = "moonkin_form",
        startsCombat = true,
        texture = 136036,

        handler = function ()
            swap_form( "moonkin_form" )
        end,
    },


    -- While active, any time an enemy strikes the caster they have a 100% chance to become afflicted by Entangling Roots (Rank 1). 3 charges.  Lasts 45 sec.
    natures_grasp = {
        id = 16689,
        cast = 0,
        cooldown = 60,
        gcd = "spell",

        startsCombat = true,
        texture = 136063,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "natures_grasp" )
        end,

        copy = { 16810, 16811, 16812, 16813, 17329, 27009, 53312 },
    },


    -- When activated, your next Nature spell with a base casting time less than 10 sec. becomes an instant cast spell.
    natures_swiftness = {
        id = 17116,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        talent = "natures_swiftness",
        startsCombat = true,
        texture = 136076,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "natures_swiftness" )
        end,
    },


    -- Heals a friendly target for 1883 to 2187. Heals for an additional 20% if you have a Rejuvenation, Regrowth, Lifebloom, or Wild Growth effect active on the target.
    nourish = {
        id = 50464,
        cast = 1.5,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.18 end,
        spendType = "mana",

        startsCombat = true,
        texture = 236162,

        handler = function ()
            removeBuff( "clearcasting" )
        end,
    },


    -- Pounce, stunning the target for 3 sec and causing 2100 damage over 18 sec.  Must be prowling.  Awards 1 combo point.
    pounce = {
        id = 49803,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function() return (buff.clearcasting.up and 0) or (50 * ((buff.berserk.up and 0.5) or 1)) end,
        spendType = "energy",

        startsCombat = true,
        texture = 132142,

        handler = function ()
            removeBuff( "clearcasting" )
            applyDebuff( "target", "pounce", 3)
            applyDebuff( "target", "pounce_bleed", 18 )
            gain( 1, "combo_points" )
        end,
    },


    -- Allows the Druid to prowl around, but reduces your movement speed by 30%.  Lasts until cancelled.
    prowl = {
        id = 5215,
        cast = 0,
        cooldown = 10,
        gcd = "off",

        spend = 0,
        spendType = "energy",

        startsCombat = true,
        texture = 132089,

        handler = function ()
            applyBuff( "prowl" )
        end,
    },


    -- Rake the target for 178 bleed damage and an additional 1104 damage over 9 sec.  Awards 1 combo point.
    rake = {
        id = 48574,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function () return (buff.clearcasting.up and 0) or ((40 - talent.ferocity.rank) * ((buff.berserk.up and 0.5) or 1)) end,
        spendType = "energy",

        startsCombat = true,
        texture = 132122,

        readyTime = function() return debuff.rake.remains end,

        handler = function ()
            applyDebuff( "target", "rake" )
            removeBuff( "clearcasting" )
            gain( 1, "combo_points" )
        end,
    },


    -- Ravage the target, causing 385% damage plus 1771 to the target.  Must be prowling and behind the target.  Awards 1 combo point.
    ravage = {
        id = 48579,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function() return (buff.clearcasting.up and 0) or (60 * ((buff.berserk.up and 0.5) or 1)) end,
        spendType = "energy",

        startsCombat = true,
        texture = 132141,

        buff = "prowl",

        handler = function ()
            removeBuff( "clearcasting" )
            gain( 1, "combo_points" )
        end,
    },


    -- Returns the spirit to the body, restoring a dead target to life with 400 health and 700 mana.
    rebirth = {
        id = 20484,
        cast = 2,
        cooldown = 600,
        gcd = "spell",

        spend = 0.68,
        spendType = "mana",

        startsCombat = true,
        texture = 136080,

        toggle = "cooldowns",

        handler = function ()
            -- glyph.unburdened_rebirth.enabled removes reagent requirement; doesn't matter because addon shouldn't recommend rebirth.
        end,

        copy = { 20739, 20742, 20747, 20748, 26994, 48477 },
    },


    -- Heals a friendly target for 93 to 107 and another 98 over 21 sec.
    regrowth = {
        id = 8936,
        cast = 2,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.29 end,
        spendType = "mana",

        startsCombat = true,
        texture = 136085,

        handler = function ()
            removeBuff( "clearcasting" )
            removeBuff( "predators_swiftness" )
        end,

        copy = { 8938, 8939, 8940, 8941, 9750, 9856, 9857, 9858, 26980, 48442, 48443 },
    },


    -- Heals the target for 40 over 15 sec.
    rejuvenation = {
        id = 774,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.18 end,
        spendType = "mana",

        startsCombat = true,
        texture = 136081,

        handler = function ()
            removeBuff( "clearcasting" )
        end,

        copy = { 1058, 1430, 2090, 2091, 3627, 8910, 9839, 9840, 9841, 25299, 26981, 26982, 48440, 48441 },
    },


    -- Dispels 1 Curse from a friendly target.
    remove_curse = {
        id = 2782,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.08,
        spendType = "mana",

        startsCombat = false,
        texture = 135952,

        handler = function ()
            -- 驱散诅咒，无需状态变化
        end,
    },


    -- Returns the spirit to the body, restoring a dead target to life with 65 health and 120 mana.  Cannot be cast when in combat.
    revive = {
        id = 50769,
        cast = 10,
        cooldown = 0,
        gcd = "spell",

        spend = 0.72,
        spendType = "mana",

        startsCombat = false,
        texture = 132132,

        handler = function ()
            -- 复活目标，无需状态变化
        end,

        copy = { 50768, 50767, 50766, 50765, 50764, 50763 },
    },


    -- Finishing move that causes damage over time.  Damage increases per combo point and by your attack power:     1 point: 784 damage over 12 sec.     2 points: 1352 damage over 12 sec.     3 points: 1920 damage over 12 sec.     4 points: 2488 damage over 12 sec.     5 points: 3056 damage over 12 sec.
    rip = {
        id = 49800,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function ()
            if buff.clearcasting.up then
                return 0
            end
            return ((30 - ((set_bonus.tier10feral_2pc == 1 and 10) or 0)) * ((buff.berserk.up and 0.5) or 1))
        end,
        spendType = "energy",

        startsCombat = true,
        texture = 132152,

        usable = function() return combo_points.current > 0, "requires combo_points" end,
        readyTime = function() return debuff.rip.remains end, -- Clipping rip is a DPS loss and an unpredictable recommendation. AP snapshot on previous rip will prevent overriding

        handler = function ()
            applyDebuff( "target", "rip" )
            removeBuff( "clearcasting" )
            if combo_points.current == 5 then
                applyBuff("predators_swiftness")
            end
            set_last_finisher_cp(combo_points.current)
            spend( combo_points.current, "combo_points" )
            rip_tracker[target.unit].extension = 0
        end,
    },


    -- Finishing move that increases physical damage done by 30%.  Only useable while in Cat Form.  Lasts longer per combo point:     1 point  : 14 seconds     2 points: 19 seconds     3 points: 24 seconds     4 points: 29 seconds     5 points: 34 seconds
    savage_roar = {
        id = 52610,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function() return 25 * ((buff.berserk.up and 0.5) or 1) end,
        spendType = "energy",

        startsCombat = false,
        texture = 236167,

        usable = function() return combo_points.current > 0, "requires combo_points" end,

        handler = function ()
            applyBuff( "savage_roar" )
            if combo_points.current == 5 then
                applyBuff("predators_swiftness")
            end
            set_last_finisher_cp(combo_points.current)
            spend( combo_points.current, "combo_points" )
        end,
    },


    -- Shred the target, causing 225% damage plus 666 to the target.  Must be behind the target.  Awards 1 combo point.  Effects which increase Bleed damage also increase Shred damage.
    -- 修改 by 哑吡 20251230: 撕碎作为主要攒星技能
    -- 修改 by Kiro 20260116: 恢复简单usable，通过APL的should_use_claw控制
    shred = { --撕碎修改by风雪 20251201
        id = 48572,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function ()
            local cost = 60 - (talent.shredding_attacks.rank * 9) --考虑天赋
            if buff.clearcasting.up then return 0 end --清晰预兆检查
            if buff.berserk.up then cost = cost * 0.5 end --考虑狂暴
            return cost
        end,
        spendType = "energy",

        startsCombat = true,
        texture = 136231,

        usable = function() return true end,

        handler = function ()
            if glyph.shred.enabled and debuff.rip.up and rip_tracker[target.unit].extension < 6 then
                rip_tracker[target.unit].extension = rip_tracker[target.unit].extension + 2
                applyDebuff( "target", "rip", debuff.rip.remains + 2)
            end
            gain( 1, "combo_points" )
            removeBuff( "clearcasting" )
        end,

        copy = { 5221, 6800, 8992, 9829, 9830, 27001, 27002, 48571, 48572 },
    },


    -- Soothes the target beast, reducing the range at which it will attack you by 10 yards.  Only affects Beast and Dragonkin targets level 40 or lower.  Lasts 15 sec.
    soothe_animal = {
        id = 2908,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.06,
        spendType = "mana",

        startsCombat = false,
        texture = 132163,

        handler = function ()
            -- 安抚野兽，无需状态变化
        end,

        copy = { 8955, 9901, 26995 },
    },


    -- You summon a flurry of stars from the sky on all targets within 30 yards of the caster, each dealing 145 to 167 Arcane damage. Also causes 26 Arcane damage to all other enemies within 5 yards of the enemy target. Maximum 20 stars. Lasts 10 sec.  Shapeshifting into an animal form or mounting cancels the effect. Any effect which causes you to lose control of your character will suppress the starfall effect.
    starfall = {
        id = 48505,
        cast = 0,
        cooldown = function() return glyph.starfall.enabled and 60 or 90 end,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0 or 0.35) * (1 - talent.moonglow.rank * 0.03) end,
        spendType = "mana",

        talent = "starfall",
        startsCombat = true,
        texture = 236168,

        toggle = "cooldowns",

        handler = function ()
            removeBuff( "clearcasting" )
        end,
    },


    -- Causes 127 to 155 Arcane damage to the target.
    starfire = {
        id = 2912,
        cast = function() return buff.elunes_wrath.up and 0 or ((3.5 * haste) - (talent.starlight_wrath.rank * 0.1)) end,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0 or 0.16) * (1 - talent.moonglow.rank * 0.03) end,
        spendType = "mana",

        startsCombat = true,
        texture = 135753,

        handler = function ()
            removeBuff( "clearcasting" )
            if glyph.starfire.enabled and debuff.moonfire.up then
                debuff.moonfire.expires = debuff.moonfire.expires + 3
                -- TODO: Cap at 3 applications.
            end
        end,

        copy = { 8949, 8950, 8951, 9875, 9876, 25298, 26986, 48464, 48465 },
    },


    -- When activated, this ability temporarily grants you 30% of your maximum health for 20 sec while in Bear Form, Cat Form, or Dire Bear Form.  After the effect expires, the health is lost.
    survival_instincts = {
        id = 61336,
        cast = 0,
        cooldown = 180,
        gcd = "off",

        spend = 0,
        spendType = "energy",

        talent = "survival_instincts",
        startsCombat = true,
        texture = 236169,

        toggle = "defensives",

        handler = function ()
            applyBuff( "survival_instincts" )
        end,
    },


    -- Shapeshift into swift flight form, increasing movement speed by 280% and allowing you to fly.  Cannot use in combat.  Can only use this form in Outland or Northrend.    The act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.
    swift_flight_form = {
        id = 40120,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.13,
        spendType = "mana",

        startsCombat = true,
        texture = 132128,

        handler = function ()
            swap_form( "swift_flight_form" )
        end,
    },


    -- Consumes a Rejuvenation or Regrowth effect on a friendly target to instantly heal them an amount equal to 12 sec. of Rejuvenation or 18 sec. of Regrowth.
    swiftmend = {
        id = 18562,
        cast = 0,
        cooldown = 15,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.16 end,
        spendType = "mana",

        talent = "swiftmend",
        startsCombat = true,
        texture = 134914,

        handler = function ()
            removeBuff( "clearcasting" )
            if glyph.swiftmend.enabled then return end
            if buff.rejuvenation.up then removeBuff( "rejuvenation" )
            elseif buff.regrowth.up then removeBuff( "regrowth" ) end
        end,
    },


    -- Swipe nearby enemies, inflicting 108 damage.  Damage increased by attack power.
    swipe_bear = { --横扫（熊） 修改by风雪 20251201
        id = 48562,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function ()
            local cost = 20 - talent.ferocity.rank --考虑天赋
            if buff.clearcasting.up then return 0 end --清晰预兆检查
            if set_bonus.tier1feral_2pc == 1 then cost = cost - 5 end --T1套装效果
            return cost
        end,
        spendType = "rage",

        startsCombat = true,
        texture = 134296,

        handler = function ()
            removeBuff( "clearcasting" )
        end,
    },


    -- Swipe nearby enemies, inflicting 250% weapon damage.
    swipe_cat = { --横扫(豹) 修改by风雪 20251201
        id = 62078,
        cast = 0,
        cooldown = 0,
        gcd = "totem",

        spend = function ()
            local cost = 50 - talent.ferocity.rank --考虑天赋
            if buff.clearcasting.up then return 0 end --清晰预兆检查
            if set_bonus.tier1feral_2pc == 1 then cost = cost - 5 end --T1套装效果
            if buff.berserk.up then cost = cost * 0.5 end --考虑狂暴
            return cost
        end,

        spendType = "energy",

        startsCombat = true,
        texture = 134296,

        handler = function ()
            removeBuff( "clearcasting" )
        end,

    },


    -- Thorns sprout from the friendly target causing 3 Nature damage to attackers when hit.  Lasts 10 min.
    thorns = {
        id = 467,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.17 end,
        spendType = "mana",

        startsCombat = true,
        texture = 136104,

        handler = function ()
            removeBuff( "clearcasting" )
            applyBuff( "thorns" )
        end,

        copy = { 782, 1075, 8914, 9756, 9910, 26992, 53307 },
    },


    -- Increases damage done by 80 for 6 sec.
    tigers_fury = {
        id = 50213,
        cast = 0,
        cooldown = function() return 30 - ((set_bonus.tier7feral_4pc == 1 and 3) or 0) end,
        gcd = "off",

        spend = 0,
        spendType = "energy",

        startsCombat = true,
        texture = 132242,

        usable = function() return not buff.berserk.up end,

        handler = function ()
            gain( 60, "energy" )
        end,
    },


    -- Shows the location of all nearby humanoids on the minimap.  Only one type of thing can be tracked at a time.
    track_humanoids = {
        id = 5225,
        cast = 0,
        cooldown = 1.5,
        gcd = "off",

        spend = 0,
        spendType = "energy",

        startsCombat = true,
        texture = 132328,

        handler = function ()
            -- 追踪人形生物，无战斗状态变化
        end,
    },


    -- Heals all nearby group members for 364 every 2 seconds for 8 sec.  Druid must channel to maintain the spell.
    tranquility = {
        id = 740,
        cast = 0,
        cooldown = 480,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.7 end,
        spendType = "mana",

        startsCombat = true,
        texture = 136107,

        toggle = "cooldowns",

        handler = function ()
            removeBuff( "clearcasting" )
        end,

        copy = { 8918, 9862, 9863, 26983, 48446 },
    },


    -- Shapeshift into travel form, increasing movement speed by 40%.  Also protects the caster from Polymorph effects.  Only useable outdoors.    The act of shapeshifting frees the caster of Polymorph and Movement Impairing effects.
    travel_form = {
        id = 783,
        cast = 0,
        cooldown = 0,
        gcd = "spell",

        spend = 0.13,
        spendType = "mana",

        startsCombat = true,
        texture = 132144,

        handler = function ()
            swap_form( "travel_form" )
        end,
    },


    -- You summon a violent Typhoon that does 400 Nature damage when in contact with hostile targets, knocking them back and dazing them for 6 sec.
    typhoon = {
        id = 50516,
        cast = 0,
        cooldown = function() return glyph.monsoon.enabled and 17 or 20 end,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or (0.25 * ( glyph.typhoon.enabled and 0.92 or 1 )) end,
        spendType = "mana",

        talent = "typhoon",
        startsCombat = true,
        texture = 236170,

        handler = function ()
            removeBuff( "clearcasting" )
        end,
    },


    -- Stuns up to 5 enemies within 8 yds for 2 sec.
    war_stomp = {
        id = 20549,
        cast = 0.5,
        cooldown = 120,
        gcd = "off",

        startsCombat = true,
        texture = 132368,

        toggle = "cooldowns",

        handler = function ()
            -- 战争践踏，AOE 眩晕（牛头人种族技能）
            applyDebuff( "target", "war_stomp" )
        end,
    },


    -- Heals up to 5 friendly party or raid members within 15 yards of the target for 686 over 7 sec. The amount healed is applied quickly at first, and slows down as the Wild Growth reaches its full duration.
    wild_growth = {
        id = 48438,
        cast = 0,
        cooldown = 6,
        gcd = "spell",

        spend = function() return (buff.clearcasting.up and 0) or 0.23 end,
        spendType = "mana",

        talent = "wild_growth",
        startsCombat = true,
        texture = 236153,

        handler = function ()
            removeBuff( "clearcasting" )
        end,
    },


    -- Causes 18 to 21 Nature damage to the target.
    wrath = {
        id = 5176,
        cast = function() return ( ( buff.predators_swiftness.up and 0 or 2 ) * haste ) - ( talent.starlight_wrath.rank * 0.1 ) end,
        cooldown = 0,
        gcd = "spell",

        spend = function() return ( buff.clearcasting.up and 0 or 0.08 ) * ( 1 - talent.moonglow.rank * 0.03 ) end,
        spendType = "mana",

        startsCombat = true,
        texture = 136006,

        handler = function ()
            removeBuff( "clearcasting" )
            removeBuff( "predators_swiftness" )
        end,

        copy = { 5177, 5178, 5179, 5180, 6780, 8905, 9912, 26984, 26985, 48459, 48461 },
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

    -- 颅骨猛击 - 野性德鲁伊打断技能 (猫形态/熊形态)
    -- Skull Bash - Feral Druid interrupt (Cat/Bear Form)
    skull_bash = {
        id = 80964,  -- WotLK 版本可能使用不同 ID，这里使用通用 ID
        cast = 0,
        cooldown = 10,
        gcd = "off",

        spend = function()
            if buff.cat_form.up then return 25 end
            if buff.bear_form.up then return 10 end
            return 0
        end,
        spendType = function()
            if buff.cat_form.up then return "energy" end
            if buff.bear_form.up then return "rage" end
            return "mana"
        end,

        startsCombat = true,
        texture = 236946,

        toggle = "interrupts",
        debuff = "casting",
        readyTime = state.timeToInterrupt,

        usable = function()
            return buff.cat_form.up or buff.bear_form.up, "requires cat or bear form"
        end,

        handler = function()
            interrupt()
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
} )


-- Settings
spec:RegisterSetting( "druid_description", nil, {
    type = "description",
    name = "根据你的游戏风格偏好调整以下设置。"..
        "建议始终使用Simc模拟来确定角色的设置最佳值。\n\n"
} )

spec:RegisterSetting( "druid_feral_header", nil, {
    type = "header",
    name = "野性"
} )

spec:RegisterSetting( "druid_feral_description", nil, {
    type = "description",
    name = strformat( "这些设置将改变使用默认 |cFF00B4FF野性|r 优先级时的 %s 行为。\n\n", Hekili:GetSpellLinkWithTexture( spec.abilities.cat_form.id ) )
} )

-- TODO:
spec:RegisterSetting( "min_roar_offset", 24, {
    type = "range",
    name = strformat( "使用 %s 前 %s 的最少时间", Hekili:GetSpellLinkWithTexture( spec.abilities.savage_roar.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.rip.id ) ),
    desc = strformat( "设置推荐 %s 所需的当前 %s 持续时间的最小秒数。\n\n"..
        "建议值:\n - 34 拥有T8四件套\n - 24 没有T8四件套\n\n"..
        "默认值: 24", Hekili:GetSpellLinkWithTexture( spec.abilities.rip.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.savage_roar.id ) ),
    width = "full",
    min = 0,
    softMax = 42,
    step = 1,
} )

spec:RegisterSetting( "rip_leeway", 3, {
    type = "range",
    name = strformat( "%s 容差", Hekili:GetSpellLinkWithTexture( spec.abilities.rip.id ) ),
    desc = "设置推荐野蛮咆哮时的容差时间。\n\n"..
        "在某些情况下，撕裂应该在野蛮咆哮之前被推荐，而基于默认优先级和玩家的反应时间，"..
        "野蛮咆哮会在玩家能够使用连击点之前被使用。这将导致野蛮咆哮后，不得不为撕裂重建5个连击点。"..
        "该设置通过扩大撕裂和野蛮咆哮的间隔来解决这一问题。\n\n"..
        "建议值: 3\n\n"..
        "默认值: 3",
    width = "full",
    min = 1,
    softMax = 10,
    step = 0.1,
} )

spec:RegisterSetting( "max_ff_delay", 0.1, {
    type = "range",
    name = strformat( "最大 %s 延迟", Hekili:GetSpellLinkWithTexture( spec.abilities.faerie_fire_feral.id ) ),
    desc = strformat( "设置 %s 冷却的最长等待时间（秒）。\n\n"..
        "建议值:\n - 0.07 在P2 BiS\n - 0.10 在P3 BiS\n\n"..
        "默认值: 0.1", Hekili:GetSpellLinkWithTexture( spec.abilities.faerie_fire_feral.id ) ),
    width = "full",
    min = 0,
    softMax = 1,
    step = 0.01,
 })

spec:RegisterSetting( "max_ff_energy", 15, {
    type = "range",
    name = strformat( "%s 期间 %s 的最大能量", Hekili:GetSpellLinkWithTexture( spec.abilities.faerie_fire_feral.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.berserk.id ) ),
    desc = strformat( "设置在 %s 期间 %s 的最大能量阈值。\n\n"..
        "建议值: 15\n\n"..
        "默认值: 15", Hekili:GetSpellLinkWithTexture( spec.abilities.faerie_fire_feral.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.berserk.id ) ),
    width = "full",
    min = 0,
    softMax = 100,
    step = 1,
} )

spec:RegisterSetting( "druid_bite_header", nil, {
    type = "header",
    name = strformat( "野性: %s", Hekili:GetSpellLinkWithTexture( spec.abilities.ferocious_bite.id ) )
} )

-- TODO: This could probably just enable/disable the Ferocious Bite ability directly instead of being a unique setting.
spec:RegisterSetting( "ferociousbite_enabled", true, {
    type = "toggle",
    name = strformat( "使用 %s", Hekili:GetSpellLinkWithTexture( spec.abilities.ferocious_bite.id ) ),
    desc = strformat( "如果不勾选，则不推荐 %s。", Hekili:GetSpellLinkWithTexture( spec.abilities.ferocious_bite.id ) ),
    width = "full",
} )

spec:RegisterSetting( "min_bite_sr_remains", 4, {
    type = "range",
    name = strformat( "使用 %s 前 %s 的最少时间", Hekili:GetSpellLinkWithTexture( spec.abilities.ferocious_bite.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.savage_roar.id ) ), --修改by 风雪20250701
    desc = strformat( "如果设置大于0，除非 %s 还有设定值的持续时间，否则不会推荐 %s。\n\n" ..
        "建议值: 4-8, 取决于角色的装备等级\n\n" ..
        "默认值: 4", Hekili:GetSpellLinkWithTexture( spec.abilities.savage_roar.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.ferocious_bite.id ) ), --修改by 风雪20250701
    width = "full",
    min = 0,
    softMax = 14,
    step = 1
} )

spec:RegisterSetting( "min_bite_rip_remains", 4, {
    type = "range",
    name = strformat( "使用 %s 前 %s 的最少时间", Hekili:GetSpellLinkWithTexture( spec.abilities.ferocious_bite.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.rip.id ) ), --修改by 风雪20250701
    desc = strformat( "如果设置大于0，除非 %s 还有设定值的持续时间，否则不会推荐 %s。\n\n" ..
        "建议值: 4-8, 取决于角色的装备等级\n\n" ..
        "默认值: 4", Hekili:GetSpellLinkWithTexture( spec.abilities.rip.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.ferocious_bite.id ) ), --修改by 风雪20250701
    width = "full",
    min = 0,
    softMax = 14,
    step = 1,
} )

spec:RegisterSetting( "max_bite_energy", 25, {
    type = "range",
    name = strformat( "%s 期间 %s 的最大能量", Hekili:GetSpellLinkWithTexture( spec.abilities.berserk.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.ferocious_bite.id ) ), --修改by 风雪20250701
    desc = strformat( "设置在 %s 期间 %s 的最大能量阈值。"..
        "当 %s 未激活时，如果满足上述 %s 和 %s 要求，则允许使用任何数量的能量。\n\n"..
        "建议值: 25\n\n"..
        "默认值: 25", Hekili:GetSpellLinkWithTexture( spec.abilities.berserk.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.ferocious_bite.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.berserk.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.savage_roar.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.rip.id ) ), --修改by 风雪20250701
    width = "full",
    min = 18,
    softMax = 65,
    step = 1
} )
-- 新增by风雪20251129
-- 斜掠优先
spec:RegisterSetting("rake_priority", false, {
    type = "toggle",
    name = "斜掠优先(4T10)",
    desc = "使斜掠优先级提高，潜在伤害更高，但平均伤害可能更低", 
    width = "single",
} )

spec:RegisterSetting( "optimize_trinkets", false, {
    type = "toggle",
    name = "强化饰品",
    desc = "如果勾选，将为即将使用的饰品汇集能量。\n\n"..
        "默认值: 不勾选",
    width = "single",
} )

-- 熊织/花织设置 by 哑吡 20260101
spec:RegisterSetting("druid_weave_header", nil, {
    type = "header",
    name = "野性: 形态织入"
})

spec:RegisterSetting("enable_bearweave", false, {
    type = "toggle",
    name = "启用熊织",
    desc = "启用后，在能量较低时会切换到熊形态进行输出，然后切回猫形态。\n\n"..
        "默认值: 不勾选",
    width = "single",
})

spec:RegisterSetting("enable_bear_tank", false, {
    type = "toggle",
    name = "启用熊坦模式",
    desc = "启用后，在熊形态下会使用坦克循环而不是熊织循环。\n\n"..
        "默认值: 不勾选",
    width = "single",
})

spec:RegisterSetting("enable_flowerweave", false, {
    type = "toggle",
    name = "启用花织",
    desc = "启用后，在能量较低且法力充足时会切出猫形态施放野性赐福。\n\n"..
        "默认值: 不勾选",
    width = "single",
})

spec:RegisterSetting("min_weave_mana", 20, {
    type = "range",
    name = "花织最低法力百分比",
    desc = "花织时需要的最低法力百分比。\n\n"..
        "默认值: 20",
    min = 0,
    max = 100,
    step = 5,
    width = "full",
})

spec:RegisterSetting("druid_balance_header", nil, {
    type = "header",
    name = "平衡: 通用"
})

spec:RegisterSetting("druid_balance_description", nil, {
    type = "description",
    name = "平衡专精的通用参数设置。\n\n"
})

spec:RegisterSetting("lunar_cooldown_leeway", 14, {
    type = "range",
    name = "主要爆发容差",
    desc = "设置月食剩余时间的最小值，以便推荐药剂和主要爆发技能",
    width = "full",
    min = 0,
    softMax = 15,
    step = 0.1,
    set = function( _, val )
        Hekili.DB.profile.specs[ 11 ].settings.lunar_cooldown_leeway = val
    end
})

spec:RegisterSetting("druid_balance_footer", nil, {
    type = "description",
    name = "\n\n"
})

if (Hekili.Version:match( "^Dev" )) then
    spec:RegisterSetting("druid_debug_header", nil, {
        type = "header",
        name = "调试"
    })

    spec:RegisterSetting("druid_debug_description", nil, {
        type = "description",
        name = "调试使用的设置\n\n"
    })

    spec:RegisterSetting("dummy_ttd", 300, {
        type = "range",
        name = "训练假人的死亡时间",
        desc = "在选中训练假人时，设置回调的死亡时间",
        width = "full",
        min = 0,
        softMax = 300,
        step = 1,
        set = function( _, val )
            Hekili.DB.profile.specs[ 11 ].settings.dummy_ttd = val
        end
    })


    spec:RegisterSetting("druid_debug_footer", nil, {
        type = "description",
        name = "\n\n"
    })
end

-- Options
spec:RegisterOptions( {
    enabled = true,

    aoe = 3,

    gcd = 1126,

    nameplates = true,
    nameplateRange = 8,

    damage = false,
    damageExpiration = 6,

    potion = "speed",

    package = "野性(黑科研)",
    usePackSelector = true
} )


-- Default Packs
spec:RegisterPack( "守护(黑科研)", 20260115, [[Hekili:TIvZUnUnq4NLCjiEtwx5eBVPaX5qXIcSPfPlGcAVrjAkkhIijkqrLGuyOZf92c0hGEyb6T(c0NN2f9TOdP(JsIY)a0djqMA43mZ38leAg6bKBawsr3FPZLlDMnBX0lDwSy(vix5RPuKBkM8eEd8qcog()F)N)Y)8RF(S)9V(0x(Jp9LF)3MOK41iooqHugpxqaPqURZzrYpKGwBa)volNb4MLsjO7Nnd5(iliGwkdnJGC)jU87)Uc)VLkWrf(VxKZck8FaN8uH)hfmUGjz0SI7kU7b(Mnr0cFCWZ4ecfKsWLyjJNaprj84yAsG(3zf(m4q5JG0KiCg8BEQ(ftblxWdzrG9IjLhLQV8AS88vFvmw8Khp0dUQ3lSOGlyHRojp90twNhgoDdluA(2P5Pf3zdg5JCrsw1LTlsatq9wtXcVqUiENIMY1o5DnVfoJGJI8k)PxeltEHksTILWKMsLNr9ysACM5H1W1EYJqqxariAaajHgbHc1RUqDDEyO3gsWQzMxqKNmu5ANbZPkFrtxDDrGSovDNNPE0eAmeuVD(bH544zE9r4ZwgvXnGCpJfm86iAj(swm1tY9cy0lEghLtxDwavRmPad3izJxqEC8RkJ)khNjB3kXInu5uJlUhvOkkc8IWefRwRLtQ0s9Xa(B32)SmjugEZIJcFpch4oE6QmQKfQOHAPNA1qkH2qNPqr0BoBXBTAmtkVLhnkJUYzpgwmqGs4Vb((iw0P9vPGQGi7MRh9nniD4HJbw1oySX8aRK2Xqn0ykKfLqETpYdtlg13NpDXrYlTgLQobmQqmvWOEHQsNqv)xL3d17qlssMhNtQ67rIa5j4mjup0PNxfo0ebmTOB7cfukTFZmNbYVg62qfpn48yCE0quuypLKle0e5TvuVsYsA)8rYM0H1Zhpuw((g4sGrl62hLOoW0AItM5hddJwCPgK3p9FyATRFUD74(4a8YEHLwAmdi2Lo9tqu9Yp2GB1DSgGRENoitEfYP8k7LMb4T7G(s7AXWB6HhY9zWca5nxb5fSq1qpd5(H4uUqQ2GybSoHg4cF1qNSPf3HC1pP3rIgcgReE8E9ot0efphG(M6LhqU9NdxEBVY9Mu1(ijydQlxFJMzYM4bcDLPqLZO7jXCLegmLYQAUXiZW7bXIEUbbwVcscXQD3SoH1)0sgQDQDH)Tf(ZBvCV52DiG6GLs1lpsvF4AqH(7gf9tk8nbRREux9664RSvkCo00elvZ86YGYQOQLucoOfygsli1fMQNGM7i3Zk8hB7cnrdByu4pPWF7wy51b7zObSYTnpUob7OmLtAmfJznLA26K)c)BGQfttOBBOMm4Hwbl0UDyhiDFzZ43i99Q8e98wKRtJJv1rV7S5c)3u4FMUC)TJ6GtAQXowMCetuhthzeTMpVEVsyBqUj3nOLVTI8dmoyFeP1qXq1EmrdBDd2ppBlDDpShSI0ELzFm8Wz8LDb0nES0fOLTmxKsBgqMIT1PA95ble0uBpwx)YHZMAv5gAhBMZUgWunH(yMWOgCBQjZr06Hcvb72DZk8pF0IdDYvxbSNaQLPb6E7PDWJ32XoBTEOzr0st2YqV9047mfBy8RRWxVFZRFhevd5Dv2zZ0)6rvZGq2sNwiAxNQndxp8Uol))JKWl3Fsy)Xi9Y)m30tBg9nRD7Uw6XBHagQgnL08vz2DLVELJoL8w(YrMow3p6KTj6JUpt5NAYgVDeRanhTNDpltiWz0GFaEt93Q7JUWu1p8Jt07lb2bY990WFgtEulp6)(]] )
spec:RegisterPack( "平衡(黑科研)", 20251231, [[Hekili:9EvtVXnry4FlCjk5aRYUlBlGaou1l0dHdBpB7zThNDug7XmECwfPkRukG2eqOg(kviqPrQLpApuebbPTHYpgI3n5FbVJN1RThB3nPh6LKDN5DEMN59959J1OTXnn67GeyJ16SANET70TDR2960PxxJ(ITcWg9dq2BGwh(GpYd(75hFqYl(7Lp)57n9x2B69)2vKwSfLHCKifYI42Gvg9herOIp03yqz470dmkaBBSw72g9hsCCWkBWH2g9VopI48UXwxdrr(24yR3m2k5PhD2Hhc355)XTp9KDp9K7L8LF)0DghFJjh97j)0ppz))A6V9SP780KXpwUS8mkJMSZxm5OVdS7(hN8V3j5fpA6x9ea8j7)WZ(HTxEYN(GjB)1ReB9bWs)440LU3btV9JvlD9p6MtF(Foz3haVpoZLqtFvBI5HeMFXxZie3N4VEOr)jJVBYUhK8Kts(ShE6Z(8RC6XpAYUBF2D(NKX7F2H)6)T9NeFdJ(usOiu6RCjHdH)VwAia7JgqXogxZOVnNiWCcs6dDDBHPr(4qZrCKyyROGyRLITwo26nIT2ebwbNQfybIBkXZ0Nnk26w3k2Q6z5ypeXpm269ITq2c4z0kuG4UeoU162oQJ5X2eEmXwqyvzdeUMzKHaE2nYvGpo40l1JX8tbDgzvqMJx2(s86kXlBdxgODmzUM(ireSFHlcm9TkAAkNquQMn9Ua0ZfbRGnlYqWDkquSVOfXdc2BIDmlA1mavoO15SOatpS3aqkakL3p2QxJUUcOiP3vUa0dIqyBHziiR8a(LJvXnKGD1lay6HIgvmlv9ifLlDRp692nsHgUOCysLKsmENfJriJwlgfeMczfexuevuxgv2bSbfJP6lMY0qvYOPQWgXNiE5s8HyefYJcSfkNsVCKhGbCK7dkaZaw6IzY7AicpYVmpYVe5YBInX(ypcomTuu3s8eXWZthUCqN7qdqEkxzbCLlwxouJax4SPLYsJcPOutiikuMz7AcfAKBoh1Hqpgo0qas5q22ykg0fQyLwvqBkjaWivpLjNRzN5QwWVfIfczL5zIqBgJ6Wgb0hJhH2QUyDtSCwe91dP0fnnrk56aD8cFnXlDf3lVpv99pUifO1QawOHxdpU82Dn(6UAPYY6LsBUUSwnO8eNk1XAUCSwTWQyuUoMm)olbAbT76u0MHrCoXg5R13uiNFbBZ8gGQT2yPiGQdaIVHSlSyi2CeH6KfdY2FDIRqB)cTh0o8chAifsXqg3pSeqQLQlFOggd9K2G4BcdquUNzXnQmdrwsTM3kTpqnokgGlKKKF(S4Q8t0iCd5EP2nRmPMaOgxZL8ssvLAxIMsTgh4IVKgKSQuTgZjkWHc3UEzJfF7vhTnNalvEY3MPW8XfQPQZIPqnHskcA3HccOe5OGWyFRQChFCeMVLPG4P(5kl8KYjg7UAvzbK6AcdFAxxbPljHvYIxfcx3jRsyLxViH1R(TycppewAiuT4(8ROI3Qy4vFm0x1lF5kcRS7x54QQlZ3FLQ(NcuuvypswtZOFY3SxYDpmDnJ))p]] )
spec:RegisterPack( "野性(黑科研)", 20260120, [[Hekili:nJ1ZZnTXx8)wYfMKjdASnjXegOh6PsoKEWCRtL8APv2AISKMvRIXZKrJNVKqmPjPbg(rl0bsHWqime4YxAAcq)JHiBNt9FH(wTswY2s2b6K2EjrJ33(EFEF23V2vmR41elOGOyX5ZLj30zZLjRq28zNEQzelqRBHflyHKxavg(Wavf(7jRUzRgVy8to62TFXTBV9DNGjrDDtKctt2MoezMu(l7T2JajA)Y316wneluYrtNEvdXs9BqyBwyzX5ZcFvrtrbZLbBlNKICNZDoV9x37(lp5X)X(E7SrP6Uf)uJTo5zBEYJ274d217J)25B9G35TYTU6NACBM4zDlY2Xk761C7t(5DAFZ1AV(R608XE3z92n3Z71BbF7oxoqQ1p0R5n5UiSO3(nBT2oE78Yo))F4pF)6ljRQofE2zuZV03qr6yd6LYp7ux68zxQY35T5dB)W9)(LQSezYeKlxUPYXfSZQ71E5359JB492LhM4zd07kFO9h3XBJx59Sx5lUBXl7wCg3IhFWHb40hEUZDba(p9XERT91Y698h05zR4T6hADV3c4gOPw3939AUtR7)6tACuNpcKYuHs36o3R9t30BRn7CJ1JlcBFhSrRF6nTF0(T2E12pCz(hTAE)onwX7x2LG0uo(Gx3(UpP19A6o30HkS9r3O9HVaoayu7Qh1ATgDUXhGGeIPQMoeAiwyrmXwZ0iEaqneXqZOSTyHwn3YBTN49M37TYZp(WBEXJpypUk8A(Go)6UFQX)ZDoXc6A2uBwaNmIkHmXWNZ7hkJnqL0XkIFnSerJIjAiXcL1RBvrWSk2qYuvswhbRuxiqu3INZT4yUfl5OQkiRJrezKnfaJGJL)AJhSwja2yYcH)SQQKIdbKtkyb3IlTuKM6tASbMuUUGSdHahW(hIxmVBXj8xugzibPagksQQIfqYug7uqfbOhlPQrG)GjiDrkqzmN0XgdoIQuzzfMBNStNGfVqg3INpYHsYzZon3najNickuTYG7iP6qQZaXfsLP73OFfeRMH7JMM6kM1meIPlbcUksZWgK7kmthzWa2JzSPs1yavhGAkvX3wqI(KUf1HQlgY1J0MnArOcMeXeryAC6u1iWm2yQujtdhBbnftDw8cTcws2KqCSOMq63v8ndJJgu0QounW6GrdLl4a2SAjtjltndQDe5CfFA(CbNgXazeVCzMwICKQiJY6aAquMFmtQ(XPbz)THvyYri5NU4t23jtiTmEjCfniQNIiLXuoPYkRWxLxluWUcbROWYZquk0lYwGGmwWhM5IDeZKIrk5hw4Y)95LipIGwaZCOlMEY21LX22syE6dFFc210S8Jqe8ROWj1Ks3JXDHBHzUzhg)DQkKQG9nhIu1KibNkoCGf3IjwAlBMWQ400qqFXlG9ktmDSKQIRYQye2BKHJAinQKkGG4Lu7j)H639OBNJ)TlQM7SJ4dsNyKMGPd1wtbNBehgPxI)ubLH1mTpGelc9SRd74(BJOzjzywJRMeKpifcelm55ZU)8q7w1nMKQ6R3GdmM9cCIuOUeBmMEBSXsOOtpj892pm9(idcWe07iQjYZnyuFv01Jx6dkgZCpBM6L0X4AiEJHl3Tq7W2uvndFdXYzTzfdyBZMizGRXIAckPhJsteCScNqD6uPM07MeelfRETM1Wlx3f6qWIPSMPJDjyjP4zojetot(ttoLVMGrHJQ4Z(HsyiydCgnREZdgi9P7o6pFlw5QUOwIj5iBvee6WR4km4CACFA0vP5Tfs2mPYir2h2ewPFZp7GDzZM(ThglIMhlzlYNBzbSKfrZKvomgDBxX0rxrITCq5Rbq2e9cUHYnDX7zD7IbcfHmLzZmQw4P32OxhkKDsEeg2SCJA8LuABW(XXJDBJbGzsdRLWTwYNp5UeS9KjJ)z2z3mSzN6F2jHMp70J0GbEsq(C8qPppddbJ14dFPGvro6DhalbZZgjRwfnFC6FU7pyw82tSNuiGeK0SLypqv)ZXXEhjOci36r4WqJsmHldyYEiHGXV(cGap0e57NvdZDsaxrnjJBybwm6GqoeJki7kDhgl8hzcdwVQDCCgo5rOqwM8)3JetFQhZ1hOXVOEyQ1N3T4Ru3ceYcQZjHKLX6yEB5KM5OB9nhdj(3sS34zKunt2fznrXv1W2(PU58xqhViwNNkNH)Ers8hWm8fJsO7(xai6x1dFea)xSiwUqGE45dwem7INXUssYZKb0VBXEgkOSMkn8LkQPPR0ZWEvrKfIV4WVRbpGS7vuQysmSh(9bIEfMq4OWk2wcQwhrsj4XJoG1NvkHSXkFRrIp8mYHbqyPeE6x)Dl(xd]] )
spec:RegisterPack( "猫德(黑科研)", 20260117, [[Hekili:vRXwZnTv6Fl5Lojltn2oX5shcpS7o7mnpqFW8SKvKo2wtKL8iDumEMoA4YKMlnLYDyBPfsbwOKUHoqlqjPWpMnso5P(xy)oNJUADKKtb6mmmKX(OVZ397YcveoTqDfjms4uvlxD6YvQmtPkvNCQAtluh3VlsOExj5LKAbFqxQd83bBUT7RFX4hU7Lh8Wlp4UxBcce91mKuiyclPH0XFAh4cwW3pff9XVibAC7GVvQRElbm8V6wg2MYauc1x0wvd)P6clYJVQmzna2Uiza1veQ3wvrbXafzjlu)FAARQ8jon(xitjnNgFStJdx9IEN9HaPo8PNB)92y)9UL7M3yW6R5SG3Z(z3V7)4DZNp4hF1G1)n312MCm5omG8w)l9E21b4U7lDFZfCF9JhCXNaO2D9NEW9o)GD)fVnUVtJtsPWbF7oUx5lCV6o0d8UY1biyF8g327I3L(XbR9y3v394Wdh8dx0DRTDxzfNfIyNgl2hW9vVS7L2YPHVepjJBEZoU3)RyK17g)xVTU3H3CNd)HBb3(n74DTFJCXWRmn9kEVyx3nUlJIEx7jEBEU)yVVb4t37FJbx7rSZ)J920D9N4D7F64U35IUV88E3(rEB9JWJzCOZcjLCcNUYAdE1d)eNfo4xFbOCaDXGN(6bN7xhCUTh)Z(S)XeuXeyY93llftK2GrKdw9z18U1DONWeqMQ6lpV338lXG7yhS1dIDzEACg2y3CWUx177UJZcH2m2DhV6PNJjgte7wJ79Yv8(3)S7BwXB9RobF8V)RUgWM(CiOyCFWnp4ER4D918((Bd6Jtxb0)7V7ZHJdj2XDx95d28BbA4ELF6Gl87hU6x)X1yGoviOm29yto4HxbE0CPXcOkD35zEF9LC)QvbdwOrao5WTVfbDLJFjgh6tn4rSNp1qifijXVGIuH6AQwysOA9frsMIyj9LcJBr6slQHue(7c1LKXQg6c1LL00ezFrKCt29fzr4HyquvxLevFQQdHgztvmYuvsOElT(DBxYOdsx0OPOSMe8K(L8b1PXh50ymiMWUzZsYAaALLSWQ6Tkz3nIxAkbOcj2u1e(djGNqXjZKIy1oiNgNWPrLYr4aPBsZTzBHa(OPylzfIWdiAkcIcaBrKPfYCP4ygaPwM0IG0sY2MMqYqQhedrL6izRvcsFPdI4XCASmi1KBxIKZtrutsgedmsu2WcNeGosQ6y4)CGje16T0qIeBaJcrCpHQ8eXPZK)dPlQdYSfsxUFiHJqB4jaQMjU2kgRmKgB24GL2(Le45kM9sQ3CA85FEE6m(So4omYMXPJ56y1tTRVqsRG11ejB0zrjmV4NiCcU12Dt4G3sTjMeeGBJe7bYtcN8osMlf)H5hvrrE0LXTnm1TYpSin)Oqmi0y5MgMDsWnYsy6HHbi8J0KaFgmGhlizGmywo58onMnMHNySfLBtateqzySuaaDncIoJChWKA8nbp5i9Ba4epBG2DSgYbkB9uBKKgUDPUYyAgbstfrH6q(mYZH0nI(msGcmp(lh9HfclUOHUTvjSkYCgM4pvxzNgGEPcv3pUVUhR2cs1i202SFjIzH4qlByOPy0tpXdnre3BlMUTsnNgteXETH(2mHCaifivTmsJ4QhQOsMci7uy8DfOml5GEiPLjAOG7gsCtB9ClqqUik)Sp5q6X4sD6JieDzeCeQJkYIgUovi7k2XqbXQnDK5y21KmIs09oKRFNWCHPwZMXcICdyjoARQJgvjyYxzKDg6HP5iJ6cYipucUy5JWXDVYnd87RwpYoDJvBdBOofr84Mkn7SZHX(XlVhNtkObMrmL)qck9zdv8B(SAIz8yzOsYLHoA8ApHLBRCIexz1OsTrQ7cCKV57h7FIm1(TegCmWVk2MKOB)hWKVX4dne2z2QFK2fQbn7mGQG(qzjDrQksSzZ)0UCCOWKLPdhoEochPqsAZsS6o8Soz79omtq7GIjJJqnT0TFpIE1K2WmGA3q7FwjioJ2ySc9BvOUVAqBGq)TX6RtAzWZx00G2yxovibfzuLDvfdTG(0KnmnT7InmdkWtuPPbTJnwvJwzoaUjYH9NpG9PgVymzKA7eeSKkqXpPA2LB9ZormSqWqpkrgfU9TMvdINcmizd(XgYALW9KW05xAgCn(qxiTABIuYVo)yFyjrMslvqteOZiJSSerjQ(Wg7cCQJxgj)Q1HxPGMl89rAQz0dXAKGkQqCKeBuHts1We8BvQdmyjfgrYZZkR(uXYIn8CEuUj3bfhPkvkiQ0lz2XWueCsSz6PIAxbpCZT5wZ8iU8KQXlyZF5jdx1izpaY9bRPiBqslcshMifmLoNkfj9gyTpKImdPxO7XIJIXOlDQUiKgS0bYN0Sr0Id(ggSjemqAmqXUtN(bvANSCzA(EI3R)8YeDSi2qurLIgt)MIJFmNs(fZkr(ibR9iC0YHphgyxEjQDUwCwi5Aw4z985c1M85d(iIUdlHI3RJVKiI0SGpxouW8ZieX9Sec)nA2PA0MDYqaNGNdYiPjZC1tFuAIfL2eAVRqicXCg(bPxNfNUtgr7a)1jY1uWzlAhbRbVopkwpZZDTaT3uLQvimfPH5SSZGPkYp74FHnBN7U)E7QxWAoMLlYWgBPQGQwW8hz36)iXk5nK1qmsS68V)M8AC61mv7kQB0lGjjF1e10ez1wK4sduIrboOYpgaUsqYOJ8iD5oGtpjv6wdeXnJ7TtOx(t0ZDwQShTzmoD1v4Wvzocv2JEKM)ZISz3KjlkJyL6iDM4TEg2Qg5zAiupP(u7XjcB0nVlr6VJqis8hCi7AwqQcupI)MFl153TmTh5mvlzpVIVhySELv7MFV)CCstD7SB0oTzi2jXfNQ55cmFWcxdgmy2uSqonFVi8brjSyI3CfevyiRAyBjsECbnmN5un1YiwHNqsFvf)j9eJURpMztGNSv80su2P05LaRaPmvsP5J7tlDgkzfzqDevl1Elul1YvdKDze)Dye4AhlTCyQW4zutUYJkzNlDi8gMxpLTlU3)KhfAxWBwHxvVOIZKzJdRi7hnnx6rNRKDMv(4kVAU(t)sapjDZvQdzLSZMXHpIFuAnCwCsLQJgRK7ksgPgtYVhjEXyZvUG66vYo9RV8g96lcXuYxNeT)V)AxFrSga5T(IQzNnM3c3sA5OhbLU5UMhYDkAdpz0ti5W4VuIuMdE7ZIZQQNzg(95r3oT)47Cwdz1cFpqj0j8W(S1YlALdjZ917)wAjOBE8dltr4YsRMB30VRnhbKLo04YGAGCAWpFXPfQ3tYKSiilH6ERDj3nUJ7t2ZDLhS)R(Iz3)Lp2BJZEWf(D31U5bB9O)3zpVZcKFrjgnvjJfdKWM8B5qOo7xiiz(znKmgPC6OFVLbRVs4))d]] )



spec:RegisterPackSelector( "balance", "平衡(黑科研)", "|T136096:0|t 平衡",
    "如果你在|T136096:0|t平衡天赋中投入的点数多于其他天赋，将会为你自动选择该优先级。",
    function( tab1, tab2, tab3 )
        return tab1 > max( tab2, tab3 )
    end )

spec:RegisterPackSelector( "feral_dps", "野性(黑科研)", "|T132115:0|t 野性",
    "如果你在|T132276:0|t野性天赋中投入的点数多于其他天赋，并且没有选择厚皮，将会为你自动选择该优先级。",
    function( tab1, tab2, tab3 )
        return tab2 > max(tab1, tab3) and (talent.thick_hide.rank + talent.natural_reaction.rank + talent.protector_of_the_pack.rank) < 6
    end )

spec:RegisterPackSelector( "feral_tank", "守护(黑科研)", "|T132276:0|t 守护",
    "如果你在|T132276:0|t野性天赋中投入的点数多于其他天赋，并且选择了厚皮，将会为你自动选择该优先级。",
    function( tab1, tab2, tab3 )
        return tab2 > max( tab1, tab3 ) and (talent.thick_hide.rank + talent.natural_reaction.rank + talent.protector_of_the_pack.rank) >= 6
    end )


spec:RegisterPack( "平衡PVP(黑科研)", 20251225, [[Hekili:druid_balance_pvp]] )

spec:RegisterPack( "野性PVP(黑科研)", 20251225, [[Hekili:druid_feral_pvp]] )

spec:RegisterPackSelector( "balance_pvp", "平衡PVP(黑科研)", "|T136096:0|t 平衡PVP",
    "PVP专用平衡天赋优先级，适用于战场和竞技场。",
    function( tab1, tab2, tab3 )
        return false
    end )

spec:RegisterPackSelector( "feral_pvp", "野性PVP(黑科研)", "|T132115:0|t 野性PVP",
    "PVP专用野性天赋优先级，适用于战场和竞技场。",
    function( tab1, tab2, tab3 )
        return false
    end )
