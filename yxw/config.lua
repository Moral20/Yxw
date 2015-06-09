
local addon, ns = ...

local cfg = {}
ns.cfg = cfg

cfg.units = {
    scale = 0.9,
    hid_alpha = 0.1,
    -- PLAYER
    player = {
        pos = { a1 = "TOP", a2 = "TOP", af = "UIParent", x = -425, y = -285 },
    },
    -- TARGET
    target = {
        pos = { a1 = "TOP", a2 = "TOP", af = "UIParent", x = -325, y = -355 },
    },
}


cfg.watch_spell = {
    179244,
    17,
--    33763, --生命绽放
    2565,
    156321,
    16870,
}
cfg.CellConfig = {
    a1 = "CENTER", 
    af = UIParent, 
    a2 = "CENTER", 
    x = 100, 
    y = 0, 
    alpha = 0.9,
    cell_num = 10, 
    offset = 50, 
    width = 40, 
    height = 40,
}

cfg.Cells = {
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
