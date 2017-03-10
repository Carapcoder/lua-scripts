local sp_minute = alias['sp_minute'] -- Get the Set point Minute in the widget
local sp_hour = alias['sp_hour']     -- Get the Set point Hour in the widget

local sand_conveyor = alias['REM1']  --ANL1
local x1418 = alias['REM2']          --ANL2
local rock_tph = alias['REM3']       --ANL3
local sand_tons = alias['REM5']      --VRT001
local x1418tons = alias['REM6']      --VRT002
local rock_tons = alias['REM7']      --VRT003
local belt_tons = alias['REM8']      --VRT011 
local field_conveyor_tons = alias['virtualfieldtons']

local auxdif1 = alias['auxdif1']     --Auxiliar Variable to show diff values 
local auxdif2 = alias['auxdif2']
local auxdif3 = alias['auxdif3']
local auxdif4 = alias['auxdif4']

local auxret1 = alias['auxret1']     --Auxiliar Variable to keep the last value
local auxret2 = alias['auxret2']
local auxret3 = alias['auxret3']
local auxret4 = alias['auxret4']

local AuxForReset1 = alias['AuxForReset1']
local AuxForReset2 = alias['AuxForReset2']
local AuxForReset3 = alias['AuxForReset3']
local AuxForReset4 = alias['AuxForReset4']

local timer = alias['TIMER']
local total_tons = alias['total_tons']
local total_tph = alias['total_tph']

local ts = now

debug('starting scheduled script')
 
settimezone("America/Monterrey")
 
debug(string.format('Current Date/Time (MY TZ): %s',date()))

while true do
 
    local ts1 = timer.wait(ts+60) -- unblock every 60 seconds
    local timeval = date('*t') -- get the current date/time
  
    if sand_tons.value ~= 0 and sand_tons.value ~= nil then
      if tonumber(sand_tons.value) < auxret1.value then
      		AuxForReset1.value = auxdif1.value
   			auxret1.value = sand_tons.value
  		else
        auxdif1.value = (sand_tons.value - auxret1.value) + AuxForReset1.value
      end
    end
                
    if x1418tons.value ~= 0 and x1418tons.value ~= nil then
      if tonumber(x1418tons.value) < auxret2.value then
         AuxForReset2.value = auxdif2.value
         auxret2.value = x1418tons.value
        else
          auxdif2.value = (x1418tons.value - auxret2.value) + AuxForReset2.value
        end 
    end
  
    if rock_tons.value ~= 0 and rock_tons.value ~= nil then
    	if tonumber(rock_tons.value) < auxret3.value then
            AuxForReset3.value = auxdif3.value
      		auxret3.value = rock_tons.value
      else
      auxdif3.value = (rock_tons.value - auxret3.value) + AuxForReset3.value
      end
    end 
  
    if belt_tons.value ~= 0 and belt_tons.value ~= nil then
    	if tonumber(belt_tons.value) < auxret4.value then
            AuxForReset4.value = auxdif4.value
      		auxret4.value = belt_tons.value
      else
      auxdif4.value = (belt_tons.value - auxret4.value) + AuxForReset4.value
      end
    end 
 
    if rock_tph.value ~= 0 and rock_tph.value ~= nil and x1418.value ~= 0 and x1418.value ~= nil and sand_conveyor.value ~= 0 and sand_conveyor.value ~= nil then
   		 total_tph.value = rock_tph.value + x1418.value + sand_conveyor.value
    end
  
    total_tons.value = (auxdif1.value + auxdif2.value + auxdif3.value)
   
    if timeval.hour == sp_hour.value and timeval.min == sp_minute.value then
        auxret1.value = sand_tons.value
        auxret2.value = x1418tons.value
        auxret3.value = rock_tons.value
        auxret4.value = belt_tons.value
        auxdif1.value = 0
        auxdif2.value = 0
        auxdif3.value = 0
        auxdif4.value = 0
   		AuxForReset1.value = 0
   		AuxForReset2.value = 0
   		AuxForReset3.value = 0
   		AuxForReset4.value = 0
        total_tph.value = 0
    end
end
