local oocon = false

RegisterCommand('clear', function(source, args, rawCommand)
    TriggerClientEvent('chat:client:ClearChat', source)
end, false)

RegisterCommand('toggleooc', function(source, args, rawCommand)
    oocon = not oocon
end, true)

RegisterCommand('requestrole', function(source, args, rawCommand)
    TriggerEvent('erp-adminmenu:discord', 'Request role from '..GetPlayerName(source)..' ('..source..')', rawCommand, '6003445', 'https://discord.com/api/webhooks/830537064125956128/OSUY1q-KRWJ4VnWHLg8O-ErZ6yms5q21baVKkXD2JmnteKonWTOljdXZDCh-iusF2gNw')
end, false)

RegisterCommand('announce', function(source, args, rawCommand)
    local msg = rawCommand:sub(9)
    if source == 0 then
        TriggerEvent('chat:server:ServerPSA', msg)
    else
        if IsPlayerAceAllowed(source, 'envyrp.mod') or IsPlayerAceAllowed(source, 'envyrp.admin') then
			TriggerEvent('chat:server:ServerPSA', msg)
		end
    end
end, false)

RegisterCommand('a', function(source, args, rawCommand)
    local src = source

    if IsPlayerAceAllowed(source, 'envyrp.mod') or IsPlayerAceAllowed(source, 'envyrp.admin') then
        local msg = rawCommand:sub(2)
        TriggerClientEvent('adminChat:checkPermissions', -1, msg, GetPlayerName(src))
    end
end, false)

RegisterCommand('ooc', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    if source == 0 then
        local user = "Console"
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message-ooc"><b>OOC <font color="red"><b>{0}</b></font>:</b> {1}</div>',
            args = { user, msg }
        }) 
    else 
        if player ~= false then
            if oocon then
                local user = GetPlayerName(src)
                    TriggerClientEvent('chat:addMessage', -1, {
                    template = '<div class="chat-message-ooc"><b>OOC {0}:</b> {1}</div>',
                    args = { user, msg }
                })
            else
                TriggerEvent('erp:addChatSystem', 'This chat is currently disabled.', source)
            end
        end
    end
end, false)

RegisterCommand('id', function(source, rawCommand)
    local src = source
    if player ~= false then
        local user = GetPlayerName(src)
        TriggerEvent('erp:addChatSystem', 'ID '..src, src)
    end
end, false)