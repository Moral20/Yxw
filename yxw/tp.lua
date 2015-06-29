
-- 头像旁边显示血量百分比,可以按下alt键移动
local addon, ns = ...

--local startDrag = function(frame) if IsAltKeyDown() then frame:StartMoving() end end
--local stopDrag = function(frame) frame:StopMovingOrSizing() end
--TargetFramePortrait

local rcFrame, rcFrameText, hpFrame, hpFrameText = nil, nil, nil, nil
local hp_pos = {a1 = "LEFT", a2 = "LEFT", af = "TargetFrame", x = -80, y = -5, width = 80, height = 20, justifyh = "RIGHT",}
local rc_pos = {a1 = "LEFT", a2 = "LEFT", af = "TargetFrame", x = -80, y = 15, width = 80, height = 20, justifyh = "RIGHT",}
local font = ZoneTextString:GetFont()
local red = {r=255, g=0, b=0}
local green = {r=0, g=255, b=0}
local yellow = {r=255, g=255, b=255}

local function getRace(unit)
    local race = UnitRace(unit)
    if race == nil then 
        race = ""
    end
    return race
end

local function getClass(unit)
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

local function getGender(unit)
    local gender = UnitSex(unit)
    if gender == nil then
        gender = ""
    else
        if gender == 1 then
            gender = ""
        elseif gender == 2 then
            gender = "M "
        else
            gender = "F "
        end
    end
end

local function getString(unit)
    local race = getRace(unit)
    local class = getClass(unit)

    local string = class

    return string
end

local function getThreat(unit) 
    local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", unit)
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


local healthUpdate = function(frame, event, ...)
    local unit = TargetFrame.unit
    local hp = UnitHealth(unit)

--    local threatvalue = getThreat(unit)
--    local string = getString(unit, hp)

    if hp > 0 then		
        local persent = hp / UnitHealthMax(unit) * 100
        hpFrameText:SetFormattedText("%d%%", persent)
        if persent < 20 then
            hpFrameText:SetTextColor(red.r, red.g, red.b, 1)
        elseif persent > 80 then
            hpFrameText:SetTextColor(green.r, green.g, green.b, 1)
        else
            hpFrameText:SetTextColor(yellow.r, yellow.g, yellow.b, 1)
        end
    else
        hpFrameText:SetTextColor(yellow.r, yellow.g, yellow.b, 1)
        hpFrameText:SetText("Dead")
    end

end

TargetFrameTextureFrameHealthBarText:SetAlpha(0.7)
TargetFrameTextureFrameManaBarText:SetAlpha(0.7)

if PetFrame ~= nil then
    PetFrame:ClearAllPoints()
    PetFrame:SetPoint("LEFT", PlayerFrame, "RIGHT", 0, 0)
end

hpFrame = CreateFrame("Frame", "TargetPercent", TargetFrame)
hpFrame:SetPoint(hp_pos.a1, hp_pos.af, hp_pos.a2, hp_pos.x, hp_pos.y)
hpFrame:SetWidth(hp_pos.width)
hpFrame:SetHeight(hp_pos.height)
--hpFrame:EnableMouse(false)
hpFrame:SetClampedToScreen(true)
hpFrame:SetScript("OnEvent", healthUpdate)
hpFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
hpFrame:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "target")
hpFrameText = hpFrame:CreateFontString("TargetPercentText", "OVERLAY")
hpFrameText:SetAllPoints("TargetPercent")
--hpFrameText:SetFontObject(TextStatusBarText)
hpFrameText:SetFont(font, 25, "OUTLINE")
hpFrameText:SetJustifyH(hp_pos.justifyh)


local function infoupdate(self, ...)
    local string = getString(TargetFrame.unit)
    rcFrameText:SetText(string)
end

rcFrame = CreateFrame("Frame", "TargetInfo", TargetFrame)
rcFrame:SetPoint(rc_pos.a1, rc_pos.af, rc_pos.a2, rc_pos.x, rc_pos.y)
rcFrame:SetWidth(rc_pos.width)
rcFrame:SetHeight(rc_pos.height)
rcFrame:SetClampedToScreen(true)
rcFrame:SetScript("OnEvent", infoupdate)
rcFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
rcFrameText = hpFrame:CreateFontString("TargetPercentText", "OVERLAY")
rcFrameText:SetAllPoints("TargetInfo")
rcFrameText:SetFont(font, 15, "OUTLINE")
rcFrameText:SetJustifyH(rc_pos.justifyh)
