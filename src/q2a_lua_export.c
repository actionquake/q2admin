//
// q2admin
//
// q2a_lua_export.c
//
// copyright 2009 Toni Spets
//

#include "g_local.h"
#include "q2a_lua.h"

int q2a_lua_gi_dprintf(lua_State *L)
{
	// FIXME: do things like real printf(fmt, ...)
	char *str;
	str = (char *)lua_tostring(L, 1);

	q2a_fpu_q2();

	gi.dprintf("%s", str);

	q2a_fpu_lua();

	return 0;
}

int q2a_lua_gi_bprintf(lua_State *L)
{
	// FIXME: do things like real printf(fmt, ...)
	int lvl;
	char *str;
	lvl = lua_tointeger(L, 1);
	str = (char *)lua_tostring(L, 2);

	q2a_fpu_q2();

	gi.bprintf(lvl, str);

	q2a_fpu_lua();

	return 0;
}

int q2a_lua_gi_cprintf(lua_State *L)
{
	// FIXME: do things like real printf(fmt, ...)
	edict_t *ent;
	int client;
	int lvl;
	char *str;

	client = lua_tointeger(L, 1);
	lvl = lua_tointeger(L, 2);
	str = (char *)lua_tostring(L, 3);

	ent = getEnt(client);

	q2a_fpu_q2();

	gi.cprintf(ent, lvl, str);

	q2a_fpu_lua();

	return 0;
}

int q2a_lua_gi_centerprintf(lua_State *L)
{
	// FIXME: do things like real printf(fmt, ...)
	edict_t *ent;
	int client;
	char *str;

	client = lua_tointeger(L, 1);
	str = (char *)lua_tostring(L, 2);

	ent = getEnt(client);

	q2a_fpu_q2();

	gi.centerprintf(ent, str);

	q2a_fpu_lua();

	return 0;
}

int q2a_lua_gi_argc(lua_State *L)
{
	int argc;

	q2a_fpu_q2();
	argc = gi.argc();
	q2a_fpu_lua();

	lua_pushinteger(L, gi.argc());

	return 1;
}

int q2a_lua_gi_argv(lua_State *L)
{
	int num;
	char *str;

	num = lua_tointeger(L, 1);

	q2a_fpu_q2();
	str = gi.argv(num);
	q2a_fpu_lua();

	lua_pushstring(L, str);

	return 1;
}

int q2a_lua_gi_AddCommandString(lua_State *L)
{
	char *str;

	str = (char *)lua_tostring(L, 1);

	q2a_fpu_q2();
	gi.AddCommandString(str);
	q2a_fpu_lua();

	return 0;
}

int q2a_lua_stuffcmd(lua_State *L)
{
	edict_t *ent;
	int client;
	char *str;

	client = lua_tointeger(L, 1);
	str = (char *)lua_tostring(L, 2);

	ent = getEnt(client);

	q2a_fpu_q2();

	stuffcmd(ent, str);

	q2a_fpu_lua();

	return 0;
}

int q2a_lua_cvar(lua_State *L)
{
	cvar_t *tmp;

	char *str;

	str = (char *)lua_tostring(L, 1);

	q2a_fpu_q2();

	tmp = gi.cvar(str, NULL, 0);

	q2a_fpu_lua();

	if(tmp) lua_pushstring(L, tmp->string);

	return 1;
}

int q2a_lua_cvar_set(lua_State *L)
{
	cvar_t *tmp;

	char *key, *value;
	int mask;

	key = (char *)lua_tostring(L, 1);
	value = (char *)lua_tostring(L, 2);
	mask = (int)lua_tointeger(L, 3);

	q2a_fpu_q2();

	tmp = gi.cvar(key, value, mask);

	q2a_fpu_lua();

	if(tmp)
		lua_pushboolean(L, !q2a_strcmp(tmp->string, value));

	return 1;
}
