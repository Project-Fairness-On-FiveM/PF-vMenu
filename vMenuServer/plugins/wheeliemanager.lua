flat = 0

AddEventHandler("vMenu:WheelieManager", function(cb)
    cb(ConfigShared.WheelieManager) 
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if ConfigShared.WheelieManager then
		ped = PlayerPedId()
		vehicle = GetVehiclePedIsIn(ped)
		if GetVehicleClass(vehicle) == 4 then
			if GetPedInVehicleSeat(vehicle, -1) == ped then
				angle = 3
				if ConfigShared.vehiclelistwm[GetEntityModel(vehicle)] then
					car = ConfigShared.vehiclelistwm[GetEntityModel(vehicle)]
				angle = car.maxangle + ((GetVehicleMod(vehicle, 11)+1)* car.enginemodlvleffect) + (IsTurboEnabled(vehicle)*car.turboeffect)
				else
					angle = ConfigShared.defaultmaxangle + ((GetVehicleMod(vehicle, 11)+1)* ConfigShared.defaultenginemodlvleffect) + ((IsTurboEnabled(vehicle))*ConfigShared.defaultturboeffect)
				end	
				vehiclespeed = GetEntitySpeed(vehicle)
				if GetEntityRotation(vehicle,0).x  > angle + flat then
					SetVehicleWheelieState(vehicle,1)
					flat = 0
				end
			end
		else
			Citizen.Wait(90)
		end
	else
		return
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if ConfigShared.WheelieManager then
		ped = PlayerPedId()
		vehicle = GetVehiclePedIsIn(ped)
		if GetVehicleClass(vehicle) == 4 then
			if GetVehicleWheelieState(vehicle) == 65 then
					flat = GetEntityRotation(vehicle,0).x
				Citizen.Wait(80)
			end
		else
			Citizen.Wait(90)
		end	
	else
		return
		end			
	end
end)

function IsTurboEnabled(vehicle)
	if IsToggleModOn(vehicle, 18) then
		return 1
	else
		return 0
	end
end

