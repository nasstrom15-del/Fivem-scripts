ESX = exports["es_extended"]:getSharedObject()

Gangpanel = {}

----------------------------------------
-- UTILS
----------------------------------------

function ExtractIdentifiers(playerId)
    local identifiers = {
        steam = "",
        discord = "",
        license = ""
    }

    for i = 0, GetNumPlayerIdentifiers(playerId) - 1 do
        local id = GetPlayerIdentifier(playerId, i)
        if string.find(id, "steam") then identifiers.steam = id end
        if string.find(id, "discord") then identifiers.discord = id end
        if string.find(id, "license") then identifiers.license = id end
    end

    return identifiers
end

----------------------------------------
-- GANG INFO / LEVEL
----------------------------------------

function Gangpanel:getGangLevel(gang, label, cb)
    MySQL.Async.fetchAll(
        "SELECT * FROM ganginfo WHERE gang = @gang",
        {["@gang"] = gang},
        function(res)
            if res[1] then
                cb(res[1].level, res[1].points, res[1].purchases)
            else
                MySQL.Async.execute(
                    "INSERT INTO ganginfo (gang, ganglabel, level, points, purchases) VALUES (@g,@l,1,0,0)",
                    {["@g"] = gang, ["@l"] = label},
                    function()
                        cb(1,0,0)
                    end
                )
            end
        end
    )
end

----------------------------------------
-- HUVUD MENY CALLBACK (DEN SOM ÖPPNAR MENYN)
----------------------------------------

ESX.RegisterServerCallback("xo_gangpanel:retrieveGangInfo", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(false) return end

    -- Boss-check (ändra siffran om du vill)
    if xPlayer.job.grade < 3 then
        TriggerClientEvent("esx:showNotification", source, "Endast bossen har tillgång.")
        cb(false)
        return
    end

    local job = xPlayer.job.name
    local label = xPlayer.job.label

    MySQL.Async.fetchAll("SELECT * FROM users WHERE job = @job", {
        ["@job"] = job
    }, function(members)

        MySQL.Async.fetchAll("SELECT * FROM gangtransactions WHERE job = @job", {
            ["@job"] = job
        }, function(transactions)

            MySQL.Async.fetchAll("SELECT * FROM zones WHERE owner = @job", {
                ["@job"] = job
            }, function(zones)

                Gangpanel:getGangLevel(job, label, function(level, points, purchases)

                    TriggerEvent("esx_addonaccount:getSharedAccount", "society_" .. job, function(account)

                        local response = {
                            name = job,
                            label = label,
                            balance = account and account.money or 0,
                            level = level,
                            points = points,
                            purchases = purchases,
                            employees = {},
                            transactions = {},
                            zones = zones
                        }

                        for _, m in ipairs(members) do
                            table.insert(response.employees, {
                                name = (m.firstname or "") .. " " .. (m.lastname or ""),
                                identifier = m.identifier,
                                grade = m.job_grade
                            })
                        end

                        for _, t in ipairs(transactions) do
                            table.insert(response.transactions, t)
                        end

                        cb(response)
                    end)
                end)
            end)
        end)
    end)
end)

----------------------------------------
-- REKRYTERA SPELARE
----------------------------------------

ESX.RegisterServerCallback("xo_gangpanel:recruitPlayer", function(source, cb, data)
    local recruiter = ESX.GetPlayerFromId(source)
    if not recruiter then cb(false) return end

    local target = ESX.GetPlayerFromIdentifier(data.identifier)
    if not target then cb(false) return end

    target.setJob(recruiter.job.name, 0)
    TriggerClientEvent("esx:showNotification", source, "Spelaren rekryterades")
    TriggerClientEvent("esx:showNotification", target.source, "Du blev rekryterad")

    cb(true)
end)

----------------------------------------
-- SPARKA SPELARE
----------------------------------------

ESX.RegisterServerCallback("xo_gangpanel:firePlayer", function(source, cb, data)
    local boss = ESX.GetPlayerFromId(source)
    if not boss then cb(false) return end

    if data.identifier == boss.identifier then
        TriggerClientEvent("esx:showNotification", source, "Du kan inte sparka dig själv")
        cb(false)
        return
    end

    local target = ESX.GetPlayerFromIdentifier(data.identifier)
    if target then
        target.setJob("unemployed", 0)
        TriggerClientEvent("esx:showNotification", target.source, "Du blev sparkad")
    else
        MySQL.Async.execute(
            "UPDATE users SET job = 'unemployed', job_grade = 0 WHERE identifier = @id",
            {["@id"] = data.identifier}
        )
    end

    cb(true)
end)

----------------------------------------
-- DEPOSIT / WITHDRAW
----------------------------------------

ESX.RegisterServerCallback("xo_gangpanel:deposit", function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    amount = tonumber(amount)

    if not xPlayer or amount <= 0 or xPlayer.getMoney() < amount then
        cb(false)
        return
    end

    TriggerEvent("esx_addonaccount:getSharedAccount", "society_" .. xPlayer.job.name, function(account)
        if not account then cb(false) return end

        xPlayer.removeMoney(amount)
        account.addMoney(amount)
        cb(true)
    end)
end)

ESX.RegisterServerCallback("xo_gangpanel:withdraw", function(source, cb, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    amount = tonumber(amount)

    if not xPlayer or amount <= 0 then cb(false) return end

    TriggerEvent("esx_addonaccount:getSharedAccount", "society_" .. xPlayer.job.name, function(account)
        if not account or account.money < amount then cb(false) return end

        account.removeMoney(amount)
        xPlayer.addMoney(amount)
        cb(true)
    end)
end)

----------------------------------------
-- ZONER
----------------------------------------

ESX.RegisterServerCallback("xo_gangpanel:claimZone", function(source, cb, zone)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(false) return end

    MySQL.Async.execute(
        "REPLACE INTO zones (zone, owner, ganglabel, claimtime) VALUES (@z,@o,@l,@t)",
        {
            ["@z"] = zone,
            ["@o"] = xPlayer.job.name,
            ["@l"] = xPlayer.job.label,
            ["@t"] = os.time()
        },
        function()
            cb(true)
        end
    )
end)

----------------------------------------
-- FAILSAFE
----------------------------------------

AddEventHandler("onResourceStop", function(res)
    if res == GetCurrentResourceName() then
        print("[xo_gangpanel] stopped safely")
    end
end)
