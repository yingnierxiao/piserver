local sprotoparser = require "sprotoparser"

local proto = {}

proto.c2s = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

handshake 1 {
	request {
		clientTime 0 :integer
	}
	response {
		clientTime 0 : integer
		serverTime 1 : integer
	}
}

direction 1 {
	request {
		speedX 		0:interger 
		speedY 		1:interger	
	}
}

]]

proto.s2c = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}


handshake 1 {}

updateSensorData 2 {
	request {
		distance 	0:integer   #距离传感器
		height 		1:integer 	#高度传感器
		angle   	2:integer 	#角度传感器
		gyroscopeX	3:integer 	#陀螺仪
		gyroscopeY	4:integer 	#陀螺仪
		gyroscopeZ	5:integer 	#陀螺仪
	}
}

]]



return proto
