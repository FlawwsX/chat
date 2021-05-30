RegisterCommand("streamermode", function(source, args, rawCommand)
    TriggerClientEvent('adminChat:flipme', source)
end, false)

RegisterNetEvent('chat:server:ServerPSA')
AddEventHandler('chat:server:ServerPSA', function(message)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message-server">SERVER: {0}</div>',
        args = { message }
    })
    CancelEvent()
end)

RegisterNetEvent("erp:addChatSystem")
AddEventHandler("erp:addChatSystem", function(msg, src)
    if src == nil then
        TriggerClientEvent('chat:addMessage', source, {
          template = '<div class="chat-message-system"><b>SYSTEM :</b> {1}</div>',
          args = { source, msg }
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message-system"><b>SYSTEM :</b> {1}</div>',
            args = { source, msg }
        })
    end
end)

AddEventHandler("erp:countcommand", function(job, name, class, src)
    TriggerClientEvent('chat:addMessage', src, {
        template = '<div class="'..class..'"><b>{0} :</b> {1}</div>',
        args = { job, name }
    })
end)

RegisterNetEvent("erp:rentalchat")
AddEventHandler("erp:rentalchat", function(msg, src)
    if src == nil then
        TriggerClientEvent('chat:addMessage', source, {
          template = '<div class="chat-message-system"><b>RENTAL :</b> {1}</div>',
          args = { source, msg }
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message-system"><b>RENTAL :</b> {1}</div>',
            args = { source, msg }
        })
    end
end)

RegisterNetEvent("erp:addChatNormal")
AddEventHandler("erp:addChatNormal", function(title, msg, src)
    if src == nil then
        TriggerClientEvent('chat:addMessage', source, {
          template = '<div class="chat-message-random"><b>{2} :</b> {1}</div>',
          args = { source, msg, title }
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message-random"><b>{2} :</b> {1}</div>',
            args = { source, msg, title }
        })
    end
end)

RegisterNetEvent("erp:phonenumber")
AddEventHandler("erp:phonenumber", function(sentId, sentNumber)
    TriggerClientEvent('chat:addMessage', sentId, {
        template = '<div class="chat-message-system"><b>Phone :</b> {0}</div>',
        args = { sentNumber }
    })
end)

RegisterNetEvent("erp:showId")
AddEventHandler("erp:showId", function(msg, src)
    if src == nil then
        TriggerClientEvent('chat:addMessage', source, {
          template = '<div class="chat-message-system">{1}</div>',
          args = { source, msg }
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message-system">{1}</div>',
            args = { source, msg }
        })
    end
end)

RegisterNetEvent("erp-adminchat:checkPermissions")
AddEventHandler("erp-adminchat:checkPermissions", function(msg, user)
    if IsPlayerAceAllowed(source, 'envyrp.mod') then
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message-anc"><b>STAFF {0}:</b> {1}</div>',
            args = { user, msg }
        })
    end
end)

RegisterNetEvent("erp:emsAddChat")
AddEventHandler("erp:emsAddChat", function(msg, src)
    if src == nil then
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="stategained"><b>STATUS ({0}) :</b> {1}</div>', args = { source, msg }
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="stategained"><b>STATUS ({0}) :</b> {1}</div>', args = { source, msg }
        })
    end
end, false)

RegisterNetEvent("erp:addChat")
AddEventHandler("erp:addChat", function(msg, src)
    if src == nil then
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message-info"><b>INFO :</b> {1}</div>',
            args = { source, msg }
        })
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message-info"><b>INFO :</b> {1}</div>',
            args = { source, msg }
        })
    end
end, false)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

RegisterNetEvent("erp-chat:dispatch")
AddEventHandler("erp-chat:dispatch", function(msg, name)
    local source = source
    local job = exports['envyrp']:GetOnePlayerInfo(source, 'job')
    if job then
        if (job.isPolice or job.name == 'ambulance' or job.name == 'mib') and job.duty == 1 then
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div class="chat-message-dispatch"><b>DISPATCH</b> : <b>{1}</b> | {0}</div>',
                args = { msg, name }
            })
        end
    end
end)

RegisterNetEvent("erp-chat:911")
AddEventHandler("erp-chat:911", function(id, msg, name, callid, pos)
    local source = source
    local job = exports['envyrp']:GetOnePlayerInfo(source, 'job')
    if job then
        if ((job.isPolice or job.name == 'ambulance' or job.name == 'mib') and job.duty == 1) or source == id then
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div class="chat-message-emergency"><b>[911]</b> : (<b>{3}</b>) <b>{1}</b> | C-ID: <b>{2}</b> | {0}</div>',
                args = { msg, name, callid, id }
            })
            TriggerClientEvent('erp-dispatch:setBlip', source, 911, pos, callid)
        end
    end
end)

RegisterNetEvent("erp-chat:311")
AddEventHandler("erp-chat:311", function(id, msg, name, callid, pos)
    local source = source
    local job = exports['envyrp']:GetOnePlayerInfo(source, 'job')
    if job then
        if ((job.isPolice or job.name == 'ambulance' or job.name == 'mib') and job.duty == 1) or source == id then
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div class="chat-message-emergencythree"><b>[311]</b> : (<b>{3}</b>) <b>{1}</b> | C-ID: <b>{2}</b> | {0}</div>',
                args = { msg, name, callid, id }
            })
            TriggerClientEvent('erp-dispatch:setBlip', source, 311, pos, callid)
        end
    end
end)
