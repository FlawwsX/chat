local chatInputActivating = false
local chatHidden = true
local chatLoaded = false

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:client:ClearChat')
RegisterNetEvent('chat:clear')
RegisterNetEvent('chat:toggleChat')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')

--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
  local args = { text }
  if author ~= "" then
    table.insert(args, 1, author)
  end
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      color = color,
      args = args
    }
  })
end)

AddEventHandler('__cfx_internal:serverPrint', function(msg)
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      templateId = 'print',
      args = { msg }
    }
  })
end)

AddEventHandler('chat:addMessage', function(message)
  if message['color'] then
    message =  { template = '<div class="chat-message-system"><b>SYSTEM :</b> {1}</div>', args = message['args'] }
  end
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = message
  })
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
  SendNUIMessage({
    type = 'ON_SUGGESTION_ADD',
    suggestion = {
      name = name,
      help = help,
      params = params or nil
    }
  })
end)

AddEventHandler('chat:addSuggestions', function(suggestions)
  for _, suggestion in ipairs(suggestions) do
    SendNUIMessage({
      type = 'ON_SUGGESTION_ADD',
      suggestion = suggestion
    })
  end
end)

AddEventHandler('chat:removeSuggestion', function(name)
  SendNUIMessage({
    type = 'ON_SUGGESTION_REMOVE',
    name = name
  })
end)

RegisterNetEvent('chat:resetSuggestions')
AddEventHandler('chat:resetSuggestions', function()
  SendNUIMessage({
    type = 'ON_COMMANDS_RESET'
  })
end)

AddEventHandler('chat:addTemplate', function(id, html)
  SendNUIMessage({
    type = 'ON_TEMPLATE_ADD',
    template = {
      id = id,
      html = html
    }
  })
end)

AddEventHandler('chat:client:ClearChat', function(name)
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

AddEventHandler('chat:clear', function(name)
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

AddEventHandler('chat:toggleChat',function()
  chatVisibilityToggle = not chatVisibilityToggle

  local state = (chatVisibilityToggle == true) and "^1disabled" or "^2enabled"

  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
        color = {255,255,255},
        multiline = true,
        args = {"Chat Visibility has been "..state}
      }
    })
end)

RegisterCommand("tc",function()
  TriggerEvent('chat:toggleChat')
end)

RegisterNUICallback('chatResult', function(data, cb)
  SetNuiFocus(false)
  
  if not data.canceled then
    local id = PlayerId()

    --deprecated
    local r, g, b = 0, 0x99, 255

    if data.message:sub(1, 1) == '/' then
      ExecuteCommand(data.message:sub(2))
    else
      TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message)
    end
  end

  cb('ok')
end)

local function refreshCommands()
  if GetRegisteredCommands then
    local registeredCommands = GetRegisteredCommands()

    local suggestions = {}

    for i=1, #registeredCommands do
      local name = registeredCommands[i].name
      if IsAceAllowed(('command.%s'):format(name)) then
        table.insert(suggestions, { name = '/' .. name, help = '' })
      end
    end

    TriggerEvent('chat:addSuggestions', suggestions)
  end
end

local rNum = 0

AddEventHandler('onClientResourceStart', function(resName)
  Wait(500)
  rNum = rNum + 1
  if rNum >= 175 then refreshCommands() end
end)

AddEventHandler('onClientResourceStop', function(resName)
  Wait(500)
  refreshCommands()
end)

RegisterNUICallback('loaded', function(data, cb)
  TriggerServerEvent('chat:init');
  chatLoaded = true
  cb('ok')
end)

RegisterKeyMapping("+openchat", "Open Chat", "keyboard", "T")
RegisterCommand("-openchat", function() end, false) -- Disables chat from opening.

RegisterCommand("+openchat", function(source, args, rawCommand)
  if not exports["erp-multichar"]:InCharacterUI() then
    chatInputActivating = true
    TriggerEvent('chat:activating')
    SendNUIMessage({ type = 'ON_OPEN' })
  end
end, false)

SetTextChatEnabled(false)
SetNuiFocus(false)

AddEventHandler('chat:activating', function()
  while chatInputActivating do
    Wait(0)
    if not IsControlJustReleased(0, 245) then
      SetNuiFocus(true)
      chatInputActivating = false
    end
  end
end)

local streamerMode = false

RegisterNetEvent('adminChat:flipme')
AddEventHandler('adminChat:flipme', function()
  streamerMode = not streamerMode
  exports['mythic_notify']:SendAlert('inform', 'Streamer Mode Toggled.')
end)

RegisterNetEvent('adminChat:checkPermissions')
AddEventHandler('adminChat:checkPermissions', function(msg, user)
  if not streamerMode then
    TriggerServerEvent('erp-adminchat:checkPermissions', msg, user)
  end
end)

RegisterNetEvent('erp-chat:dispatch')
AddEventHandler('erp-chat:dispatch', function(msg, name)
  TriggerServerEvent('erp-chat:dispatch', msg, name)
end)

RegisterNetEvent('erp-chat:911')
AddEventHandler('erp-chat:911', function(id, msg, name, callid, pos)
  TriggerServerEvent('erp-chat:911', id, msg, name, callid, pos)
end)

RegisterNetEvent('erp-chat:311')
AddEventHandler('erp-chat:311', function(id, msg, name, callid, pos)
  TriggerServerEvent('erp-chat:311', id, msg, name, callid, pos)
end)


RegisterNetEvent('erp-chat:reply')
AddEventHandler('erp-chat:reply', function(id, msg, name, callid)
  TriggerServerEvent('erp-chat:reply', id, msg, name, callid)
end)

RegisterNetEvent("erp:walkcommand")
AddEventHandler("erp:walkcommand", function(msg)
    TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message-wal">{0}</div>',
        args = { msg }
    })
end)

RegisterNetEvent("erp:walkhelp")
AddEventHandler("erp:walkhelp", function(msg)
    TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message-wal"><b>Walks:</b> {0}</div>',
        args = { msg }
    })
end)

RegisterNetEvent("erp:emotehelp")
AddEventHandler("erp:emotehelp", function(msg)
    TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message-wal"><b>Emotes:</b> {0}</div>',
        args = { msg }
    })
end)

AddEventHandler("erp:vehdeg", function(msg, plate)
    TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message-deg"> Vehicle Plate: '..plate..'<br><b>Axle</b> : '..msg['axle']..'<br><b>Clutch</b> : '..msg['clutch']..'<br><b>Fuel Tank</b> : '..msg['fuel_tank']..'<br><b>Transmission</b> : '..msg['transmission']..'<br><b>Brakes</b> : '..msg['brakes']..'<br><b>Radiator</b> : '..msg['radiator']..'<br><b>Fuel Injector</b> : '..msg['fuel_injector']..'<br><b>Electronics</b> : '..msg['electronics']..'</div>',
        args = msg
    })
end)