
-- 脱离战斗,没有目标就隐藏自己

local addon, ns = ...
local cfg = ns.cfg

local hid = ...

local cfgPlayerPos = cfg.units.player.pos
local cfgTargetPos = cfg.units.target.pos
local scale = cfg.units.scale
local hidAlpha = cfg.units.hid_alpha

local autohid = function(self, event, ...)
    local unit = PlayerFrame.unit
    local unitplayer = PlayerFrame
    local ismaxhp, ismaxpower, havetarget = ...
    local isPlayerCombat = ...

    isPlayerCombat = isCombat(unit)
    ismaxhp = isMaxHp(unit)
    ismaxpower = isMaxPower(unit)
    havetarget = isTarget(TargetFrame.unit)

    if event == "PLAYER_ENTERING_WORLD" then
        setpostion(unitplayer)
        if (isPlayerCombat == false) and ismaxhp and ismaxpower then
            hide(unitplayer)
            return
        else
            settargetpostion(TargetFrame)
            show(unitplayer)
            return
        end
    end

    if havetarget then
        settargetpostion(TargetFrame)
        show(unitplayer)
        return
    end 

    if isPlayerCombat then
        show(unitplayer)
        return
    end 

    if ismaxhp and ismaxpower then
        hide(unitplayer)
    else
        show(unitplayer)
    end
end


function isCombat(unit)
    return UnitAffectingCombat(unit)
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
    frame:SetAlpha(hidAlpha)
end

function show(frame)
    frame:SetAlpha(1)
end

hid = CreateFrame("Frame", "auto", PlayerFrame)
hid:SetScript("OnEvent", autohid)
hid:SetScript("OnUpdate", autohid)
hid:RegisterEvent("PLAYER_ENTERING_WORLD")
hid:RegisterEvent("PLAYER_TARGET_CHANGED")
hid:RegisterUnitEvent("UNIT_HEALTH", "player")
hid:RegisterUnitEvent("UNIT_POWER", "player")


function setpostion(frame)
    frame:ClearAllPoints()
    frame:SetScale(scale)
    frame:SetPoint(cfgPlayerPos.a1, cfgPlayerPos.af, cfgPlayerPos.a2, cfgPlayerPos.x, cfgPlayerPos.y)
end

function settargetpostion(frame)
    frame:ClearAllPoints()
    frame:SetScale(scale)
    frame:SetPoint(cfgTargetPos.a1, cfgTargetPos.af, cfgTargetPos.a2, cfgTargetPos.x, cfgTargetPos.y)
end
