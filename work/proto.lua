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

dir 2 {
	request {
		side 0 : integer
		dir 1  : integer
		time 2 : integer
		ping 3 : integer
	}
}


]]

proto.s2c = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

heartbeat 1 {}
]]

return proto
