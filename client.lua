ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('sokol:loto:brojClient')
AddEventHandler('sokol:loto:brojClient', function()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
		'dialog', GetCurrentResourceName(), 'ulog',
		{
			title = "Unesite cijenu uloga:"
		},
		function(data3, menu3)
			local ulog = tonumber(data3.value)
			if ulog == 0 then
				ESX.ShowNotification("Minimalno mozete uloziti $1.")
			else
				menu3.close()

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'broj',
					{
						title = "Unesite broj listica:"
					},
					function(data13, menu37)
						local broj = tonumber(data13.value)
						if broj == 0 or broj > 120 then
							ESX.ShowNotification("Broj listica ne moze biti manji od 1 i veci od 120.")
						else
							menu37.close()
                            TriggerServerEvent('sokol:loto:brojServer', ulog, broj)
						end
					end,

					function(data13, menu37)
						menu37.close()
					end
				)

			end
		end,

		function(data3, menu3)
			menu3.close()
		end
	)
end)