local skynet = require "skynet"

local GPIO = require "GPIO"


local wifiCar

local Wheel = {}
Wheel.__index = Wheel

function Wheel.new( pin )
    local obj = {}
    obj.pin = pin
    obj.state = 2
    GPIO.setmode(GPIO.BOARD)  
    GPIO.setup(pin[1],GPIO.OUT)  
    GPIO.setup(pin[2],GPIO.OUT)  
    return setmetatable(obj,Wheel)
end

function Wheel:change( state )
    if self.state == state then 
        return
    end

    if state == 0 then 
        GPIO.output(self.pin[1],GPIO.LOW)  
        GPIO.output(self.pin[2],GPIO.LOW) 
    elseif state == 1 then 
        GPIO.output(self.pin[2],GPIO.HIGH)  
        GPIO.output(self.pin[1],GPIO.LOW)
    elseif state == -1 then
        GPIO.output(self.pin[1],GPIO.HIGH)  
        GPIO.output(self.pin[2],GPIO.LOW)  
    end
end

function Wheel:forward()
    self:change(1)
end

function Wheel:stop(  )
    self:change(0) 
end

function Wheel:back(  )
    self:change(-1)
end


local Car = {}

Car.__index = Car

function Car.new( is4Wheel )
    local obj = {}
    obj.is4Wheel = is4Wheel

    obj.fl = Wheel.new({13,15,"fl"})
    obj.fr = Wheel.new({16,18,"fr"})

    if obj.is4Wheel == true then 
        obj.bl = Wheel.new({19,21,"bl"})
        obj.br = Wheel.new({22,24,"br"})
    end

    obj.speed = 10
    obj.xspeed = 0   --right    +   left  - 
    obj.yspeed = 0   --forward  +   back  -
    
    
    GPIO.setup {
        channel = 21,
        direction = GPIO.OUT,
        initial = GPIO.LOW,
    }
    obj.pwmA = GPIO.newPWM(21,100)
    
    obj.pwmA:start(50)
    
    
    GPIO.setup {
        channel = 19,
        direction = GPIO.OUT,
        initial = GPIO.LOW,
    }
    obj.pwmB = GPIO.newPWM(19,100)
    
    obj.pwmB:start(50)
    
    obj.pwmA:ChangeDutyCycle(90)
    obj.pwmB:ChangeDutyCycle(90)
    --obj.pwmA:stop()

    return setmetatable(obj,Car)
end

function Car:left( )
    self.fl:back()
    self.fr:forward()

    if self.is4Wheel ==true then 
        self.bl:back()
        self.br:forward()
    end
end

function Car:right( )
    self.fl:forward()
    self.fr:back()

    if self.is4Wheel ==true then 
        self.bl:forward()
        self.br:back()
    end

end

function Car:forward( )
    self.fl:forward()
    self.fr:forward()
    if self.is4Wheel ==true then 
        self.bl:forward()
        self.br:forward()        
    end

end

function Car:back( )
    self.fl:back()
    self.fr:back()

    if self.is4Wheel ==true then 
        self.bl:back()  
        self.br:back()
    end

end

function Car:stop( )
    self.fl:stop()
    self.fr:stop()

    if self.is4Wheel ==true then 
        self.bl:stop()
        self.br:stop()
    end
end

function accept.dir(pid,dir )
    pid = tonumber(pid)
    dir = tonumber(dir)

    if pid ==1 then 
        if dir == 0 then                    --DEFAULT = 0, 
            wifiCar.xspeed = 0
        elseif dir == 1 then                --D_UP = 1,
            wifiCar.xspeed =   wifiCar.speed
        elseif dir == 2 then                --D_DOWN = 2,
            wifiCar.xspeed = - wifiCar.speed
        elseif dir == 5 then                --D_LEFT_UP = 5,
            wifiCar.xspeed =   wifiCar.speed
        elseif dir == 6 then                --D_LEFT_DOWN = 6,
            wifiCar.xspeed = - wifiCar.speed
        elseif dir == 7 then                --D_RIGHT_UP = 7,
            wifiCar.xspeed =   wifiCar.speed
        elseif dir == 8 then                --D_RIGHT_DOWN =8
            wifiCar.xspeed = - wifiCar.speed
        else
            wifiCar.xspeed = 0  
        end
    else
        if dir == 0 then                    --DEFAULT = 0, 
            wifiCar.yspeed = 0
        elseif dir == 3 then                --D_LEFT = 3,
            wifiCar.yspeed = - wifiCar.speed
        elseif dir == 4 then                --D_RIGHT = 4,
            wifiCar.yspeed =   wifiCar.speed
        elseif dir == 5 then                --D_LEFT_UP = 5,
            wifiCar.yspeed = - wifiCar.speed
        elseif dir == 6 then                --D_LEFT_DOWN = 6,
            wifiCar.yspeed = - wifiCar.speed
        elseif dir == 7 then                --D_RIGHT_UP = 7,
            wifiCar.yspeed =   wifiCar.speed
        elseif dir == 8 then                --D_RIGHT_DOWN =8
            wifiCar.yspeed =   wifiCar.speed
        else
            wifiCar.yspeed = 0
        end
    end

    
end

local function loop( ... )
    local time = skynet.time()

    if wifiCar.xspeed > 0 then
        wifiCar:right()
    elseif wifiCar.xspeed < 0 then
        wifiCar:left()
    else    
        if wifiCar.yspeed > 0 then
            wifiCar:forward()
        elseif wifiCar.yspeed < 0 then
            wifiCar:back()
        end
    end

    if wifiCar.xspeed ==0 and wifiCar.yspeed == 0 then 
        wifiCar:stop()
    end
  
    local delayTime = (skynet.time()-time)*100      
    if delayTime > 10 then                         
        print("error loop time > 1s  maybe io busy") 
        delayTime = 9
    end
    skynet.timeout(10-delayTime,loop)              
end

function exit( )
    GPIO.cleanup()
end

function init( )
    GPIO.setwarnings(false)
    wifiCar = Car.new(false)
    wifiCar:stop()

    loop()
end
