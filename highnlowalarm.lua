local REM1 = alias['00300916020186'].alias['REM1']

local TIMER = alias['00300916020186'].alias['TIMER']

local userEmails = {'jrodgers@colpipe.com'}
local userEmailsQty = 1

local dataportNames = {'Channel 1 Remote Monitoring Station'}
local nofitied_HIGH = {false}
local nofitied_LOW = {false}
local limits_HIGH = {30}
local limits_LOW = {0}
local deviceValues = {0}
  
debug('starting scheduled script')

settimezone("America/New_York")

debug(string.format('Current Date/Time (MY TZ): %s',date()))

while true do
	local ts1 = TIMER.wait(now+10) -- unblock every 100 seconds
  
  	deviceValues[1] = tonumber(REM1.value)
  
    -- CHECK LIMITS
	for i=1, 2 do
		local value = tonumber(deviceValues[i])
		    
		if value ~= nil then
			
			-- BUSINESS RULE HIGH
			if (value > limits_HIGH[i]) then
				
				if not nofitied_HIGH[i] then
					
  	local message = string.format('Dataport: %s  HIGH ALARM VALUE %d C', dataportNames[i], value)
				--debug(message)
					
					for x=1, userEmailsQty do
						email(userEmails[x], "HIGH ALARM!", message)
					end
					
					nofitied_HIGH[i] = true
					
				end
			else
				nofitied_HIGH[i] = false
			end
			
			-- BUSINESS RULE LOW
			if (value < limits_LOW[i]) then
				
				if not nofitied_LOW[i] then
					
          			local message = string.format('Dataport: %s  LOW ALARM VALUE %d', dataportNames[i], value)
					--debug(message)
					
					for x=1, userEmailsQty do
						email(userEmails[x], "LOW ALARM!", message)
					end
					
					nofitied_LOW[i] = true
					
				end
			else
				nofitied_LOW[i] = false
			end      		
			
		end
		
	end

end
