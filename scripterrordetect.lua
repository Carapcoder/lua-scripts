if not manage.lookup("aliased" ,"timer") then
  local description = {format = "integer",name = "script timer",retention = {count = 1 ,duration = "infinity"},visibility = "private"}
  local success ,rid = manage.create("dataport" ,description)
  if not success then
    debug("error initializing timer dataport: "..rid or "")
    return
  end
  manage.map("alias" ,rid ,"timer")
end
local timer = alias['timer']

if not timer.timestamp then
  timer.value = 30
end

debug('starting')
settimezone("America/Sao_Paulo") 
debug('current time:'..date())

local email_address = 'tiago.siqueira@novusautomation.com'

local first_run = true
while true do
  local timeval = date('*t') -- get the current date/time
  if first_run == true or (timeval.hour == 7 or timeval.hour == 15) and timeval.min == 0 then
    debug(string.format('Current Date/Time: %d:%d',timeval.hour,timeval.min)) 
    debug('time to check for error scripts')
    first_run = false
    local error_scripts = {}
    local checked_count = 0
    -- get list of devices owned by this portal
    local success ,result = manage.listing({"client"} ,{"owned"})
    if success then
      debug(string.format('found %d devices',#result['client']))
      for _ ,device_rid in ipairs(result['client']) do
        -- for device, get each datarule (script)
        local device_client = alias[{rid=device_rid}]
        --debug(string.format('getting portals for user: %s',device_client.name))
        local success ,result = device_client.manage.listing({"datarule"} ,{"owned"})
        if success then
          for _ ,datarule_rid in ipairs(result['datarule']) do
            -- for each datarule, check if script or not
            local success,info = device_client.manage.info( datarule_rid,{"description","basic"})
            if success then
              if info['description']['format'] == 'string' then
                --found script
                checked_count = checked_count + 1
                if info['basic']['status'] == 'error' then
                  local script_name = info['description']['name']
                  local device_name = device_client.name
                  local script_rid = datarule_rid
                  debug('found script with error')
                  local activity = ''
                  -- go through info['basic']['activity']
                  debug(string.format('Device: %s, Script: %s',device_name,script_name))
                  table.insert(error_scripts,{device=device_client.name,script=script_name,rid=datarule_rid})
                end
              end
            end
          end
        end
      end
    else
      debug("failed to list clients")
    end
    debug(string.format('found %d error scripts out of %d checked',#error_scripts, checked_count))
    
    if #error_scripts > 0 or (timeval.hour == 7 and timeval.wday == 2) then
      local reported = string.format('START\r\nFound %d Scripts In Error State\r\n---',#error_scripts)
      for i,values in ipairs(error_scripts) do
        reported = reported..'\r\n---\r\n'..json.encode(values)
      end
      reported = reported..'\r\n---\r\nEND'
      local portal_name = alias[''].name
      local email_subject = string.format('Script Report for Arena, Errors:%d',#error_scripts or 0)
      email(email_address,email_subject,reported)
    end
  end
  timer.wait(now + 60)
end
