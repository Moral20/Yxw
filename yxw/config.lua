
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
        pos = { a1 = "TOP", a2 = "TOP", af = "UIParent", x = -325, y = -345 },
    },
}


cfg.watch_spell = {
    179244,
    17,
    33763,
    2565,
    156321,
}
