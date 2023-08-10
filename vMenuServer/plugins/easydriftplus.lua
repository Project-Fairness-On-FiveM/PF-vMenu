local easydriftenabled = false
local EDDisplay = false
AddEventHandler("vMenu:EasyDriftPlus", function(cb)
    cb(ConfigShared.EasyDriftPlusPlugin) 
end)
AddEventHandler("vMenu:toggleEasyDrift", function(checked)
 	easydriftenabled = checked
end)
AddEventHandler("vMenu:toggleEasyDriftChangeVal", function(val)
 	majordriftval = (val/2)
end)
AddEventHandler("vMenu:toggleEasyDriftChangeValm", function(val)
 	minordriftval = (val/2)
end)

AddEventHandler("vMenu:toggleEasyDriftupdatemajorv", function(cb)
 	cb(ConfigShared.defaultmajordriftval) 
 	majordriftval = ConfigShared.defaultmajordriftval
end)

AddEventHandler("vMenu:toggleEasyDriftupdateminorv", function(cb)
    cb(ConfigShared.defaultminordriftval)  	
    minordriftval = ConfigShared.defaultminordriftval
end)

AddEventHandler("vMenu:toggleEasyDriftDisplay", function(checked)
	EDDisplay = checked
end)

function GetCurrentAngle()
    if IsPedInAnyVehicle(PlayerPedId(), false) or IsPedInAnyVehicle(PlayerPedId(), true)  then
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        local vx,vy,_ = table.unpack(GetEntityVelocity(veh))
        local modV = math.sqrt(vx*vx + vy*vy)


        local _,_,rz = table.unpack(GetEntityRotation(veh,0))
        local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))

        if GetEntitySpeed(veh)* 3.6 < 25 or GetVehicleCurrentGear(veh) == 0 then return 0,modV end --speed over 25 km/h

        local cosX = (sn*vx + cs*vy)/modV
        return math.deg(math.acos(cosX))*0.5, modV
    else
        return 0
    end
end


Citizen.CreateThread(function()
while true do
   Citizen.Wait(1)
   local ped = GetPlayerPed(-1)
   local vehicle = GetVehiclePedIsIn(ped, false)
   if vehicle ~= 0 then
      if easydriftenabled then
         reset = true
         DriftAngle = GetCurrentAngle()
         if DriftAngle > 5 then
            if GetVehicleSteeringAngle(vehicle) < 0 then
               steeringangle = GetVehicleSteeringAngle(vehicle) *-1
            else
               steeringangle = GetVehicleSteeringAngle(vehicle)
            end
            driftval = (10 / DriftAngle)*10
            if DriftAngle < ((majordriftval/2)+((majordriftval/2)*GetVehicleThrottleOffset(vehicle))) and GetVehicleThrottleOffset(vehicle) > 0.0 then
               if EDDisplay then
                  Draw2DText(0.0, 0.54, "~w~Major Assist LVL: ~g~"..majordriftval.."°", 0.5, false)
                  Draw2DText(0.0, 0.565, "~w~Minor Assist LVL: ~r~"..minordriftval.."°", 0.5, false)
               end
               SetVehicleReduceTraction(vehicle, 1+driftval)
               SetVehicleReduceGrip(vehicle, true)
            else
               if DriftAngle < ((minordriftval/2)+((minordriftval/2)*GetVehicleThrottleOffset(vehicle))) then
                  --SetVehicleEnginePowerMultiplier(vehicle, 1-driftval)
                  SetVehicleReduceGrip(vehicle, false)
                  SetVehicleReduceTraction(vehicle,1+driftval)
                  if EDDisplay then
                     Draw2DText(0.0, 0.54, "~w~Major Assist LVL: ~r~"..majordriftval.."°", 0.5, false)
                     Draw2DText(0.0, 0.565, "~w~Minor Assist LVL: ~g~"..minordriftval.."°", 0.5, false)
                  end
                  SetVehicleEnginePowerMultiplier(vehicle, 1+driftval)
               else
                  if EDDisplay then
                     Draw2DText(0.0, 0.54, "~w~Major Assist LVL: ~r~"..majordriftval.."°", 0.5, false)
                     Draw2DText(0.0, 0.565, "~w~Minor Assist LVL: ~r~"..minordriftval.."°", 0.5, false)
                  end
                  SetVehicleReduceTraction(vehicle,0.0)
                  SetVehicleReduceGrip(vehicle, false)
               end
            end
         else
            if EDDisplay then
               Draw2DText(0.0, 0.54, "~w~Major Assist LVL: ~r~"..majordriftval.."°", 0.5, false)
               Draw2DText(0.0, 0.565, "~w~Minor Assist LVL: ~r~"..minordriftval.."°", 0.5, false)
            end
            SetVehicleEnginePowerMultiplier(vehicle, 1.0)
            SetVehicleReduceTraction(vehicle,0.0)

            SetVehicleReduceGrip(vehicle, false)
         end
      end
      if not easydriftenabled and reset then
         SetVehicleEnginePowerMultiplier(vehicle, 1.0)
         SetVehicleReduceTraction(vehicle,0.0)

         SetVehicleReduceGrip(vehicle, false)
         reset = false
      end
   end
end
end)



function Draw2DText(x, y, text, scale, center)
    -- Draw text on screen
    if not IsHudHidden() then
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    if center then 
    	SetTextJustification(0)
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
 end
end