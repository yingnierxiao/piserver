local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local protopack = require "protopack"
local snax = require "snax"

local CMD = {}

local client_fd

local carServer 

local function send_client(v)
	socket.write(client_fd, netpack.pack(jsonpack.pack(0, {true, v})))
end


skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack =function ( ... ) return protopack.pbcunpack(...) end ,
	dispatch = function (session, address, pid,text,size)
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
