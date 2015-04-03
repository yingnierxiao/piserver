include skynet/platform.mk

.PHONY: all skynet clean

LUA_INC ?= skynet/3rd/lua

MY_LUA_CLIB_PATH ?= skynet/luaclib

CFLAGS = -g -O2 -Wall -I$(LUA_INC) $(MYCFLAGS) 

LUA_CLIB = ul_time


$(MY_LUA_CLIB_PATH) :
	mkdir $(MY_LUA_CLIB_PATH)


all : \
	skynet \
	$(foreach v, $(LUA_CLIB), $(MY_LUA_CLIB_PATH)/$(v).so) 
	GPIO \


skynet :
	cd skynet && $(MAKE) $(PLAT)
	
GPIO :
	cd 3rd/rpi-gpoi/lua && $(MAKE)
	cp 3rd/rpi-gpoi/lua/GPIO.so skynet/luaclib

$(MY_LUA_CLIB_PATH)/ul_time.so : 3rd/lua-time/src/ul_time.c | $(MY_LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@

clean :
	cd skynet && $(MAKE) clean
	
cleanall :
	cd skynet && $(MAKE) cleanall
