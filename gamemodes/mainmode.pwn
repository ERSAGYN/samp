#include <a_samp>
#include <streamer>
#include <sscanf>
#include <a_actor>
#include <a_mysql>
#include <mxdate>
#include <dc_cmd>
#include <objects>
#include <actors>
#include <a_mail> //Возможно удалить
#include <textdraws>//В конец чтобы define'ы работали возможно в самый низ

#define MYSQL_HOST "localhost"
#define MYSQL_USER "root"
#define MYSQL_PASSWORD ""
#define MYSQL_BASE "asterismroleplay"

#define SCM SendClientMessage
#define SPD ShowPlayerDialog

#define DSM DIALOG_STYLE_MSGBOX
#define DSI DIALOG_STYLE_INPUT
#define DSL DIALOG_STYLE_LIST
#define DSP DIALOG_STYLE_PASSWORD
#define DST DIALOG_STYLE_TABLIST
#define DSTH DIALOG_STYLE_TABLIST_HEADERS
//---------------------------------DIALOG ID's---------------------------------------------
#define dialogid_register 0
#define dialogid_login 1
#define dialogid_email 2
#define dialogid_inviter 3
#define dialogid_gender 4
#define dialogid_invalidpass 101
#define dialogid_wrongpass 100
#define dialogid_invalidmail 102

//---------------------------------VIRTUAL WORLD ID's---------------------------------------------
#define vw_regskin 1


enum pInfo
{
	pID,
	pName[MAX_PLAYER_NAME],
	pPassword[17],
	pMail[38],
	pInviter[MAX_PLAYER_NAME],
	pGender,
	pSkin,
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
new RegSkins[5];

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
	AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0,0,0,0,0,0,0); // Без этого не работает setplayerpos
	//AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	ObjectLoad(); //Загрузка объектов/маппинга
	ActorLoad(); // Загрузка NPC
	//SendMail("gamewhisersa@gmail.com", "ersagyn0@gmail.com", "ERSA", "Здрастье мордасте", "ЗАДРАСТЬЕ МОРАДАСТЬЕ");
	return 1;
}

