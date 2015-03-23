
local addon, ns = ...
-- shift 右键, 添加为焦点目标

local modifier = "shift" --- 可修改为 shift, alt 或者 ctrl 
local mouseButton = "2" --- 1 =鼠标左键, 2 = 鼠标右键, 3 = 鼠标滚轮按下, 4 and 5 = 高级鼠标……你们懂的 

local function SetFocusHotkey(frame) 
    frame:SetAttribute(modifier.."-type"..mouseButton,"focus") 
end 

local function CreateFrame_Hook(type, name, parent, template) 
    if template == "SecureUnitButtonTemplate" then 
        SetFocusHotkey(_G[name]) 
    end 
end 

hooksecurefunc("CreateFrame", CreateFrame_Hook) 

-- Keybinding override so that models can be shift/alt/ctrl+clicked 
local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate") 
f:SetAttribute("type1","macro") 
f:SetAttribute("macrotext","/focus mouseover") 
SetOverrideBindingClick(FocuserButton,true,modifier.."-BUTTON"..mouseButton,"FocuserButton") 

-- Set the keybindings on the default unit frames since we won't get any CreateFrame notification about them 
local duf = { 
    PlayerFrame, 
    PetFrame, 
    PartyMemberFrame1, 
    PartyMemberFrame2, 
    PartyMemberFrame3, 
    PartyMemberFrame4, 
    PartyMemberFrame1PetFrame, 
    PartyMemberFrame2PetFrame, 
    PartyMemberFrame3PetFrame, 
    PartyMemberFrame4PetFrame, 
    TargetFrame, 
    TargetofTargetFrame, 
} 

for i,frame in pairs(duf) do 
    SetFocusHotkey(frame) 
end
-- END
