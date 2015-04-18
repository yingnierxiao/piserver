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



function exit( )
    
end

function init( )
	print(capture("./mjpg_streamer -i "input_uvc.so" -o "output_file.so -f ./pics -d 15000""))    
end
