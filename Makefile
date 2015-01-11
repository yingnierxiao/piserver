include skynet/platform.mk

.PHONY: all skynet clean



MY_LUA_CLIB_PATH ?= skynet/luaclib

CFLAGS = -g -O2 -Wall -I$(LUA_INC) $(MYCFLAGS) 

LUA_CLIB = protopack lpack


$(MY_LUA_CLIB_PATH) :
	mkdir $(MY_LUA_CLIB_PATH)


all : \
	skynet \
	GPIO \
	$(foreach v, $(LUA_CLIB), $(MY_LUA_CLIB_PATH)/$(v).so) 

skynet :
	cd skynet && $(MAKE) $(PLAT)
	
GPIO :
	cd 3rd/rpi-gpoi/lua && $(MAKE)
	cp 3rd/rpi-gpoi/lua/GPIO.so skynet/luaclib

$(MY_LUA_CLIB_PATH)/lpack.so : 3rd/lpack/lpack.c | $(MY_LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@


$(MY_LUA_CLIB_PATH)/protopack.so : lualib-src/ext-proto.c  | $(MY_LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@

clean :
	cd skynet && $(MAKE) clean
	
cleanall :
	cd skynet && $(MAKE) cleanall
