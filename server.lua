ESX = nil
local uplatio = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem("loto", function(source)
	TriggerClientEvent("esx_invh:closeinv", source)
	TriggerClientEvent('sokol:loto:brojClient', source)
end)

RegisterNetEvent('sokol:loto:brojServer')
AddEventHandler('sokol:loto:brojServer', function(ulog, broj)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= ulog then
        MySQL.Async.fetchAll('SELECT id FROM loto WHERE id = @id', {
            ['@id'] = xPlayer.identifier
        },
        function(result)
            local nasoga = false
            for i = 1, #result, 1 do
                if xPlayer.identifier == result[i].id then
                    nasoga = true
                    break
                end
            end

            if nasoga then
                xPlayer.showNotification('Vec ste ~y~uplatili~s~ listic.')
            else
                xPlayer.removeMoney(ulog)
                xPlayer.removeInventoryItem("loto", 1)
                xPlayer.showNotification('~y~Uplatili~s~ ste ~g~$'..ulog..'~s~ na loto broj ' ..broj..'.')
                MySQL.Async.execute('INSERT INTO loto (id, broj, cijena) VALUES (@id, @br, @ul)', {['@id'] = xPlayer.identifier, ['@br'] = broj, ['@ul'] = ulog})
            end
        end)
    else
        xPlayer.showNotification('~r~Nemate~s~ dovoljno ~g~novca~s~ kod ~y~sebe~s~.')
    end
end)

function Loto()
    TriggerClientEvent('esx:showNotification', -1, "Loto pocinje za 15 minuta, uplatite listice dok mozete.")

	SetTimeout(900000, function()
		local izvucen = math.random(1, 120)
        TriggerClientEvent('esx:showNotification', -1, "[Loto] Izvucen je broj "..izvucen..".")
        MySQL.Async.fetchAll('SELECT * from loto', {},
        function(rezultat)
            for i = 1, #rezultat, 1 do
                if rezultat[i].broj == izvucen then
                    local xPlayer = ESX.GetPlayerFromIdentifier(rezultat[i].id)
                    if xPlayer ~= nil then
                        local dobitak = rezultat[i].cijena*100
                        xPlayer.addMoney(dobitak)
                        TriggerClientEvent('esx:showNotification', xPlayer.source, '~b~Cestitamo~s~ ~g~osvojili~s~ ste ~g~$'.. dobitak .. '~s~ na ~y~lotu~s~!')
                    end
                end
            end
            MySQL.Async.execute('DELETE from loto')
        end)

		SetTimeout(13500000, Loto)
	end)
end

SetTimeout(13500000, Loto)