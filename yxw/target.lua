
-- 头像旁边显示血量百分比,可以按下alt键移动
local addon, ns = ...

local yxwAddon = {}


local startDrag = function(frame) if IsAltKeyDown() then frame:StartMoving() end end
local stopDrag = function(frame) frame:StopMovingOrSizing() end

local pos = "TOP"
local x = 12
local y = -3
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax

function getRace(unit)
    local race = UnitRace(unit)
    if race == nil then 
        race = ""
    end
    return race
end

function getClass(unit)
    local classLoc, class, classId = UnitClass(unit)

    if UnitIsPlayer(unit) and classLoc then
        return classLoc
    else
        local c1 = UnitCreatureType(unit)
        if c1 == nil then
            return "未知生物"
        else
            return c1
        end
    end
end

function getGender(unit)
    local gender = UnitSex(unit)
    if gender == nil then
        gender = ""
    else
        if gender == 1 then
            gender = ""
        elseif gender == 2 then
            gender = "男"
        else
            gender = "女"
        end
    end
end

function getString(unit, hp)
    local string = ""
    local race = getRace(unit)
    local class = getClass(unit)

    local string = ""--race .. " "  .. class

    if hp > 0 then
        string = class .. " " .. race .. " %d%%"
    else
        string = class .. " " .. race .. "0"
    end
    return string
end

function getThreat(unit) 
    local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", unit)
--    if htreatpct == nil then
--        debug("1231231")
--        return ""
--    else
--        debgu(htreatpct)
--        return htreatpct .. " "
--    end
    local txt = { "白 ",  "黄 ", "橙 ", "红 " }
    if status == nil then
        return ""
    else
        if status == 0 then
            return txt[status+1]
        elseif status == 1 then 
            return txt[status+1]
        elseif status == 2 then
            return txt[status+1]
        else
            return txt[status+1]
        end
    end
end


local healthUpdate = function(frame, event, unit)
    unit = unit or frame.unit
    local hp = UnitHealth(unit)

    local threatvalue = getThreat(unit)
    local string = getString(unit, hp)

    if hp > 0 then		
        local persent = hp / UnitHealthMax(unit) * 100
        yxwAddon[unit]:SetFormattedText(threatvalue .. string, persent)
    else
        yxwAddon[unit]:SetText(string)
    end
end


yxwAddon.target = CreateFrame("Frame", "TargetPercent", TargetFrameHealthBar)
yxwAddon.target:SetPoint("TOP", TargetFrame, "TOP", x, y)
yxwAddon.target:SetWidth(250)
yxwAddon.target:SetHeight(20)
yxwAddon.target:EnableMouse(true)
yxwAddon.target:RegisterForDrag("LeftButton")
yxwAddon.target:SetClampedToScreen(true)
yxwAddon.target:SetMovable(true)
yxwAddon.target:SetScript("OnDragStart", startDrag)
yxwAddon.target:SetScript("OnDragStop", stopDrag)
yxwAddon.target:SetScript("OnEvent", healthUpdate)
yxwAddon.target.unit = "target"
yxwAddon.target:RegisterEvent("PLAYER_TARGET_CHANGED")
yxwAddon.target:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "target")
yxwAddon.target = yxwAddon.target:CreateFontString("TargetPercentText", "OVERLAY")
yxwAddon.target:SetAllPoints("TargetPercent")
yxwAddon.target:SetFontObject(TextStatusBarText)
yxwAddon.target:SetJustifyH("LEFT")




yxwAddon.focus = CreateFrame("Frame", "FocusPercent", FocusFrameHealthBar)
yxwAddon.focus:SetPoint(pos, FocusFrame, pos, x, y)
yxwAddon.focus:SetWidth(250)
yxwAddon.focus:SetHeight(20)
yxwAddon.focus:EnableMouse(true)
yxwAddon.focus:RegisterForDrag("LeftButton")
yxwAddon.focus:SetClampedToScreen(true)
yxwAddon.focus:SetMovable(true)
yxwAddon.focus:SetScript("OnDragStart", startDrag)
yxwAddon.focus:SetScript("OnDragStop", stopDrag)
yxwAddon.focus:SetScript("OnEvent", healthUpdate)
yxwAddon.focus.unit = "focus"
yxwAddon.focus:RegisterEvent("PLAYER_FOCUS_CHANGED")
yxwAddon.focus:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "focus")
yxwAddon.focus = yxwAddon.focus:CreateFontString("FocusPercentText", "OVERLAY")
yxwAddon.focus:SetAllPoints("FocusPercent")
yxwAddon.focus:SetFontObject(TextStatusBarText)
yxwAddon.focus:SetJustifyH("LEFT")




for i = 1, 5 do
    local boss, Boss = ("boss%d"):format(i), ("Boss%d"):format(i)
    yxwAddon[boss] = CreateFrame("Frame", Boss.."Percent", _G[Boss.."TargetFrameHealthBar"])
    yxwAddon[boss]:SetPoint(pos, _G[Boss.."TargetFrameHealthBar"], pos, x, y)
    yxwAddon[boss]:SetWidth(250)
    yxwAddon[boss]:SetHeight(20)
    yxwAddon[boss]:EnableMouse(true)
    yxwAddon[boss]:RegisterForDrag("LeftButton")
    yxwAddon[boss]:SetClampedToScreen(true)
    yxwAddon[boss]:SetMovable(true)
    yxwAddon[boss]:SetScript("OnDragStart", startDrag)
    yxwAddon[boss]:SetScript("OnDragStop", stopDrag)
    yxwAddon[boss]:SetScript("OnEvent", healthUpdate)
    yxwAddon[boss]:SetScript("OnShow", healthUpdate)
    yxwAddon[boss].unit = boss
    yxwAddon[boss]:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
    yxwAddon[boss]:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", boss)
    yxwAddon[boss] = yxwAddon[boss]:CreateFontString(Boss.."PercentText", "OVERLAY")
    yxwAddon[boss]:SetAllPoints(Boss.."Percent")
    yxwAddon[boss]:SetFontObject(TextStatusBarText)
    yxwAddon[boss]:SetJustifyH("RIGHT")
end
--END
