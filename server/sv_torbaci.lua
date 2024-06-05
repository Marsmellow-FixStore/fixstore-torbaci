QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterNetEvent("marsmellow-other:server:SellItem", function(data, key)
    local Player = QBCore.Functions.GetPlayer(source)
    local RequiredItems = data.RequiredItems
    local GiveItem = data.GiveItem
    --if key == QBCore.Key then
        for k, v in pairs(RequiredItems) do
            RequiredItems = {
                name = v.Item,
                amount = v.Count
            }
        end

        for k, v in pairs(GiveItem) do
            GiveItem = {
                name = v.Item,
                amount = v.Count
            }
        end

        if Player then
            local checkAmount = Player.Functions.GetItemByName(RequiredItems.name)
            
            if checkAmount then
                local roundAmount = QBCore.Shared.Round(GiveItem.amount * checkAmount.amount, 0)
                if Player.Functions.AddItem(GiveItem.name, roundAmount) then
                    TriggerEvent('marsmellow-logs:server:CreateLog', 'torbaci', "" , "orange", "``" .. GetPlayerName(source) .. "(".. source ..")``, adlı kişi ``".. RequiredItems.amount .. " adet uyuşturucu " .. roundAmount .. " kara para kazandı!")
                    Player.Functions.RemoveItem(RequiredItems.name, checkAmount.amount)
                    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[RequiredItems.name], "remove", RequiredItems.amount)
                    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[GiveItem.name], "add", roundAmount)
                end
            else
                TriggerClientEvent("QBCore:Notify", source, "Üzerinde yeterli ".. QBCore.Shared.Items[RequiredItems.name].label .. " yok!", "error")
            end
        end
    --end
end)
