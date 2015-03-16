
-- 自动售卖灰色垃圾
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function()
    local c = 0
    for b=0,4 do
        for s=1,GetContainerNumSlots(b) do
            local l = GetContainerItemLink(b, s)
            if l then
                local p = select(11, GetItemInfo(l))*select(2, GetContainerItemInfo(b, s))
                if select(3, GetItemInfo(l))==0 and p>0 then
                    UseContainerItem(b, s)
                    PickupMerchantItem()
                    c = c+p
                end
            end
        end
    end
    if c>0 then
        local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100
        DEFAULT_CHAT_FRAME:AddMessage("出售了灰色垃圾,得到了".." |cffffffff"..g.."|cffffc125g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r"..".",255,255,255)  --"Your vendor trash has been sold and you earned"可以更改成中文,改好用UTF-8格式保存即可
    end
end)
f:RegisterEvent("MERCHANT_SHOW")
-- END