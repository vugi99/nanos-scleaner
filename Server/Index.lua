
Package.Require("Config.lua")


function CopyTable(t)
    local nt = {}
    for k, v in pairs(t) do
        nt[k] = v
    end
    return nt
end

function SCleanerPrint(...)
    print("[SCleaner] :", ...)
end



if SCleaner_Components.Vehicle_Limit_Virus_Bug_Check.enabled then
    Timer.SetInterval(function()
        for k, v in pairs(Vehicle.GetPairs()) do
            local loc = v:GetLocation()
            if (loc.X > 1677721 or loc.Y > 1677721 or loc.Z > 1677721 or loc.X < -1677721 or loc.Y < -1677721 or loc.Z < -1677721) then
                SCleanerPrint("Destroying Vehicle (" .. tostring(v:GetID()) .. ") To Avoid Virus Bug")
                v:Destroy()
            end
        end
    end, SCleaner_Components.Vehicle_Limit_Virus_Bug_Check.check_interval_ms)
end



if SCleaner_Components.Remove_Entities_When_No_Players.enabled then
    Package.Subscribe("Load", function()
        --[[for k, v in pairs(debug.getregistry()) do
            print(k, v)
        end]]--
        for k, v in pairs(debug.getregistry().userdata) do
            if v.Destroy then
                if (v.SetValue and v.GetValue) then
                    v:SetValue("Cleaner_SpawnedWithMap", true, false)
                end
            end
        end
    end)

    Player.Subscribe("Destroy", function(ply)
        if #Player.GetPairs() <= 1 then
            local destroyed_nb = 0

            for k, v in pairs(CopyTable(debug.getregistry().userdata)) do
                if not NanosUtils.IsA(v, Player) then
                    if (v.IsValid and v:IsValid()) then
                        if v.Destroy then
                            if (v.SetValue and v.GetValue) then
                                if not v:GetValue("Cleaner_SpawnedWithMap") then
                                    v:Destroy()
                                    destroyed_nb = destroyed_nb + 1
                                end
                            end
                        end
                    end
                end
            end

            SCleanerPrint("Destroyed " .. tostring(destroyed_nb) .. " Entities")
        end
    end)
end
