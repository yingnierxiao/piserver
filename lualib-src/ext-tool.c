#include <lua.h>
#include <lauxlib.h>
#include <sys/types.h>
#include <unistd.h>


static int
_getpid(lua_State *L) {
	int pid = 0;
	pid = getpid();
	lua_pushinteger(L,pid);
	return 1;
}

LUALIB_API int luaopen_tool_core (lua_State *L)
{
  luaL_Reg l[] =
  {
      {"getpid",    _getpid},
      {NULL,  NULL}
  };
  
  luaL_newlib(L,l);
 return 1;
}
