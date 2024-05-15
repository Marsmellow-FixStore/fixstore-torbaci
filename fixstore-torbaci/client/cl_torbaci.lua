QBCore = nil
local PlayerData = {}
Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)
QBCore = exports['qb-core']:GetCoreObject()
local ScriptData = Config.Torbaci
local playerLogin = false
local PlayerData = {}
local Menu = {
    [1] = {
        RequiredItems = {
            {Item = 'package-weed-bad-ql', Count = 1},
        },
        GiveItem = {
            {Item = 'karapara', label = '1 Seviye Ot - 200$', Count = 200}
        }
    },
    [2] = {
        RequiredItems = {
            {Item = 'package-weed-med-ql', Count = 1},
        },
        GiveItem = {
            {Item = 'karapara', label = '2 Seviye Ot - 280$', Count = 280}
        }
    },
    [3] = {
        RequiredItems = {
            {Item = 'package-weed-max-ql', Count = 1},
        },
        GiveItem = {
            {Item = 'karapara', label = '3 Seviye Ot - 300$', Count = 300}
        }
    },
    [4] = {
        RequiredItems = {
            {Item = 'package-opium-bad-ql', Count = 1},
        },
        GiveItem = {
            {Item = 'karapara', label = '1 Seviye Kubar - 165$', Count = 165}
        }
    },
    [5] = {
        RequiredItems = {
            {Item = 'package-opium-med-ql', Count = 1},
        },
        GiveItem = {
            {Item = 'karapara', label = '2 Seviye Kubar - 250$', Count = 250}
        }
    },
    [6] = {
        RequiredItems = {
            {Item = 'package-opium-max-ql', Count = 1},
        },
        GiveItem = {
            {Item = 'karapara', label = '3 Seviye Kubar - 280$', Count = 280}
        }
    },
    [7] = {
        RequiredItems = {
            {Item = 'package-coke-bad-ql', Count = 1},
        },
        GiveItem = {
            {Item = 'karapara', label = '1 Seviye Şeker - 165$', Count = 165}
        }
    },
    [8] = {
        RequiredItems = {
            {Item = 'package-coke-med-ql', Count = 1},
        },
        GiveItem = {
            {Item = 'karapara', label = '2 Seviye Şeker - 250$', Count = 250}
        }
    },
    [9] = {
        RequiredItems = {
            {Item = 'package-coke-max-ql', Count = 1},
        },
        GiveItem = {
            {Item = 'karapara', label = '3 Seviye Şeker - 280$', Count = 280}
        }
    },
    [10] = {
        RequiredItems = {
            {Item = 'package-meth-bad-ql', Count = 1},
        },
        GiveItem = {
            {Item = 'karapara', label = '1 Seviye Meth - 550$', Count = 550}
        }
    },
    [11] = {
        RequiredItems = {
            {Item = 'package-meth-med-ql', Count = 1},
        },
        GiveItem = {
            {Item = 'karapara', label = '2 Seviye Meth - 650$', Count = 650}
        }
    },
    [12] = {
        RequiredItems = {
            {Item = 'package-meth-max-ql', Count = 1},
        },
        GiveItem = {
            {Item = 'karapara', label = '3 Seviye Meth - 750$', Count = 750}
        }
    },
}

RegisterNetEvent("QBCore:OnPlayerLoaded")
AddEventHandler("QBCore:OnPlayerLoaded", function(xPlayer)
    playerLogin = true
    PlayerData = xPlayer
end)

local function OpenSellMenu(id)
    local menu = {
        {
            header = "Malları Sat",
            isMenuHeader = true
        }
    }
    
    for i,z in pairs(Menu) do
        for o,s in pairs(z.GiveItem) do
            menu[#menu+1] = {
                header = s.label,
                txt = "",
                params = {
                    event = "fixstore-marsmellow:client:SellItem",
                    args = {
                        id = id,
                        itemId = i
                    }
                }
            }
        end
    end

    exports["qb-menu"]:openMenu(menu)
end

