ESX = exports["es_extended"]:getSharedObject()
Gangpanel = {
    Gang = false,
    InAction = false,
    takingOver = false,
    IsOpenZoneInProgress = false,
    ActiveQuest = false,
    isSellingDrugs = false,
    ActivePeds = {},
    blips = {},
    Events = {
        close = function()
            SetNuiFocus(false, false)
            Gangpanel.inAction = false
        end,
        makeWithdrawal = function(data, cb)
            cb(Core:TriggerCallback("xo_gangpanel:makeWithdrawal", data))
        end,
        makeDeposit = function(data, cb)
            cb(Core:TriggerCallback("xo_gangpanel:makeDeposit", data))
        end,
        levelUp = function(data, cb)
            cb(Core:TriggerCallback("xo_gangpanel:levelUp", data))
        end,
        orderItems = function(data, cb)
            if not Gangpanel.ActiveQuest then
                cb(Core:TriggerCallback("xo_gangpanel:orderItems", data))
            else
                ESX.ShowNotification('Du har redan en pågående beställning, vänligen slutför den.')
                cb(false)
            end
        end,
        recruitPlayer = function(data, cb)
            cb(Core:TriggerCallback("xo_gangpanel:recruitPlayer", data))
        end,
        firePlayer = function(data, cb)
            cb(Core:TriggerCallback("xo_gangpanel:firePlayer", data))
        end,
        editEmployee = function(data, cb)
            cb(Core:TriggerCallback("xo_gangpanel:editEmployee", data))
        end,
        recruitClosestPlayer = function(data, cb)
            cb(Core:TriggerCallback("xo_gangpanel:recruitClosestPlayer", data))
        end,  
        TakeOverZone = function(data, cb)
            cb(Core:TriggerCallback("xo_gangpanel:TakeOverZone", data))
        end,  
        deleteZone = function(data, cb)
            cb(Core:TriggerCallback("xo_gangpanel:deleteZone", data))
        end, 
        ClaimRewards = function(data, cb)
            cb(Core:TriggerCallback("xo_gangpanel:ClaimRewards", data))
        end, 
        DrugSell = function(data, cb)
            if not Gangpanel.isSellingDrugs then
            Gangpanel:startSelling(data)
            else 
                Gangpanel:stopSelling()
            end
        end, 
    },
}

Citizen.CreateThread(function()
    Wait(1000)
    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
        Gangpanel:createBlips()
    end
    Gangpanel:Init()
end)

function Gangpanel:Init()
    while not ESX.PlayerData do
        Citizen.Wait(100)
    end
    
    self:createBlips()
    
    while true do
        local interval, playerPed = 1500, PlayerPedId()

        for _, zone in pairs(Config.Zones) do
            for _, v in pairs(zone.actions) do
                local dst = #(GetEntityCoords(playerPed) - v.coords)

                if dst < 10.0 and not self.inAction then
                    interval = 0

                    Core:drawtext3d(v.coords, not self.takingOver and ('[~b~E~s~] - Hantera Område') or ('Procent kvar: ~r~%s~s~/100'):format(self.procent))
                    Core:drawMarker(v.coords, not self.takingOver and 5.0 or 15.0, {30, 131, 247}) 

                    if dst < 5.0 and IsControlJustReleased(0, 38) then
                        if not v.action then
                            Gangpanel:OpenZone(zone.name, zone.actions)
                        else
                            self.inAction = true
                            v.action(zone)
                        end
                    end
                end
            end
        end

        Citizen.Wait(interval)
    end
end

function Gangpanel:takeOverTerritory(zoneName, zoneCoords)
    local timeStarted = GetGameTimer()

    if self.takingOver then return end

    self.takingOver = true

    Citizen.CreateThread(function()
        while self.takingOver do
            local interval = 0
            local playerPed = PlayerPedId()
            local dst = #(GetEntityCoords(playerPed) - vector3(zoneCoords.x, zoneCoords.y, zoneCoords.z))

            self.procent = Gangpanel:round((GetGameTimer() - timeStarted) / (Config.takeOverTime * 2000) * 100)

            if dst > Config.takingOverSize then
                self.inMarker = false
            else
                self.inMarker = true
            end

            Core:drawMarker(vector3(zoneCoords.x, zoneCoords.y, zoneCoords.z), 15.0, self.inMarker and {30, 131, 247} or {255, 0, 0})

            if dst > 15.0 then
                self.takingOver = false
                RemoveLoadingPrompt()
                ESX.ShowNotification('Ni misslyckades med att ta över området ' .. zoneName .. ' eftersom att ni lämnade området')

                TriggerServerEvent('xo_gangpanel:UpdateZoneBlip', zoneName, false)

            elseif self.procent > 100 then
                if self.inMarker then
                    self.takingOver = false
                    RemoveLoadingPrompt()

                    ESX.ShowNotification('Erat gäng har nu tagit över området ' .. zoneName)

                    ESX.TriggerServerCallback('xo_gangpanel:ClaimZone', function()
                    end, zoneName)

                else
                    self.takingOver = false
                    RemoveLoadingPrompt()
                end
            end

            Citizen.Wait(interval)
        end
    end)
