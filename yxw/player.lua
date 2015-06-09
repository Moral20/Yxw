
local aadon, ns = ...
local cfg = ns.cfg

local sui_player = CreateFrame("Frame", ns.cfg.player.frame_name.name, PlayerFrame)

local _, class = UnitClass("player")
local class_colo = RAID_CLASS_COLORS[class]
local red = {r=255, g=0, b=0}
local green = {r=0, g=255, b=0}


function sui_create_text(cfg_table)
    cfg_table.health_bar.frame:SetHeight(2)
    cfg_table.health_bar.frame:SetWidth(200)
    --font = PlayerName:GetFontObject()
    --font = WorldMapFrameAreaLabel:GetFontObject()
    font = ZoneTextString:GetFontObject()
    if cfg_table.health_per.frame == 0 then
        local frame = CreateFrame("Frame")
        local f = frame:CreateFontString("health_per", "OVERLAY")
        local pos = cfg_table.health_per
        frame:SetPoint(pos.a1, pos.af, pos.a2, pos.x, pos.y)
        frame:SetWidth(100)
        frame:SetHeight(20)
        f:SetAllPoints(frame)
        f:SetFontObject(font)
        f:SetJustifyH(cfg_table.health_per.h)
--        f:SetTextHeight(pos.w)
        ns.cfg.player.health_per.frame = frame
        ns.cfg.player.health_per.text = f 
    end
--    if cfg_table.power_per.frame == 0 then
--        local frame = CreateFrame("Frame")
--        local f = frame:CreateFontString("power_per", "OVERLAY")
--        local pos = cfg_table.power_per
--        frame:SetPoint(pos.a1, pos.af, pos.a2, pos.x, pos.y)
--        frame:SetWidth(100)
--        frame:SetHeight(20)
--        f:SetAllPoints(frame)
--        f:SetFontObject(TextStatusBarText)
--        f:SetJustifyH(cfg_table.power_per.h)
--        --f:SetTextHeight(pos.w)
--        ns.cfg.player.power_per.frame = frame
--        ns.cfg.player.power_per.text = f
--    end
end

function sui_player_hide(cfg_table)
    local list = {
        PlayerPortrait, 
        PlayerFrameTexture, 
        PlayerStatusTexture, 
        PlayerName,
        PlayerFrameBackground,
        PlayerRestGlow,
        PlayerStatusGlow,
        PlayerAttackBackground,
        PlayerAttackBackgroundGlow,
        PlayerStatusTextureGlow, 
        --PlayerAttackGlow,
    }

    PlayerFrame:EnableMouse(false)
    PlayerFrameManaBar:UnregisterAllEvents()
    
    for i=1, #list do
        list[i]:SetAlpha(0)
        list[i]:Hide()
    end

    sui_create_text(cfg_table)

    sui_set_frame_pos(cfg_table.main_frame)
    sui_set_frame_pos(cfg_table.health_bar)
    sui_set_frame_pos(cfg_table.health_text)
    sui_set_frame_pos(cfg_table.power_bar)
    sui_set_frame_pos(cfg_table.power_text)

    sui_set_frame_pos(cfg_table.pvpicon)
    sui_set_frame_pos(cfg_table.resticon)
    sui_set_frame_pos(cfg_table.level_text)

    sui_set_frame_pos(cfg_table.role_icon)
    sui_set_frame_pos(cfg_table.guide_icon)
    sui_set_frame_pos(cfg_table.leadericon)
    
end

function sui_set_frame_pos(frame)
    local pos = frame
    f = frame.frame
    f:ClearAllPoints()
    if frame.show then
        f:SetPoint(pos.a1, pos.af, pos.a2, pos.x, pos.y)
        if frame.h ~= nil then
            f:SetJustifyH(frame.h)
        end
        if frame.width ~= nil then
            f:SetWidth(frame.width)
            f:SetHeight(frame.height)
        end
    else
        f:SetAlpha(0)
        f:Hide()
    end
end

function sui_update_text(...)
    local hp, maxhp, power, maxpower, hpp, mpp = 0
    local unit = PlayerFrame.unit

    hp = UnitHealth(unit)
    maxhp = UnitHealthMax(unit)
    power = UnitPower(unit)
    maxpower = UnitPowerMax(unit)

    hpp = hp/maxhp*100
    mpp = power/maxpower*100

    ns.cfg.player.health_text.frame:SetText(hp)
    ns.cfg.player.health_text.frame:SetTextColor(green.r, green.g, green.b, 1)
    ns.cfg.player.health_per.text:SetFormattedText("%d%%", hpp)
    if hpp < 30 then
        ns.cfg.player.health_per.text:SetTextColor(red.r, red.g, red.b, 1)
    else
        ns.cfg.player.health_per.text:SetTextColor(green.r, green.g, green.b, 1)
    end

    ns.cfg.player.power_text.frame:SetFormattedText(power .. " | " .. "%d%%" , mpp)
    ns.cfg.player.power_text.frame:SetTextColor(class_colo.r, class_colo.g, class_colo.b, 1)

--    ns.cfg.player.power_per.text:SetTextColor(class_colo.r, class_colo.g, class_colo.b, 1)
--    ns.cfg.player.power_per.text:SetFormattedText("%d%%", mpp)

    PlayerStatusTexture:Hide()
--    LowHealthFrame:Hide()
    PlayerFrameFlash:Hide() -- 被打时红色的
    PlayerHitIndicator:Hide() -- 伤害数字
end

function sui_player_update(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        -- 玩家进入游戏,这里要隐藏一些东西
        -- 调整好玩家头像位置
        sui_player_hide(cfg.player)
        return
    end

    sui_update_text(ns.cfg.player)

end


sui_player:RegisterEvent("PLAYER_ENTERING_WORLD")
--sui_player:RegisterEvent("")
sui_player:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", "player")
sui_player:SetScript("OnEvent", sui_player_update)
sui_player:SetScript("OnUpdate", sui_player_update)