public OnGameModeExit()
{
	mysql_close(dbConnection); // Закрытие соединения с базой данных
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	spawn_player(playerid);
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
	if(!playerinfo[playerid][pLoggedIn]) return 0;//В разработке подумоть нужно ИЗМЕНИТЬ
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
	new clear_inputtext[128];
	mysql_escape_string(inputtext, clear_inputtext, sizeof(clear_inputtext));
	switch(dialogid)
	{
		case dialogid_register:
		{
		    if(!response) return KickEx(playerid);
		    if(strlen(clear_inputtext) < 6 || strlen(clear_inputtext) > 16) return SPD(playerid,dialogid_invalidpass,DSM,"Ошибка","Длина пароля должна быть от 6-ти до 16-ти символов","Повтор","Отмена");
			for(new i = 0; i != strlen(clear_inputtext); i++)// Проверка на символы в пароле
         	{
                switch(clear_inputtext[i])
                {
                	case '0'..'9', 'a'..'z', 'A'..'Z': continue;
                 	default: return SPD(playerid,dialogid_invalidpass,DSM,"Ошибка","Пароль должен состоять только из латинских символов и/или цифр","Повтор","Отмена");
                }
         	}
			strmid(playerinfo[playerid][pPassword], clear_inputtext, 0, strlen(clear_inputtext), 17); // Присваивание в playerinfo password, может быть ошибка
         	printf("Password is %s", playerinfo[playerid][pPassword]); // ИЗМЕНИТЬ УДАЛИТЬ
         	SPD(playerid, dialogid_email, DSI, "E-mail", "Что-то про e-mail", "Далее", "Отмена");
		}
		case dialogid_login:
		{
		
		}
		case dialogid_email:
		{
			if(!response) return KickEx(playerid);
			if(!strlen(clear_inputtext)) return SPD(playerid, dialogid_invalidmail, DSM, "Ошибка", "Вы не ввели e-mail", "Повтор", "Отмена");
			new query[90];
			new mail_symbols_check = 0;
			for(new i = 0; i != strlen(clear_inputtext); i++)// Проверка на символы почты
         	{
                switch(clear_inputtext[i])
                {
                	case '0'..'9', 'a'..'z', 'A'..'Z', '-', '_': continue;
                	case '@': mail_symbols_check++;
                	case '.': mail_symbols_check++;
                 	default: return SPD(playerid,dialogid_invalidmail,DSM,"Ошибка","Вы ввели неверный адрес электронной почты!","Повтор","Отмена");
                }
         	}
         	if(mail_symbols_check < 2) return SPD(playerid,dialogid_invalidmail,DSM,"Ошибка","Вы ввели неверный адрес электронной почты!","Повтор","Отмена");
			mysql_format(dbConnection, query, sizeof(query), "SELECT * FROM `accounts` WHERE `email` = '%s' LIMIT 1", clear_inputtext);
         	mysql_tquery(dbConnection, query, "check_existence_mail", "ds", playerid, clear_inputtext);
		}
		case dialogid_inviter:
		{
			if(!response || !strlen(clear_inputtext)) return SPD(playerid, dialogid_gender, DSM, "Пол", "Что-то про пол", "Мужской", "Женский"); //хахой нибудь дальше;
			strmid(playerinfo[playerid][pInviter], clear_inputtext, 0, strlen(clear_inputtext), MAX_PLAYER_NAME);
			SPD(playerid, dialogid_gender, DSM, "Пол", "Что-то про пол", "Мужской", "Женский");
		}
		case dialogid_gender:
		{
			if(response)
			{
			    playerinfo[playerid][pGender] = 1;
			    RegSkins = {78,79,137,212,230};
			}
			else
			{
				playerinfo[playerid][pGender] = 2;
				RegSkins = {77,196,218,197,10};
			}
			TD_SelectSkin(playerid); // ИЗМЕНИТЬ УДАЛИТЬ
			select_skin(playerid);
		}
		case dialogid_invalidpass:
		{
			if(response) SPD(playerid, dialogid_register, DSI, "Регистрация", "Что-то регистрация", "Далее", "Отмена");
			else KickEx(playerid);
		}
		case dialogid_invalidmail:
		{
			if(response) SPD(playerid, dialogid_email, DSI, "E-mail", "Что-то про e-mail", "Далее", "Отмена");
			else KickEx(playerid);
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == SelectSkin0)
	{
	    SetPVarInt(playerid, "RegSkins", GetPVarInt(playerid,"RegSkins")-1);
	    if(GetPVarInt(playerid, "RegSkins") == -1) SetPVarInt(playerid, "RegSkins", 4);
	    SetPlayerSkin(playerid, RegSkins[GetPVarInt(playerid, "RegSkins")]);
	}
	if(clickedid == SelectSkin1)
	{
	    SetPVarInt(playerid, "RegSkins", GetPVarInt(playerid,"RegSkins")+1);
	    if(GetPVarInt(playerid, "RegSkins") == 5) SetPVarInt(playerid, "RegSkins", 0);
	    SetPlayerSkin(playerid, RegSkins[GetPVarInt(playerid, "RegSkins")]);
	}
	if(clickedid == SelectSkin2)
	{
		playerinfo[playerid][pSkin] = RegSkins[GetPVarInt(playerid, "RegSkins")];
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid, 1);
		SetCameraBehindPlayer(playerid);
		CancelSelectTextDraw(playerid);
		TextDrawHideForPlayer(playerid, SelectSkin0);
		TextDrawHideForPlayer(playerid, SelectSkin1);
		TextDrawHideForPlayer(playerid, SelectSkin2);
	}
	return 0;
}
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	return 0;
}
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    SetPlayerPosFindZ(playerid, fX, fY, fZ);
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
			SPD(playerid, dialogid_register, DSI, "Регистрация", "Что-то регистрация", "Далее", "Отмена");
		}
		case 1:
		{
		    cache_get_value_name(2, "password", playerinfo[playerid][pPassword]);
		    SPD(playerid, dialogid_login, DSP, "Авторизация", "Что то авторизация", "Далее", "Отмена");
		}
	}
}
forward check_existence_mail(playerid, clear_inputtext[]);
public check_existence_mail(playerid, clear_inputtext[])
{
	switch(cache_num_rows())
	{
		case 0:
		{
			strmid(playerinfo[playerid][pMail], clear_inputtext, 0, strlen(clear_inputtext), 38);
			SPD(playerid, dialogid_inviter, DSI, "Приглашение", "Что-то про приглос", "Далее", "Пропустить");
		}
		case 1:
		{
		    SPD(playerid,dialogid_invalidmail,DSM,"Ошибка","Введенный вами адрес электронной почты уже зарегистрирован","Повтор","Отмена");
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
stock spawn_player(playerid)
{
	if(playerinfo[playerid][pLoggedIn])
	{
		//SetSpawnInfo(playerid, 255, 0, 10, 10, 10, 0, 30, 999, 0, 0, 0, 0); // Изменить на место проживания или проверки на фракцию сделать
		TogglePlayerSpectating(playerid, 0);
		SpawnPlayer(playerid);
	}
}
stock GetPlayerCameraLookAt(playerid, &Float:X, &Float:Y, &Float:Z)
{
	new Float:CamX, Float:CamY, Float:CamZ, Float:FrX, Float:FrY, Float:FrZ;
	GetPlayerCameraPos(playerid, CamX, CamY, CamZ);
	GetPlayerCameraFrontVector(playerid, FrX, FrY, FrZ);
	X = FrX + CamX;
	Y = FrY + CamY;
	Z = FrZ + CamZ;
}
stock select_skin(playerid)
{
    SetPlayerVirtualWorld(playerid, vw_regskin);
	SetSpawnInfo(playerid, 255, 0, 1628.5,-2325.13,13.5469,270.0, 0, 0, 0, 0, 0, 0);
   	TogglePlayerSpectating(playerid, 0);
	SetPlayerPos(playerid, 1628.5,-2325.13,13.5469);
	SetPlayerCameraPos(playerid, 1633.0, -2325.3, 14.5);
	SetPlayerCameraLookAt(playerid, 1632.0, -2325.25, 14.4);
	SetPlayerSkin(playerid, RegSkins[0]);
	SetPVarInt(playerid, "RegSkins", 0);
	TogglePlayerControllable(playerid, 0);
}
//====================================[ COMMANDS ]==========================================
CMD:tempspawn(playerid)//УДАЛИТЬ ИЗМЕНИТЬ
{
	playerinfo[playerid][pLoggedIn] = true;
	spawn_player(playerid);
}
CMD:tempcameralookat(playerid) // УДАЛИТЬ ИЗМЕНИТЬ
{
	new Float: fVX, Float: fVY, Float: fVZ, string[64];
	GetPlayerCameraLookAt(playerid, fVX, fVY, fVZ);
	format(string, sizeof(string), "Ваша камера смотрит в: %f , %f , %f",fVX, fVY, fVZ);
	SCM(playerid, -1, string);
	GetPlayerCameraPos(playerid, fVX, fVY, fVZ);
	format(string, sizeof(string), "Ваша камера стоит на: %f , %f , %f",fVX, fVY, fVZ);
	SCM(playerid, -1, string);
}
CMD:temppos(playerid) // УДАЛИТЬ ИЗМЕНИТЬ
{
	new Float: fVX, Float: fVY, Float: fVZ, string[64];
	GetPlayerPos(playerid, fVX, fVY, fVZ);
	format(string, sizeof(string), "Ты стоишь на: %f , %f , %f",fVX, fVY, fVZ);
	SCM(playerid, -1, string);
}
CMD:tempsetpos(playerid, params[]) // УДАЛИТЬ ИЗМЕНИТЬ
{
	new Float: x, Float: y, Float: z, string[64];
	if(sscanf(params,"fff",x,y,z)) return SCM(playerid,0xFFFFFFAA,"Используйте /makeadmin [ID игрока] [LVL админки]");
	SetPlayerPos(playerid, x,y,z);
	format(string, sizeof(string), "Ты телепорирован на: %f , %f , %f",x,y,z);
	SCM(playerid, -1, string);
	return 1;
}