end

RegisterNetEvent('xo_gangpanel:updateBlipForTakeover')
AddEventHandler('xo_gangpanel:updateBlipForTakeover', function(zoneName)
    Gangpanel:updateBlipForTakeover(zoneName)
end)

RegisterNetEvent('xo_gangpanel:refreshBlips')
AddEventHandler('xo_gangpanel:refreshBlips', function()
    Gangpanel:refreshBlips()
end)

RegisterNetEvent('xo_gangpanel:StartTakeOver')
AddEventHandler('xo_gangpanel:StartTakeOver', function(zoneName, zoneCoords)
    ESX.TriggerServerCallback('xo_gangpanel:CheckOwner', function()
        Gangpanel:takeOverTerritory(zoneName, zoneCoords)
        TriggerServerEvent('xo_gangpanel:triggerUpdateBlipForTakeover', zoneName)
    end, zoneName)
end)

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent("esx:setGang", function(job)
    ESX.PlayerData.gang = job
end)

RegisterNetEvent('xo_gangpanel:findClosestPlayer')
AddEventHandler('xo_gangpanel:findClosestPlayer', function(gang)
    local playerPed = PlayerPedId()
    local players = GetActivePlayers()
    local closestPlayer = nil
    local closestDistance = 2.0

    for _, playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)

        if targetPed ~= playerPed then
            local playerCoords = GetEntityCoords(playerPed)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)

            if distance <= closestDistance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end

    if closestPlayer then
        local targetServerId = GetPlayerServerId(closestPlayer)
        TriggerServerEvent('xo_gangpanel:foundClosestPlayer', targetServerId)
    else
        TriggerServerEvent('xo_gangpanel:foundClosestPlayer', nil)
    end
end)


