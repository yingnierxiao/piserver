local skynet = require "skynet"
local GPIO = require "GPIO"

require("ul_time")

local GPIO_TRIGGER = 11
local GPIO_ECHO    = 12

function exit( )
    GPIO.cleanup()
end

local function loop()
	GPIO.output(GPIO_TRIGGER, GPIO.LOW)
	os.delay_s(0.5)
	GPIO.output(GPIO_TRIGGER, GPIO.HIGH)
	os.delay_us(10)
	GPIO.output(GPIO_TRIGGER, GPIO.LOW)
	local start 
	local elapsed 
	local stop

	_,start = os.timeofday()
	while GPIO.input(GPIO_ECHO)==GPIO.LOW do
		_,start = os.timeofday()
	end
	while GPIO.input(GPIO_ECHO)==GPIO.HIGH do
		 _,stop = os.timeofday()
	end
	if stop < start then 
		print(start,stop)
		stop = stop + 1000000
	end
	elapsed = stop-start


	distance = elapsed * 0.000001 * 34300 / 2
	if distance < 0 then 
		print(start,stop)
	end
	-- print(string.format("Distance : %.1f" ,distance))

	skynet.timeout(50,loop) 
end

function init( )
	GPIO.setmode(GPIO.BOARD)  
    GPIO.setwarnings(true)



	GPIO.setup(GPIO_TRIGGER,GPIO.OUT) 
	GPIO.setup(GPIO_ECHO,GPIO.IN)  
    
 	loop()
end
