local num1 = alias['REM1']
local num2 = alias['REM2']
local delta = alias['DELTA_VALUE']
local user_number = '+5511985500573'
local userEmails = 'tiago.siqueira@novusautomation.com'
local TIMER = alias['TIMER']
local success, message = manage.info({alias = 'REM1'}, {"description"})
local one, two, three = message.description.meta:match("([^:]+),([^:]+):([^}]+)")
local dataportNames = 'Temperature'
local unit = string.sub(three,2,2)

local ts = now

debug('starting scheduled script')

settimezone("America/New_York")

debug(string.format('Current Date/Time (MY TZ): %s',date()))

while true do
    local ts1 = TIMER.wait(ts+10) -- junta os valores a cada 10 segundos
    local message = string.format('Dataport: %s  HIGH ALARM VALUE %d %s', dataportNames, delta.value, unit)

  	if num1.value ~= nil and num2.value ~= nil then
    	if tonumber(num1.value) ~= tonumber(num2.value) then
    		if tonumber(num1.value) > tonumber(num2.value)and (num1.value - num2.value) ~= delta.value then
      			delta.value = tonumber(num1.value) - tonumber(num2.value)
                	if delta.value >= 3 then
						dispatch.sms(user_number, message)
         				email(userEmails, "ALARM!", message)
 						debug("Triggered: "..tostring(delta.value..' '..unit))
          			end
        	end
      
      		if tonumber(num1.value) < tonumber(num2.value)and (num2.value - num1.value) ~= delta.value then
      			delta.value = tonumber(num2.value) - tonumber(num1.value)
                	if delta.value >= 3 then
          				dispatch.sms(user_number, 'Dataport Value: '..tostring(delta.value))
 						debug("Triggered: "..tostring(delta.value))
          			end
        	end
      	else
      		delta.value = 0
      	end 
    end
end
