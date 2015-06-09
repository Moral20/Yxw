@@ -0,0 +1,93 @@
-- 修改图腾/恢复德鲁伊的蘑菇位置

local addon, ns = ...
local cfg = ns.cfg

local buffs = ...

function debug1(string, ...)
    local s = ...
    if s == nil then
        debug(string .. " is nil")
    else
        debug(string .. s)
    end
end

local cd_frame = {}

local get_spell_id = function(self, event, ...)
    local unitID, spell, rank, lineID, spellID = ...
    if spellID == nil or spell == nil or rank == nil or lineID == nil then
        return
    end
    if unitID == PlayerFrame.unit then 
        for k,v in pairs(cfg.watch_spell) do
            if v == spellID then
                if cd_frame.frame == nil then
                    local frame = CreateFrame("Button", "cool_down_fram", UIParent)
                    local texture = frame:CreateTexture(spell .. "cd")
                    texture:SetAllPoints("cool_down_fram")
                    texture:SetAlpha(0.5)
                    frame:SetWidth(40)
                    frame:SetHeight(40)
                    frame:ClearAllPoints()
                    frame:SetPoint("CENTER", UIParent, "CENTER", 100, 0)
                    frame:Show()
                    cd_frame.spell_id = v
                    cd_frame.frame = frame
                    cd_frame.spell_name = spell
                    cd_frame.texture = texture
                    cd_frame.cd = nil
                    cd_frame.expires = nil
                end
            end
        end
    end
end

local up_buff_duration = function(self, event, ...)
    local unit = ...
    if unit ~= PlayerFrame.unit then
        return
    end
    if cd_frame.spell_name == nil then
        return
    end
    name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, value1, value2, value3 = UnitBuff(unit, cd_frame.spell_name)
    if duration == nil then
        cd_frame.frame:Hide()
        cd_frame.spell_id = nil
        cd_frame.frame = nil
        cd_frame.spell_name = nil
        cd_frame.cd = nil
        cd_frame.expires = nil
    else
        local now, cd = GetTime(), nil
        cd_frame.texture:SetTexture(icon)

        if cd_frame.expires == expires then
            return
        end
        cd_frame.expires = expires
        if cd_frame.cd == nil then
            local cd = CreateFrame("Cooldown", "centercooldown", cd_frame.frame, "CooldownFrameTemplate")
            cd:SetCooldown(now, expires - now)
            cd_frame.cd = cd
        else
            cd_frame.cd:SetCooldown(now, expires - now)
        end

    end
end

buffs = CreateFrame("Frame")
--buffs:RegisterEvent("UNIT_AURA")
buffs:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
--buffs:SetScript("OnUpdate", setposition)
buffs:SetScript("OnEvent", get_spell_id)

local loss_or_gaint = CreateFrame("Frame")
loss_or_gaint:RegisterEvent("UNIT_AURA")
loss_or_gaint:SetScript("OnEvent", up_buff_duration)
loss_or_gaint:SetScript("OnUpdate", up_buff_duration)