RegisterNetEvent('xo_gangpanel:startQuest')
AddEventHandler('xo_gangpanel:startQuest', function(gangName, items, coords)
    local pedModel = GetHashKey(Config.QuestSettings.Ped[math.random(#Config.QuestSettings.Ped)])

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(1)
    end

    local ped = CreatePed(4, pedModel, coords.x, coords.y, coords.z - 1.0, 0.0, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)


    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 1) 
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 77)
    SetBlipAsShortRange(blip, true)
    SetBlipRoute(blip, true) 

    Gangpanel.ActiveQuest = true

    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        if Vdist(playerCoords.x, playerCoords.y, playerCoords.z, coords.x, coords.y, coords.z) < 2.0 then
            Core:Draw3DText(coords.x, coords.y, coords.z + 1.0, "Tryck ~y~E~w~ för att hämta")
            if IsControlJustReleased(0, 38) then 
                TriggerServerEvent('xo_gangpanel:completeQuest', gangName, items)
                PlayAmbientSpeech1(ped, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')
                
                local animDict = "mp_common"
                local animName = "givetake1_a"
                
                RequestAnimDict(animDict)
                while not HasAnimDictLoaded(animDict) do
                    Wait(1)
                end

                TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, -1, 50, 0, false, false, false)
                TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 50, 0, false, false, false)
                
                Wait(5000)
         
                PlayAmbientSpeech1(ped, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')
                
                FreezeEntityPosition(ped, false)
                SetPedAsNoLongerNeeded(ped)
                SetEntityInvincible(ped, false) 
                RemoveBlip(blip)
                Gangpanel.ActiveQuest = false
                return
            end
        end
    end
end)

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

RegisterNetEvent('xo_gangpanel:updateData', function()
    local result = Core:TriggerCallback('xo_gangpanel:retrieveGangInfo')
        
    if result then 
        SendNUIMessage({
            type = "openPanel",
            data = result,
        })
end
end)

function Gangpanel:open()
    local result = Core:TriggerCallback('xo_gangpanel:retrieveGangInfo')
        
    if result then 
        SendNUIMessage({
            type = "openPanel",
            data = result,
        })
        SetNuiFocus(true, true)        
    end
end

function Gangpanel:ScoreboardOpen()
    if exports.dillen_semiwhitelist:HasKrim() then
    local result = Core:TriggerCallback('xo_gangpanel:retrieveScoreboardInfo')
        
    if result then 
        SendNUIMessage({
            type = "openScoreboard",
            data = result,
        })
        SetNuiFocus(true, true)
        end
    else
        ESX.ShowNotification('Du behöver vara kriminell för att ha åtkomst till dessa funktioner')
    end
end

function Gangpanel:OpenZone(zoneName, zoneActions)
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        ESX.ShowNotification('Du kan inte öppna zonen när du sitter i ett fordon.')
        return
    end

    if Gangpanel:isBlacklisted(ESX.PlayerData.job.name, ESX.PlayerData.gang and ESX.PlayerData.gang.name) then
        ESX.ShowNotification('Ditt yrke eller gäng har inte tillgång till att hantera området.')
        return
    end    

    ESX.TriggerServerCallback('xo_gangpanel:retrieveZoneInfo', function(zoneInfo)
        if zoneInfo then
            SendNUIMessage({
                type = "openZone",
                data = {
                    zoneInfo = zoneInfo,
                    actions = zoneActions,
                    IsSellingDrugs = self.isSellingDrugs
                }
            })
            SetNuiFocus(true, true)
            self.inAction = true
        end
    end, zoneName)
end

for key, value in pairs(Gangpanel.Events) do
    RegisterNUICallback(key, value)
end

RegisterNetEvent('xo_gangpanel:findClosestPlayer')
AddEventHandler('xo_gangpanel:findClosestPlayer', function(gang)
    local playerPed = PlayerPedId()
    local players = GetActivePlayers()
    local closestPlayer = nil
    local closestDistance = 2.0

    for _, playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)

        if targetPed ~= playerPed then
            local playerCoords = GetEntityCoords(playerPed)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)

            if distance <= closestDistance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end

    if closestPlayer then
        local targetServerId = GetPlayerServerId(closestPlayer)
        TriggerServerEvent('xo_gangpanel:recruitPlayer', targetServerId, gang)
    else
        ESX.ShowNotification("Ingen spelare hittades i närheten.")
    end
end)

RegisterCommand('gangpanel', function()
    Gangpanel:open()
end)

function Gangpanel:isBlacklisted(job, gang)
    for _, blacklistedJob in ipairs(Config.Blacklisted) do
        if job == blacklistedJob then
            return true
        end
    end
    for _, blacklistedGang in ipairs(Config.Blacklisted) do
        if gang == blacklistedGang then
            return true
        end
    end
    return false
end

RegisterCommand('scoreboard', function()
    Gangpanel:ScoreboardOpen()
end)