CreateThread(function()
    for k, v in pairs(ScriptData) do
        RequestModel(v.Ped.model)
        while not HasModelLoaded(v.Ped.model) do
            Wait(1)
        end
    
        local sellerPed = CreatePed(4, v.Ped.model, v.Ped.coords.x, v.Ped.coords.y, v.Ped.coords.z - 1.0, v.Ped.coords.w, false, true)
        FreezeEntityPosition(sellerPed, true)
        SetEntityInvincible(sellerPed, true)
        SetBlockingOfNonTemporaryEvents(sellerPed, true)

        for i, z in pairs(v.Jobs) do
            exports['qb-target']:AddTargetEntity(sellerPed, {
                options = {
                    {
                        icon = "fas fa-dollar-sign",
                        label = "Sat",
                        action = function()
                            OpenSellMenu(k)
                        end,
                        canInteract = function()
                            if z == QBCore.Functions.GetPlayerData().job.name then
                                return true
                            end

                            return false
                        end,
                    },
                },
                distance = 1.3
            })
        end
    end

    while true do
        sleep = 1000
        local plyPed = PlayerPedId()
        local plyCoords = GetEntityCoords(plyPed)
        for k, v in pairs(ScriptData) do
            if v.UseMarker == true then
                local enterDist = #(plyCoords - vector3(v.Teleport.enter.x, v.Teleport.enter.y, v.Teleport.enter.z))
                local exitDist = #(plyCoords - vector3(v.Teleport.exit.x, v.Teleport.exit.y, v.Teleport.exit.z))
        
                for i, z in pairs(v.Jobs) do
                    if playerLogin then
                        if PlayerData == {} then
                            PlayerData = QBCore.Funtions.GetPlayerData()
                        end
                        if z == PlayerData.job.name then
                            if enterDist < 5.0 then
                                sleep = 5
                                DrawMarker(2, v.Teleport.enter.x, v.Teleport.enter.y, v.Teleport.enter.z, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 32, 236, 54, 100, 0, 0, 0, 1, 0, 0, 0)
                                if enterDist < 1.5 then
                                    ShowFloatingHelpNotification("~g~[E]~w~ İçeri gir", v.Teleport.enter, 2.0)
                                    if IsControlJustPressed(0, 38) then
                                        SetEntityCoords(plyPed, v.Teleport.exit.x, v.Teleport.exit.y, v.Teleport.exit.z, false, false, false, true)
                                    end
                                end
                            end
                            
                            if exitDist < 5.0 then
                                sleep = 5
                                DrawMarker(2, v.Teleport.exit.x, v.Teleport.exit.y, v.Teleport.exit.z, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 32, 236, 54, 100, 0, 0, 0, 1, 0, 0, 0)
                                if exitDist < 1.5 then
                                    ShowFloatingHelpNotification("~g~[E]~w~ Dışarı çık", v.Teleport.exit, 2.0)
                                    if IsControlJustPressed(0, 38) then
                                        SetEntityCoords(plyPed, v.Teleport.enter.x, v.Teleport.enter.y, v.Teleport.enter.z, false, false, false, true)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

function ShowFloatingHelpNotification(msg, coords,r)
    AddTextEntry('FloatingHelpNotification'..'_'..r, msg)
    SetFloatingHelpTextWorldPosition(1, coords.x,coords.y,coords.z + 0.2)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('FloatingHelpNotification'..'_'..r)
    EndTextCommandDisplayHelp(2, false, false, -1)
end

RegisterNetEvent("fixstore-marsmellow:client:SellItem", function(data)
    local RequiredItems = {}
    local GiveItem = {}
    for k, v in pairs(Menu[data.itemId].RequiredItems) do
        RequiredItems[#RequiredItems+1] = v
    end

    for k, v in pairs(Menu[data.itemId].GiveItem) do
        GiveItem[#GiveItem+1] = v
    end

    TriggerServerEvent("fixstore-marsmellow:server:SellItem", {GiveItem = GiveItem, RequiredItems = RequiredItems}, QBCore.Key)
end)