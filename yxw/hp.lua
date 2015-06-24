local addon, ns = ...

-- 低血量警告

local cfg = ns.cfg


local SelfHpWarnningFrame = nil
local WarnningPersent = 30
local WarnningStringFrame = nil
local SelfHWX, SelfHWY = 0, 0


local healthUpdate = function(self, ...)
    local max, hp = 0, 0
    local unit = PlayerFrame.unit
    max = UnitHealthMax(unit)
    hp = UnitHealth(unit)
    local p = (hp/max) * 100
    if p > WarnningPersent then
        if SelfHpWarnningFrame:IsShown() then
            SelfHpWarnningFrame:Hide()
        end
    else
        local text = string.format("%d", p)
        WarnningStringFrame:SetText(text)
        if SelfHpWarnningFrame:IsShown() == false then
            SelfHpWarnningFrame:Show()
        end
    end
end


local function SetPos(frame, x, y)
    frame:SetPoint("CENTER", UIParent, "CENTER", x, y)
end


local function GetXYVar()
    local x = tonumber(GetCVar("selfhpwarnningx"))
    local y = tonumber(GetCVar("selfhpwarnningy")) 
    if x == nil then
        x = SelfHWX
    end
    if y == nil then
        y = SelfHWY
    end
    return x, y
end


local function SetXYVar(x, y)
    if x then
        SetCVar("selfhpwarnningx", x)
    end
    if y then
        SetCVar("selfhpwarnningy", y)
    end
end


SelfHpWarnningFrame = CreateFrame("Frame")
RegisterCVar("selfhpwarnningx")
RegisterCVar("selfhpwarnningy")
local x, y = GetXYVar()
SetPos(SelfHpWarnningFrame, x, y)
--SelfHpWarnningFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
SelfHpWarnningFrame:SetHeight(50)
SelfHpWarnningFrame:SetWidth(55)
WarnningStringFrame = SelfHpWarnningFrame:CreateFontString(nil, "OVERLAY")
WarnningStringFrame:SetAllPoints(SelfHpWarnningFrame)
WarnningStringFrame:SetFont("Fonts\\ARHei.ttf", 40)
WarnningStringFrame:SetJustifyH("LEFT")
WarnningStringFrame:SetTextColor(1, 0, 0, 1)


SelfHpWarnningFrame:Hide()


SelfHpWarnningFrame:SetScript("Onevent", healthUpdate)
SelfHpWarnningFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
SelfHpWarnningFrame:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "player")


SLASH_SHP1 = "/shp"
SlashCmdList["SHP"] = function(msg, editBox)
    local cmd = msg:lower()
    local i = string.find(cmd, " ")
    local x = tonumber(cmd:sub(1, i))
    local y = tonumber(cmd:sub(i+1))
    SetPos(SelfHpWarnningFrame, x, y)
    SetXYVar(x, y)
end




local vFrames, yFrames = {}, {}


local function CreateVPFrame(num, w, h, v, dir)
    local i,x,y = 0,0,0
    local frames = {} 
    local sx, sy = 0,0
    for i = 1, num do
        frames.k = i
        frames.f = CreateFrame("Frame")
        frames.f:SetClampedToScreen(false)
        frames.f:SetWidth(w)
        frames.f:SetHeight(h)
        if dir == "x" then
            x = x + v
            sx = x
            sy = y - 10
        else
            y = y - v
            sx = x + 20
            sy = y
        end
        frames.f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, y)
--        frames.f:SetPoint("LEFT", UIParent, "LEFT", x, y)
        frames.t = frames.f:CreateTexture(nil, "OVERLAY")
        frames.t:SetAllPoints(frames.f)
        frames.t:SetTexture(1,0,0,1)
        local f = CreateFrame("Frame")
        f:SetWidth(20)
        f:SetHeight(10)
        f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", sx, sy)
        local s = frames.f:CreateFontString(nil, "OVERLAY")
        s:SetFont("Fonts\\ARHei.ttf", 10)
        s:SetText(i*v)
        s:SetAllPoints(f)
        s:SetJustifyH("TOP")
        frames.s = f
        vFrames[i] = frames
    end
    return vFrames
end


local function  hide_f(Frames, num)
    -- 隐藏框体不知什么原因不生效
    local i,v = 0
    for i = 1, num do
       v = Frames[i]  
        if v then
            v.f:Hide()
            v.s:Hide()
        end
    end
end


local show = 0
SLASH_VP1 = "/vp"
SlashCmdList["VP"] = function(msg)
    local v = tonumber(msg:lower())
    local x, y = UIParent:GetHeight(), UIParent:GetWidth()
    local xNum, yNum = math.floor(x/v), math.floor(y/v)
    if show == 0 then
        vFrames = CreateVPFrame(yNum, 2, x, v, "x")
        yFrames = CreateVPFrame(xNum, y, 2, v, "y")
        show = 1
    else
        show = 0
        hide_f(vFrames, xNum)
        hide_f(yFrames, yNum)
    end
end



