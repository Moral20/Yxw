-- 竞技场框体旁边显示徽章时间
local trinkets = {}
local events = CreateFrame("Frame")


function events:ADDON_LOADED(addonName)
    if addonName ~= "Blizzard_ArenaUI" then
        return
    end


    local arenaFrame, trinket
    for i = 1, MAX_ARENA_ENEMIES do
        arenaFrame = "ArenaEnemyFrame"..i
        trinket = CreateFrame("Cooldown", arenaFrame.."Trinket", ArenaEnemyFrames)
        trinket:SetPoint("Right", arenaFrame, 29, -5)
        trinket:SetSize(30, 30)
        trinket.icon = trinket:CreateTexture(nil, "BACKGROUND")
        trinket.icon:SetAllPoints()
        trinket.icon:SetTexture("Interface\\Icons\\inv_jewelry_trinketpvp_01")
        trinket:Hide()
        trinkets["arena"..i] = trinket
    end
    self:UnregisterEvent("ADDON_LOADED")
end


function events:UNIT_SPELLCAST_SUCCEEDED(unitID, spell, rank, lineID, spellID)
    if not trinkets[unitID] then
        return
    end
    if spellID == 59752 or spellID == 42292 then
        CooldownFrame_SetTimer(trinkets[unitID], GetTime(), 120, 1)
        SendChatMessage("Trinket used by: "..GetUnitName(unitID, true), "PARTY")
    elseif spellID == 7744 then
        CooldownFrame_SetTimer(trinkets[unitID], GetTime(), 45, 1)
        SendChatMessage("WotF used by: "..GetUnitName(unitID, true), "PARTY")
    end
end


function events:PLAYER_ENTERING_WORLD()
    local _, instanceType = IsInInstance()
    if instanceType == "arena" then
        self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    elseif self:IsEventRegistered("UNIT_SPELLCAST_SUCCEEDED") then
        self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        for _, trinket in pairs(trinkets) do
            trinket:SetCooldown(0, 0)
            trinket:Hide()
        end
    end
end
-- 测试命令
SLASH_BAF1 = "/baf"
SlashCmdList["BAF"] = function(msg, editBox)
    if not IsAddOnLoaded("Blizzard_ArenaUI") then
        LoadAddOn("Blizzard_ArenaUI")
    end
    ArenaEnemyFrames:Show()
    local arenaFrame
    for i = 1, MAX_ARENA_ENEMIES do
        arenaFrame = _G["ArenaEnemyFrame"..i]
        arenaFrame.classPortrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
        arenaFrame.classPortrait:SetTexCoord(unpack(CLASS_ICON_TCOORDS["WARRIOR"]))
        arenaFrame.name:SetText("Dispelme")
        arenaFrame:Show()
        CooldownFrame_SetTimer(trinkets["arena"..i], GetTime(), 120, 1)
    end
end

SLASH_RL1 = "/rl"
SlashCmdList["RL"] = function(msg, editBox)
    ReloadUI()
end


events:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
-- END
