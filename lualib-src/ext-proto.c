
#include <lua.h>
#include <lauxlib.h>
#include <stdlib.h>
#include <stdint.h>
#include <assert.h>
#include <string.h>

static int
_protoUnpack(lua_State *L) {
	if (lua_isnoneornil(L,1)) {
		return 0;
	}

	size_t len;
	char * msg ;
	size_t sz ;
	if(lua_isuserdata(L, 1)){
		msg = (char *)lua_touserdata(L, 1);
		len = sz = luaL_checkinteger(L,2);
	}else{
		msg = (char *)luaL_checklstring(L,1,&len);
		sz = luaL_checkinteger(L,2);
	}

	

	size_t pid = msg[0] << 8 | msg[1];

	// printf("un pid:%zu  msg size:%zu  bytelen:%lu \n", pid,sz,len);

	assert(len==sz);

	
	lua_pushnumber(L,pid);
	lua_pushlstring(L,msg+2,len-2);
	lua_pushnumber(L,len-2);
	return 3;
}


static int
_protoUnpackLen(lua_State *L) {
	if (lua_isnoneornil(L,1)) {
		return 0;
	}
	size_t len;
	char * msg= (char *)luaL_checklstring(L,1,&len);

	const uint8_t *header = (uint8_t *)msg;
	size_t size = header[0] << 8 | header[1];
	lua_pushinteger(L,size);
	return 1;
}


static int
_protopack(lua_State *L) {
	if (lua_isnoneornil(L,1)) {
		return 0;
	}
	int pid = luaL_checkinteger(L,1);
	size_t len;
	char * msg= (char *)luaL_checklstring(L,2,&len);
	

	uint8_t *tmp = malloc(len + 2);
	tmp[0] = (pid >> 8) & 0xff;
	tmp[1] = pid & 0xff;
	memcpy(tmp+2, msg, len);

	lua_pushlstring(L,(char *)tmp,len+2);
	free(tmp);
	return 1;
}


static int
_pack(lua_State *L) {
	if (lua_isnoneornil(L,1)) {
		return 0;
	}
	size_t pid = luaL_checkinteger(L,1);
	size_t len;
	char * msg= (char *)luaL_checklstring(L,2,&len);

	size_t newsize = len+2;

	uint8_t *tmp = malloc(newsize+2);

	tmp[0] = (newsize >> 8) & 0xff;
	tmp[1] = newsize & 0xff;
	tmp[2] = (pid >> 8) & 0xff;
	tmp[3] = pid & 0xff;
	memcpy(tmp+4, msg, len);
	// printf("pack Id:%zu  body:%lu\n", pid,newsize);
	lua_pushlstring(L,(char *)tmp,newsize+2);
	free(tmp);
	return 1;
}





LUALIB_API int luaopen_protopack (lua_State *L)
{
  luaL_Reg l[] =
  {
      {"pbcpack",    _protopack},
      {"pack",    _pack},
      {"pbcunpack",  _protoUnpack},
      {"unpacklen",  _protoUnpackLen},
      {NULL,  NULL}
  };
  
  luaL_newlib(L,l);
 return 1;
}
