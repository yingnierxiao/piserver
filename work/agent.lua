local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local snax = require "snax"

local CMD = {}

local client_fd

local carServer 

local function send_package(pack)
	local size = #pack
	local package = string.char(bit32.extract(size,8,8)) ..
		string.char(bit32.extract(size,0,8))..
		pack

	socket.send(client_fd, package)
end



skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack =function ( msg ,size ) 
		return msg:byte(1)*256 +msg:byte(2),msg:sub(3,#msg-2) ,#msg-2
	end ,
	dispatch = function (session, address, pid,text,size)
		print(pid,text,size)
		carServer.post.dir(pid,text)
	end
}

function CMD.start(gate , fd ,addr)
	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)
end

skynet.start(function()

	carServer = snax.uniqueservice("carServer")
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)
