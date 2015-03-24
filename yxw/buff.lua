-- 修改图腾/恢复德鲁伊的蘑菇位置

local addon, ns = ...
local cfg = ns.cfg

local buffs = ...

local CellConfig = {
    a1 = "CENTER", 
    af = UIParent, 
    a2 = "CENTER", 
    x = 100, 
    y = 0, 
    alpha = 0.7,
    cell_num = 10, 
    offset = 20, 
    width = 40, 
    height = 40,
}

local Cells = {
    key = nil,
    frame = nil,
    texture = nil,
    cd_frame = nil,
    frame_name = nil,
    spell_id = nil,
    spell_name = nil,
    expires = nil,
    used = nil,
}

local cd_frame = {}

local CDFrame = {}

--Create All Cells
local function create_all_buff_cells(CC)
    for i=1, CC.cell_num, 1 do
        local frame, texture, cd, cell = nil, nil, nil, nil
        local name = "COOLCELL" .. i 
        frame = CreateFrame("Button", name, UIParent)
        texture = frame:CreateTexture("COOLCELL_TEXTURE" .. i)
        texture:SetAllPoints("COOLCELL" .. i)
        texture:SetAlpha(CC.alpha)
        frame:SetWidth(CC.width)
        frame:SetHeight(CC.height)
        frame:ClearAllPoints()
        frame:SetPoint(CC.a1, CC.af, CC.a2, CC.x+i*CC.offset, CC.y)
        frame:Hide()
        cd = CreateFrame("Cooldown", "cd" .. i, frame, "CooldownFrameTemplate")
        cd:SetCooldown(0, 0)
        cell = {
            key = i,
            frame = frame,
            texture = texture,
            cd_frame = cd,
            frame_name = name,
            spell_id = 0,
            spell_name = 0,
            expires = 0,
            used = 0,
        }
        debug("create cell " .. i)
        table.insert(CDFrame, i, cell)
        --CDFrame[i] = cell
        --table.insert(CDFrame, cell)
    end
end

local function get_cell(spellid)
    debug("1")
    local cell = nil
    for k, v in pairs(CDFrame) do
        if v.spell_id == spellid then
            cell = v
            return cell
        end
    end
    if cell == nil then
        for k, v in pairs(CDFrame) do
            if v.used == 0 then
                cell = v
                return cell
            end
        end
    end
    return cell
end

local function set_cell(cell)
    debug("2")
    for k, v in pairs(CDFrame) do
        if v.key == cell.key then
            debug("set " .. v.key)
            --table.insert(CDFrame, v.key, cell)
            --CDFrame[key] = cell
        end
    end
end

local function init_cell(cell, spellid)
    debug("3")
    local cell = get_cell(spellid)
    if cell == nil then
        debug("init")
        return
    end
    debug("key" .. cell.key)
    cell.spell_id = spellid
    cell.used = 1
    set_cell(cell)
end

local function show(spellid, spellname, expires, icon)
    debug("4")
    local now = GetTime()
    local cell = get_cell(spellid)
    if cell == nil then
        return
    end
    cell.spell_id = spellid
    cell.spell_name = spellname
    cell.expires = expires
    cell.texture:SetTexture(icon)
    cell.frame:Show()
    cell.cd_frame:SetCooldown(now, cell.expires - now)
    set_cell(cell)
end

local function unshow(spellid)
    debug("5")
    local cell = get_cell(spellid)
    if cell == nil then
        return
    end
    cell.frame:Hide()
    cell.used = 0
    set_cell(cell)
end

local get_spell_id = function(self, event, ...)
    local unitID, spell, rank, lineID, spellID = ...
    if spellID == nil or spell == nil or rank == nil or lineID == nil then
        return
    end
    if unitID == PlayerFrame.unit then 
        for k,v in pairs(cfg.watch_spell) do
            if v == spellID then
                init_cell(v)
--                if cd_frame.frame == nil then
--                    local frame = CreateFrame("Button", "cool_down_fram", UIParent)
--                    local texture = frame:CreateTexture(spell .. "cd")
--                    texture:SetAllPoints("cool_down_fram")
--                    texture:SetAlpha(0.5)
--                    frame:SetWidth(40)
--                    frame:SetHeight(40)
--                    frame:ClearAllPoints()
--                    frame:SetPoint("CENTER", UIParent, "CENTER", 100, 0)
--                    frame:Show()
--                    cd_frame.spell_id = v
--                    cd_frame.frame = frame
--                    cd_frame.spell_name = spell
--                    cd_frame.texture = texture
--                    cd_frame.cd = nil
--                    cd_frame.expires = nil
--                end
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
        --unshow(spellID)
--        cd_frame.frame:Hide()
--        cd_frame.spell_id = nil
--        cd_frame.frame = nil
--        cd_frame.spell_name = nil
--        cd_frame.cd = nil
--        cd_frame.expires = nil
    else
        --show(spellID, name, expires, icon)
--        local now, cd = GetTime(), nil
--        cd_frame.texture:SetTexture(icon)
--
--        if cd_frame.expires == expires then
--            return
--        end
--        cd_frame.expires = expires
--        if cd_frame.cd == nil then
--            local cd = CreateFrame("Cooldown", "centercooldown", cd_frame.frame, "CooldownFrameTemplate")
--            cd:SetCooldown(now, expires - now)
--            cd_frame.cd = cd
--        else
--            cd_frame.cd:SetCooldown(now, expires - now)
--        end

    end
end

create_all_buff_cells(CellConfig)

buffs = CreateFrame("Frame")
--buffs:RegisterEvent("UNIT_AURA")
buffs:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
--buffs:SetScript("OnUpdate", setposition)
buffs:SetScript("OnEvent", get_spell_id)

local loss_or_gaint = CreateFrame("Frame")
loss_or_gaint:RegisterEvent("UNIT_AURA")
loss_or_gaint:SetScript("OnEvent", up_buff_duration)
loss_or_gaint:SetScript("OnUpdate", up_buff_duration)
