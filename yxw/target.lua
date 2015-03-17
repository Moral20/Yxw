
-- 头像旁边显示血量百分比,可以按下alt键移动
local name, addon = ...


local startDrag = function(frame) if IsAltKeyDown() then frame:StartMoving() end end
local stopDrag = function(frame) frame:StopMovingOrSizing() end


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

    string = class .. " " .. race .. " %d%%"
    return string
end


local healthUpdate = function(frame, event, unit)
    unit = unit or frame.unit
    local hp = UnitHealth(unit)

    local string = getString(unit)

    if hp > 0 then		
        local persent = hp / UnitHealthMax(unit) * 100
        addon[unit]:SetFormattedText(string, persent)
    else
        addon[unit]:SetText(string .." 0%")
    end
end


addon.target = CreateFrame("Frame", name, TargetFrameHealthBar)
addon.target:SetPoint("LEFT", TargetFrameHealthBar, "LEFT", -51, 0)
addon.target:SetWidth(250)
addon.target:SetHeight(20)
addon.target:EnableMouse(true)
addon.target:RegisterForDrag("LeftButton")
addon.target:SetClampedToScreen(true)
addon.target:SetMovable(true)
addon.target:SetScript("OnDragStart", startDrag)
addon.target:SetScript("OnDragStop", stopDrag)
addon.target:SetScript("OnEvent", healthUpdate)
addon.target.unit = "target"
addon.target:RegisterEvent("PLAYER_TARGET_CHANGED")
addon.target:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "target")
addon.target = addon.target:CreateFontString("TargetPercentText", "OVERLAY")
addon.target:SetAllPoints(name)
addon.target:SetFontObject(TextStatusBarText)
addon.target:SetJustifyH("LEFT")




addon.focus = CreateFrame("Frame", "FocusPercent", FocusFrameHealthBar)
addon.focus:SetPoint("LEFT", FocusFrameHealthBar, "LEFT", -51, 0)
addon.focus:SetWidth(50)
addon.focus:SetHeight(20)
addon.focus:EnableMouse(true)
addon.focus:RegisterForDrag("LeftButton")
addon.focus:SetClampedToScreen(true)
addon.focus:SetMovable(true)
addon.focus:SetScript("OnDragStart", startDrag)
addon.focus:SetScript("OnDragStop", stopDrag)
addon.focus:SetScript("OnEvent", healthUpdate)
addon.focus.unit = "focus"
addon.focus:RegisterEvent("PLAYER_FOCUS_CHANGED")
addon.focus:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "focus")
addon.focus = addon.focus:CreateFontString("FocusPercentText", "OVERLAY")
addon.focus:SetAllPoints("FocusPercent")
addon.focus:SetFontObject(TextStatusBarText)
addon.focus:SetJustifyH("RIGHT")




for i = 1, 5 do
    local boss, Boss = ("boss%d"):format(i), ("Boss%d"):format(i)
    addon[boss] = CreateFrame("Frame", Boss.."Percent", _G[Boss.."TargetFrameHealthBar"])
    addon[boss]:SetPoint("LEFT", _G[Boss.."TargetFrameHealthBar"], "LEFT", -51, 0)
    addon[boss]:SetWidth(50)
    addon[boss]:SetHeight(20)
    addon[boss]:EnableMouse(true)
    addon[boss]:RegisterForDrag("LeftButton")
    addon[boss]:SetClampedToScreen(true)
    addon[boss]:SetMovable(true)
    addon[boss]:SetScript("OnDragStart", startDrag)
    addon[boss]:SetScript("OnDragStop", stopDrag)
    addon[boss]:SetScript("OnEvent", healthUpdate)
    addon[boss]:SetScript("OnShow", healthUpdate)
    addon[boss].unit = boss
    addon[boss]:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
    addon[boss]:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", boss)
    addon[boss] = addon[boss]:CreateFontString(Boss.."PercentText", "OVERLAY")
    addon[boss]:SetAllPoints(Boss.."Percent")
    addon[boss]:SetFontObject(TextStatusBarText)
    addon[boss]:SetJustifyH("RIGHT")
end
--END
