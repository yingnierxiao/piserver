local skynet = require "skynet"
local GPIO = require "GPIO"

require("ul_time")

local GPIO_ECHO    = 8

function exit( )
    GPIO.cleanup()
end

local function loop()
	
	
	print(GPIO.input(GPIO_ECHO))
	

	skynet.timeout(10,loop) 
end

function init( )
	GPIO.setmode(GPIO.BOARD)  
    GPIO.setwarnings(true)

	GPIO.setup(GPIO_ECHO,GPIO.IN)  
    
 	loop()
end
