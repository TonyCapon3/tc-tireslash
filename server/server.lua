RegisterServerEvent('tc-tireslash:sync')
AddEventHandler('tc-tireslash:sync', function(id, tireIndex)
	TriggerClientEvent('tc-tireslash:sync', id, tireIndex)
end)