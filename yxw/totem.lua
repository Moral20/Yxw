-- 修改图腾/恢复德鲁伊的蘑菇位置

local addon, ns = ...

local totem = ...

local setposition = function(self, event, ...)
    local totems = TotemFrame
    local duration = TotemFrame:IsShown()

    if duration then
        totems:ClearAllPoints()
        totems:SetPoint("CENTER", "UIParent", "CENTER", -100, -100)
    end
end

totem = CreateFrame("Frame")
totem:RegisterEvent("PLAYER_TOTEM_UPDATE")
totem:SetScript("OnUpdate", setposition)
totem:SetScript("OnEvent", setposition)

