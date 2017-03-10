local sp_minute = alias['sp_minute'] -- Get the Set point Minute in the widget
local sp_hour = alias['sp_hour']     -- Get the Set point Hour in the widget

local float_var = alias['virtualfieldtons'] --Field Conveyor TPH (REM03)
local float_6AM_var = alias['virtualfieldtons6AM'] 
local float_ACTUAL_var = alias['virtualfieldtonsACTUAL']
local float_AUX_var = alias['virtualfieldtonsAUX'] 

local num1 = alias['REM9'] --Field Tons High (REM9)
local num2 = alias['REM10'] --Field Tons Low (REM10)
local TIMER = alias['TIMER']

local ts = now

debug('starting scheduled script')

settimezone("America/Monterrey")

debug(string.format('Current Date/Time (MY TZ): %s',date()))


while true do

    local ts1 = TIMER.wait(ts+10) -- junta os valores a cada 10 segundos
    local timeval = date('*t') -- get the current date/time
    

	if num1.value ~= nil and num2.value ~= nil then --necessary check to don't break the code with a nil value
		if num1.value == -1 or num2.value == -1 then
			-- se qualquer um dos registradores estiver em valor de erro, pula fora.
		else
			if num2.value ~= 0 then
				if num1.value == 0 and num2.value == 65535 then 
					--neste  caso  não faz nada, pois não sabemos que é erro de comunicação
				else				
	
					float_ACTUAL_var.value = tonumber(num1.value*65536) + tonumber(num2.value)
						
					if(float_ACTUAL_var.value < float_6AM_var.value) then 
						--se o valor atual é menor que o das 6AM, então o 6AM assume o valor atual
						--e passa seu valor para o Aux, que dura até o final do dia, quando reseta tudo
						float_AUX_var.value = float_var.value   --AQUI ACONTECEU A CORREÇÃO
						float_6AM_var.value = float_ACTUAL_var.value
					end
						
	float_var.value = (float_ACTUAL_var.value - float_6AM_var.value) + float_AUX_var.value
				end			
			end		
		end 
	end
	
	if timeval.hour == sp_hour.value and timeval.min == sp_minute.value then
		float_6AM_var.value = float_ACTUAL_var.value
		float_var.value = 0 --reseta o contador
		float_AUX_var.value = 0 --reseta a auxiliar
	end

end
