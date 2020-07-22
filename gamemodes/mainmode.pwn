#include <a_samp>
#include <streamer>
#include <sscanf>
#include <a_actor>
#include <a_mysql>
#include <mxdate>
#include <dc_cmd>
#include <objects>
#include <actors>

#define MYSQL_HOST "localhost"
#define MYSQL_USER "root"
#define MYSQL_PASSWORD ""
#define MYSQL_BASE "asterismroleplay"

#define SCM SendClientMessage
#define SPD ShowPlayerDialog
//---------------------------------DIALOG ID's---------------------------------------------
#define dialogid_register 0
#define dialogid_login 1

enum pInfo
{
	pID,
	pName[MAX_PLAYER_NAME],
	pPassword[17],
	pMail[32],
	pRegDate[10],
	pRegTime[8],
	pRegIp[16],
	pLastDate[10],
	pLastTime[8],
	pLastIp[16],
	bool:pLoggedIn,
}
new playerinfo[MAX_PLAYERS][pInfo];
new MySQL:dbConnection;

main()
{
	print("\n----------------------------------");
	print(" Asterism Role Play ");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	mysql_connects(); // Соединение с базой данных в стоке
	SetGameModeText("Asterism Role Play");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	ObjectLoad(); //Загрузка объектов/маппинга
	ActorLoad(); // Загрузка NPC
	return 1;
}

public OnGameModeExit()
{
	mysql_close(dbConnection); // Закрытие соединения с базой данных
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
    SetTimerEx("player_connect", 350, false, "d", playerid); //При подключении аккаунта и проверка.Таймер чтобы игрок не зависал
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
//====================================[ FORWARDS AND PUBLICS ]==========================================
forward player_connect(playerid); // При подключении аккаунта
public player_connect(playerid){
	new query[68];
	TogglePlayerSpectating(playerid, 1);
	GetPlayerName(playerid, playerinfo[playerid][pName], MAX_PLAYER_NAME);
	//GetPlayerIp(playerid, playerinfo[playerid][pLastIp], 16);
	mysql_format(dbConnection, query, sizeof(query), "SELECT * FROM `accounts` WHERE `name` = '%s' LIMIT 1",playerinfo[playerid][pName]);
	mysql_tquery(dbConnection, query, "check_existence", "d", playerid);
	return 1;
}
forward check_existence(playerid);
public check_existence(playerid) // Проверка на существование аккаунта
{
	switch(cache_num_rows())
	{
		case 0:
		{
			SPD(playerid, dialogid_register, DIALOG_STYLE_INPUT, "Регистрация", "Что-то регистрация", "Далее", "Отмена");
		}
		case 1:
		{
		    cache_get_value_name(2, "password", playerinfo[playerid][pPassword]);
		    SPD(playerid, dialogid_login, DIALOG_STYLE_PASSWORD, "Авторизация", "Что то авторизация", "Далее", "Отмена");
		}
	}
}
//------------------------------------------KICK----------------------------------------------
forward player_kick(playerid);
public player_kick(playerid) return Kick(playerid);
stock KickEx(playerid) return SetTimerEx("player_kick", 40, false, "d", playerid); //Чтобы перед киком был виден SCM
//--------------------------------------------------------------------------------------------
//====================================[ STOCKS ]==========================================
stock mysql_connects()
{
	dbConnection = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_BASE);
 	switch(mysql_errno())
 	{
 	    case 0: print("Подключение к базе данных MYSQL успешно");
 	    default: print("Подключение к базе данных MYSQL НЕ успешно или произошла другая ошибка");
 	}
}
//====================================[ COMMANDS ]==========================================
