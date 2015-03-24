
local addon, ns = ...

function debug(string)
    DEFAULT_CHAT_FRAME:AddMessage(string,255,255,255)
end

function debug1(string, ...)
    local s = ...
    if s == nil then
        debug(string .. " is nil")
    else
        debug(string .. s)
    end
end
