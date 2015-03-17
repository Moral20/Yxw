
-- 脱离战斗,没有目标就隐藏自己

local hid = ...

local autohid = function(self, event, ...)
    local unit = PlayerFrame.unit
    local unitplayer = PlayerFrame
    local iscombat, ismaxhp, ismaxpower, havetarget = ...

    iscombat = isCombat(event)
    ismaxhp = isMaxHp(unit)
    ismaxpower = isMaxPower(unit)
    havetarget = isTarget(TargetFrame.unit)

    if event == "PLAYER_ENTERING_WORLD" then
        if (iscombat == false) and ismaxhp and ismaxpower then
            hide(unitplayer)
            return
        else
            show(unitplayer)
            return
        end
    end

    if havetarget or iscombat then
        show(unitplayer)
        return
    end 

    if ismaxhp and ismaxpower then
        hide(unitplayer)
    else
        show(unitplayer)
    end
end

hid = CreateFrame("Frame", "auto", PlayerFrame)
hid:SetScript("OnEvent", autohid)
hid:RegisterEvent("PLAYER_ENTERING_WORLD")
hid:RegisterEvent("PLAYER_REGEN_DISABLED")
hid:RegisterEvent("PLAYER_REGEN_ENABLED")
hid:RegisterEvent("PLAYER_TARGET_CHANGED")
hid:RegisterUnitEvent("UNIT_HEALTH", "player")
hid:RegisterUnitEvent("UNIT_POWER", "player")

function isCombat(event)
    if event == "PLAYER_REGEN_DISABLED" then
        return true
    else
        return false
    end
end

function isMaxHp(unit)
    local hp = UnitHealth(unit)
    local max = UnitHealthMax(unit)
    if hp == max then
        return true
    else
        return false
    end
end

function isMaxPower(unit)
    local powerType, powerToken, altR, altG, altB = UnitPowerType(unit)
    if powerType == 0 then
        local mana = UnitPower(unit)
        local max = UnitPowerMax(unit)
        if mana == max then
            return true
        else
            return false
        end
    else
        return true
    end
end

function isTarget(unit)
    local exsit = UnitLevel(unit)
    if exsit == 0 then
        return false
    else
        return true
    end
end

function hide(frame)
    frame:SetAlpha(0.1)
end

function show(frame)
    frame:SetAlpha(1)
end
