-- 定义玩家的某些技能BUFF,特别显示

local addon, ns = ...
local cfg = ns.cfg

local buffs = ...

local CellConfig = cfg.CellConfig

local Cells = cfg.Cells

CDFrame = {}

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
        table.insert(CDFrame, i, cell)
    end
end


local function get_cell(spellid)
    local cell = nil
    for k, v in pairs(CDFrame) do
        if v.spell_id == spellid then
            return v
        end
    end
    if cell == nil then
        for k, v in pairs(CDFrame) do
            if v.used == 0 then
                return v
            end
        end
    end
    return cell
end

local function set_cell(cell)
    for k, v in pairs(CDFrame) do
        if v.key == cell.key then
            CDFrame[v.key] = cell
        end
    end
end


local function buff_show(spellid, spellname, expires, icon)
    local cell = get_cell(spellid)
    local now = GetTime()
    if cell == nil then
        return
    end

    cell.spell_id = spellid
    cell.used = 1
    cell.spell_name = spellname
    cell.expires = expires
    cell.texture:SetTexture(icon)
    cell.cd_frame:SetCooldown(now, expires - now)
    cell.frame:Show()
    set_cell(cell)
end

local function buff_hide(spellid)
    local cell = get_cell(spellid)
    if cell == nil then
        return
    end
    cell.frame:Hide()
    cell.used = 0
    cell.spell_id = 0
    cell.spell_name = "no name"
    cell.expires = 0
    set_cell(cell)
end

local spell_cast_success = function(self, event, ...)
    local unitID, spell, rank, lineID, spellID = ...
    if spellID == nil or spell == nil or rank == nil or lineID == nil then
        return
    end
    for k,v in pairs(cfg.watch_spell) do
        if v == spellID then
            name, _, icon, _, _, duration, expires, _, _, _, _, _, _, _, _, _ = UnitBuff(unitID, spell)
            if duration ~= nil then
                buff_show(spellID, name, expires, icon)
            end
        end
    end
end

local update_buff_duration = function(self, ...)
    local cell = nil
    local now = GetTime()
    for k, v in pairs(CDFrame) do
        if v.used == 1 then
            cell = v
             _, _, _, _, _, duration, expires, _, _, _, spellID, _, _, _, _, _ = UnitBuff(PlayerFrame.unit, cell.spell_name)
             if duration == nil then
                buff_hide(v.spell_id)
            end
        end
    end
end


create_all_buff_cells(CellConfig)

buffs = CreateFrame("Frame")
buffs:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
buffs:SetScript("OnEvent", spell_cast_success)

local loss_or_gaint = CreateFrame("Frame")
loss_or_gaint:RegisterEvent("UNIT_AURA")
loss_or_gaint:SetScript("OnEvent", update_buff_duration)


