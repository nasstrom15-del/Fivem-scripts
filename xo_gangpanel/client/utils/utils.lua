Core = {}

function Core:TriggerCallback(name, data)
    local p = promise.new()

    ESX.TriggerServerCallback(name, function(res) 
        p:resolve(res)
    end, data)

    return Citizen.Await(p)
end

function Core:drawtext3d(coords, text)
    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)  
    local factor = string.len(text) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

function Core:drawMarker(coords, markerSize, color)
    local r, g, b = table.unpack(color)
    DrawMarker(25, coords - vector3(0,0,0.97), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerSize, markerSize, markerSize, r, g, b, 100, false, true, 1, false, false, false, false)
end


function Core:Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

