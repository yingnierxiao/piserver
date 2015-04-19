local skynet = require "skynet"


local capture = function(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

local function split(src,sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        src:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
end

function exit( )
    
end

function init( )

	skynet.fork(function()
		while true do
			local data = capture("ls ./work/pics")

			local fileList = split(data," ")
			if #fileList> 1 then 
				print("rm "..fileList[1])
				os.execute("rm ./work/pics/"..fileList[1])
			end
			-- print("lens",#fileList)
			
			if #fileList> 1 then 
				local cmd = "curl --request POST --data-binary @./work/pics/%s --header 'U-ApiKey:406d8ea87de40f35bafe7d6f68cae8d4' http://api.yeelink.net/v1.0/device/5811/sensor/17062/photos"
				cmd = string.format(cmd,fileList[2])
				print(cmd)
				os.execute(cmd)
			end
			
			skynet.sleep(1000)
		end
	end)

	os.execute("mjpg_streamer -i 'input_uvc.so' -o 'output_file.so -f ./work/pics -d 15000' & ")
end
