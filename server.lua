local ESX = nil

Citizen.CreateThread(function()
    while not ESX do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(1000)
    end

    for _, item in pairs(Config) do
        local countItem = #item.itemReward
        local items = item.itemReward
        local countWeapons = #item.weaponReward
        local weapons = item.weaponReward
        local countMoney = #item.moneyReward
        local moneyReward = item.moneyReward
        local countBlackMoneyReward = #item.blackMoneyReward
        local blackMoneyReward = item.blackMoneyReward
        local name = item.name
        local amountOfReward = item.amountOfReward
        ESX.RegisterUsableItem(name, function(source)
            local firstCatId = 1
            local itemRewardCat, weaponRewardCat, moneyRewardCat, blackMoneyRewardCat

            if 0 < countItem then
                itemRewardCat = firstCatId
            end

            if 0 < countWeapons then
                firstCatId = firstCatId + 1
                weaponRewardCat = firstCatId
            end

            if 0 < countMoney then
                firstCatId = firstCatId + 1
                moneyRewardCat = firstCatId
            end

            if 0 < countBlackMoneyReward then
                firstCatId = firstCatId + 1
                blackMoneyRewardCat = firstCatId
            end

            source = tonumber(source)
            local xPlayer = ESX.GetPlayerFromId(source)

            for i = 1, amountOfReward do
                local cat = math.random(1, firstCatId)

                local message = ""
                if itemRewardCat == cat then
                    local itemIndex = math.random(1, countItem)
                    local newItem = items[itemIndex]
                    xPlayer.addInventoryItem(newItem.name, newItem.amount)
                    message = "Du hast bekommen : ~g~" .. newItem.amount .. "x " .. newItem.label
                elseif weaponRewardCat == cat then
                    local weaponIndex = math.random(1, countWeapons)
                    local newWeapon = weapons[weaponIndex]
                    xPlayer.addWeapon(newWeapon.name, newWeapon.ammo)
                    message = "Du hast bekommen : ~g~" .. newWeapon.label .. "~w~ mit ~g~" .. newWeapon.ammo .. "~w~ Schuss"
                elseif moneyRewardCat == cat then
                    local moneyIndex = math.random(1, countMoney)
                    local newMoney = moneyReward[moneyIndex]
                    xPlayer.addMoney(newMoney)
                    message = "Du hast ~g~" .. newMoney .. "$ ~w~ bekommen."

                elseif blackMoneyRewardCat == cat then
                    local blackMoneyIndex = math.random(1, countBlackMoneyReward)
                    local blackMoney = blackMoneyReward[blackMoneyIndex]
                    xPlayer.addAccountMoney('black_money', blackMoney)
                    message = "Du hast ~g~" .. blackMoney .. "$ ~w~ Schwarzgeld bekommen."
                end

                TriggerClientEvent("esx:showNotification", source, message)
            end

            xPlayer.removeInventoryItem(name, 1)
        end)
    end
end)
