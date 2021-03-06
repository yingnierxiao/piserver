local skynet = require "skynet"
local snax = require "snax"
local max_client = 64


skynet.start(function()
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = max_client,
		nodelay = true,
	})
	print("Watchdog listen on ", 8888)
	snax.uniqueservice("carServer")
	snax.uniqueservice("waveDis")
	skynet.newservice("findMe")

	skynet.exit()
end)