function Gangpanel:round(value, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

exports('openPanel', function()
    Gangpanel:open()
end)

function Gangpanel:startSelling(data)
    Gangpanel.InAction = not Gangpanel.InAction

    if not Gangpanel.InAction then 
        for _, ped in pairs(Gangpanel.ActivePeds) do 
            if DoesEntityExist(ped) then 
                DeletePed(ped)
            end
        end

        Gangpanel.ActivePeds = {}
        self.isSellingDrugs = false
        self:updateSellingStatus(data.zone, data.actions)
        return 
    end

    local lastSpawned = GetGameTimer()
    local untilSpawn = math.random(Config.Selling.TimeBetweenSpawns.Min, Config.Selling.TimeBetweenSpawns.Max) * 1000

    local playerPed = PlayerPedId()
    local zoneCoords = nil
    local canSell = false
    local drugSells = {}
    local activePed = nil

    for _, zone in pairs(Config.Zones) do
        if zone.name == data.zone then
            for _, action in pairs(zone.actions) do
                zoneCoords = action.coords
                canSell = action.canSell
                drugSells = Config.Drugs.SellPrice 
                break
            end
        end
    end

    ESX.ShowNotification("Du har börjat ta emot kunder, de kommer hitta dig inom kort")
    self.isSellingDrugs = true
    self:updateSellingStatus(data.zone, data.actions)

    Citizen.CreateThread(function()
        while Gangpanel.InAction do 
            local distance = #(GetEntityCoords(playerPed) - zoneCoords)
            if distance > 10.0 then 
                Gangpanel.InAction = false
                ESX.ShowNotification("Du har sprungit för långt bort från ditt område, dina kunder gick hem igen")
                self.isSellingDrugs = false
                self:updateSellingStatus(data.zone, data.actions)
                break
            end

            if (GetGameTimer() - lastSpawned) > untilSpawn and #Gangpanel.ActivePeds == 0 then
                local randomPed = Config.Selling.PedModels[math.random(1, #Config.Selling.PedModels)]
                local spawnCoords = randomNearbyCoords(GetEntityCoords(playerPed))

                RequestModel(GetHashKey(randomPed))
                while not HasModelLoaded(GetHashKey(randomPed)) do
                    Wait(1)
                end

                if spawnCoords then
                    activePed = CreatePed(4, GetHashKey(randomPed), spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, true)

                    if DoesEntityExist(activePed) then
                        SetBlockingOfNonTemporaryEvents(activePed, true)
                        SetPedFleeAttributes(activePed, 0, false)
                        TaskStandStill(activePed, -1)

                        TaskGoToEntity(activePed, playerPed, -1, 1.0, 1.0, 1073741824.0, 0)

                        table.insert(Gangpanel.ActivePeds, activePed)

                        local timeStarted = GetGameTimer()

                        Citizen.CreateThread(function()
                            while (GetGameTimer() - timeStarted) < (120 * 1000) and not Gangpanel.IsDealing and Gangpanel.InAction do
                                local pedCoords = GetEntityCoords(activePed)
                                local distance = #(GetEntityCoords(playerPed) - pedCoords)

                                if IsPedInCombat(activePed, playerPed) or IsPedFleeing(activePed) or IsPedDeadOrDying(activePed, true) then
                                    if DoesEntityExist(activePed) then
                                        DeletePed(activePed)
                                    end
                                    ESX.ShowNotification("En kund blev sur och behövde säljning av dig")
                                    Gangpanel.ActivePeds = {}
                                    break
                                end

                                if distance < 2.0 and GetEntitySpeed(activePed) < 1.0 then
                                    Gangpanel.IsDealing = true
                                    break
                                end

                                Wait(1000)
                            end

                            if Gangpanel.IsDealing then 
                                while #(GetEntityCoords(playerPed) - GetEntityCoords(activePed)) < 2.0 and Gangpanel.IsDealing do
                                    local drawText = '[~g~Q~s~] - Sälj \n [~r~G~s~] - Avbryt'

                                    if IsControlJustReleased(0, 52) then
                                        ESX.TriggerServerCallback('xo_gangpanel:canSell', function(canSell)
                                            if canSell then
                                                if DoesEntityExist(activePed) then 
                                                    DeletePed(activePed)
                                                end
                                                Gangpanel.IsDealing = false
                                                Gangpanel.ActivePeds = {}
                                                TriggerEvent('xo_gangpanel:requestNextPed')
                                            else
                                                ESX.ShowNotification("Kunden gillade dig inte för att du inte hade varorna")
                                            end
                                        end, { zone = data.zone, DrugSells = drugSells })
                                        break
                                    end

                                    if IsControlJustReleased(0, 47) then
                                        Gangpanel.InAction = false
                                        if DoesEntityExist(activePed) then 
                                            DeletePed(activePed)
                                        end
                                        Gangpanel.ActivePeds = {}
                                        self.isSellingDrugs = false
                                        self:updateSellingStatus(data.zone, data.actions)
                                        break
                                    end

                                    ESX.Game.Utils.DrawText3D(GetEntityCoords(activePed) + vector3(0,0,0.95), drawText)

                                    Wait(0)
                                end
                            end

                            if DoesEntityExist(activePed) then 
                                DeletePed(activePed)
                            end

                            Gangpanel.IsDealing = false
                            Gangpanel.ActivePeds = {}
                        end)

                        lastSpawned = GetGameTimer()
                        untilSpawn = math.random(Config.Selling.TimeBetweenSpawns.Min, Config.Selling.TimeBetweenSpawns.Max) * 1000
                    end
                end
            end

            Wait(1000) 
        end

        for _, ped in pairs(Gangpanel.ActivePeds) do 
            if DoesEntityExist(ped) then 
                DeletePed(ped)
            end
        end
        Gangpanel.ActivePeds = {}
    end)
end

function Gangpanel:createBlips()
    if exports["dillen_semiwhitelist"]:HasKrim() then
        for _, zone in pairs(Config.Zones) do
            for _, action in pairs(zone.actions) do
                local blip = AddBlipForCoord(action.coords.x, action.coords.y, action.coords.z)
                SetBlipSprite(blip, 9)
                SetBlipDisplay(blip, 8)
                SetBlipScale(blip, 0.1)
                SetBlipAlpha(blip, 100)

                ESX.TriggerServerCallback('xo_gangpanel:retrieveZoneInfo', function(zoneInfo)
                    if zoneInfo then
                        if zoneInfo.owner then
                            if zoneInfo.owner == ESX.PlayerData.job.name then
                                SetBlipColour(blip, 2)  -- Grön färg för zon ägd av spelarens jobb
                            else
                                SetBlipColour(blip, 1)  -- Röd färg för zon ej ägd av spelarens jobb
                            end
                        else
                            SetBlipColour(blip, 1)  -- Röd färg för zon utan ägare
                        end
                    else
                        SetBlipColour(blip, 1)  -- Röd färg för zon utan ägare
                    end
                end, zone.name)

                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(zone.name)
                EndTextCommandSetBlipName(blip)
                
                table.insert(self.blips, blip)
            end
        end
    end
end

function Gangpanel:refreshBlips()
    -- Ta bort alla nuvarande blips
    for _, blip in ipairs(self.blips) do
        RemoveBlip(blip)
    end
    self.blips = {}
    -- Skapa blips igen
    self:createBlips()
end

function Gangpanel:updateBlipForTakeover(zoneName)
    for _, blip in ipairs(self.blips) do
        local blipCoords = GetBlipCoords(blip)
        for _, zone in pairs(Config.Zones) do
            if zone.name == zoneName then
                for _, action in pairs(zone.actions) do
                    if blipCoords == vector3(action.coords.x, action.coords.y, action.coords.z) then
                        SetBlipColour(blip, 47)  -- Orange färg för aktiv zonövertagning
                        return
                    end
                end
            end
        end
    end
end

function Gangpanel:removeBlips()
    for _, blip in ipairs(self.blips) do
        RemoveBlip(blip)
    end
    self.blips = {}
end

function Gangpanel:monitorKrimAccess()
    Citizen.CreateThread(function()
        while true do
            if exports["dillen_semiwhitelist"]:HasKrim() then
                if #self.blips == 0 then
                    self:createBlips()
                end
            else
                if #self.blips > 0 then
                    self:removeBlips()
                end
            end
            Citizen.Wait(10000) -- Kontrollera var 10:e sekund
        end
    end)
end

function Gangpanel:updateSellingStatus(zoneName, zoneActions)
    if not zoneName or not zoneActions then
        return
    end
    
    ESX.TriggerServerCallback('xo_gangpanel:retrieveZoneInfo', function(zoneInfo)
        if zoneInfo then
            SendNUIMessage({
                type = "openZone",
                data = {
                    zoneInfo = zoneInfo,
                    actions = zoneActions,
                    IsSellingDrugs = self.isSellingDrugs
                }
            })
        else
            ESX.ShowNotification('Zonen finns inte.')
        end
    end, zoneName)
end

RegisterNetEvent('xo_gangpanel:requestNextPed')
AddEventHandler('xo_gangpanel:requestNextPed', function()
    local data = {} 
    Gangpanel:startSelling(data)
end)

function randomNearbyCoords(coords)
    local angle = math.random() * math.pi * 2
    local radius = math.random(5, 10)
    local x = coords.x + math.cos(angle) * radius
    local y = coords.y + math.sin(angle) * radius
    local z = coords.z + 1.0
    return vector3(x, y, z)
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function Gangpanel:stopSelling()
    if self.isSellingDrugs then
        self.InAction = false
        self.isSellingDrugs = false
        
        for _, ped in pairs(self.ActivePeds) do
            if DoesEntityExist(ped) then
                DeletePed(ped)
            end
        end
        
        self.ActivePeds = {}
        ESX.ShowNotification("Du avslutade din runda och slutade söka kunder")
    end
end