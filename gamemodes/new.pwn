#include <a_samp>
#include <a_mysql>
#include <easyDialog>
#include <Pawn.CMD>
#include <sscanf2>

#define params_dialog playerid, response, listitem, inputtext[]

#define SEM(%0,%1) \
	SendClientMessageEx(%0, 0xFF6347AA, "» "%1)

#define 	MAX_INVENTORY	9
#define		MAX_ITEMS		10

enum ENUM_PLAYER_E
{
	pID,
	pUsername [ MAX_PLAYER_NAME + 1 ],

	pInv [ MAX_INVENTORY ],
	pInvAmount [ MAX_INVENTORY ],
	bool:pInvSlotUsed [ MAX_INVENTORY ],
}
new PlayerInfo [ MAX_PLAYERS ] [ ENUM_PLAYER_E ];

enum ENUM_PLAYER_TEMP
{
	tZaglushka,
	tSelect,
}
new pTemp [ MAX_PLAYERS ] [ ENUM_PLAYER_TEMP ];

new MySQL:dbHandle;

enum ITEM_ENUM
{
	itemID,
	itemName [ 32 ],
	itemModel,
	itemBone,
	itemIndex,

	Float:itemX,
	Float:itemY,
	Float:itemZ,

	Float:itemRotX,
	Float:itemRotY,
	Float:itemRotZ,
};
new inventory_items [ MAX_ITEMS ] [ ITEM_ENUM ];

enum ENUM_PLAYER_ATTACH
{
	attachID,
	bool:attachUsed,
	attachSlot,

	Float:attachX,
	Float:attachY,
	Float:attachZ,
	
	Float:attachRX,
	Float:attachRY,
	Float:attachRZ,

	attachBoneid,
	attachModel,
}
new AttachedPlayer [ MAX_PLAYERS ] [ 10 ] [ ENUM_PLAYER_ATTACH ];

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}


public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	SetGameModeText("Blank Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	
	dbHandle = mysql_connect("localhost", "root", "", "test");
	mysql_log ( ALL );

	if ( mysql_errno() != 0 ) printf ( "[MYSQL] Подключение к БД не удалось." );
	else
	{
		printf ( "[MYSQL] Подключение к БД удалось." );

        mysql_set_charset ( "cp1251" );
	    mysql_query ( dbHandle, "SET NAMES cp1251;", false );
		mysql_query ( dbHandle, "SET SESSION character_set_server='utf8';", false );

	    new name [ 32 ];
		mysql_get_charset ( name,32, dbHandle );
		printf ( "[MYSQL] Кодировка: %s", name );
	}

	mysql_tquery ( dbHandle, "SELECT * FROM `items`", "LoadDynamicItems" );
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	GetPlayerName ( playerid, PlayerInfo [ playerid ] [ pUsername ], MAX_PLAYER_NAME + 1 );

	new query [ 144 ];
	mysql_format ( dbHandle, query, sizeof query, "SELECT * FROM player WHERE `username`='%s'", PlayerInfo [ playerid ] [ pUsername ] );
	new Cache:mysql_result = mysql_query ( dbHandle, query );

	if ( !cache_num_rows () )
	{
		cache_delete ( mysql_result );

		format ( query, sizeof query, "INSERT INTO player (`username`) VALUES  ('%s')", PlayerInfo [ playerid ] [ pUsername ] );
		mysql_result = mysql_query ( dbHandle, query );

		PlayerInfo [ playerid ] [ pID ] = cache_insert_id();
	}
	else
	{
		cache_get_value_name_int ( 0, "id", PlayerInfo [ playerid ] [ pID ] );

		new _str [ 10 ],
			lcl;
		
		for ( new i = 0; i < MAX_INVENTORY; i ++ )
		{
			format ( _str, sizeof _str, "i%i", i );
			cache_get_value_name_int ( 0, _str, PlayerInfo [ playerid ] [ pInv ] [ i ] );

			format ( _str, sizeof _str, "a%i", i );
			cache_get_value_name_int ( 0, _str, PlayerInfo [ playerid ] [ pInvAmount ] [ i ] );

			format ( _str, sizeof _str, "i%i", i );
			cache_get_value_name_int ( 0, _str, lcl );

			PlayerInfo [ playerid ] [ pInvSlotUsed ] [ i ] = (lcl==0) ? false:true;
		}

		format ( query, sizeof query, "SELECT * FROM attached WHERE userid=%i", PlayerInfo [ playerid ] [ pID ] );
		mysql_tquery ( dbHandle, query, "OnPlayerLodAttached", "i", playerid );
	}

	cache_delete ( mysql_result );
	return 1;
}

forward OnPlayerLodAttached ( playerid );
public OnPlayerLodAttached ( playerid )
{
	if ( !cache_num_rows() )
		return 1;

	new index;
	for ( new i = 0; i < cache_num_rows(); i ++ )
	{
		cache_get_value_name_int ( i, "index", index ); 

		cache_get_value_name_int ( i, "id", AttachedPlayer [ playerid ] [ index ] [ attachID ] );
		cache_get_value_name_int ( i, "attachSlot", AttachedPlayer [ playerid ] [ index ] [ attachSlot ] );
		cache_get_value_name_int ( i, "attachBoneid", AttachedPlayer [ playerid ] [ index ] [ attachBoneid ] );
		cache_get_value_name_int ( i, "attachModel", AttachedPlayer [ playerid ] [ index ] [ attachModel ] );

		cache_get_value_name_float ( i, "attachX", AttachedPlayer [ playerid ] [ index ] [ attachX ] );
		cache_get_value_name_float ( i, "attachY", AttachedPlayer [ playerid ] [ index ] [ attachY ] );
		cache_get_value_name_float ( i, "attachZ", AttachedPlayer [ playerid ] [ index ] [ attachZ ] );
		cache_get_value_name_float ( i, "attachRX", AttachedPlayer [ playerid ] [ index ] [ attachRX ] );
		cache_get_value_name_float ( i, "attachRY", AttachedPlayer [ playerid ] [ index ] [ attachRY ] );
		cache_get_value_name_float ( i, "attachRZ", AttachedPlayer [ playerid ] [ index ] [ attachRZ ] );

		if ( IsPlayerAttachedObjectSlotUsed ( playerid, index + 1 ) )
			RemovePlayerAttachedObject ( playerid, index + 1 );
		
		SetPlayerAttachedObject ( playerid, index+1, AttachedPlayer [ playerid ] [ index ] [ attachModel ], AttachedPlayer [ playerid ] [ index ] [ attachBoneid ], AttachedPlayer [ playerid ] [ index ] [ attachX ], AttachedPlayer [ playerid ] [ index ] [ attachY ], AttachedPlayer [ playerid ] [ index ] [ attachZ ], AttachedPlayer [ playerid ] [ index ] [ attachRX ], AttachedPlayer [ playerid ] [ index ] [ attachRY ], AttachedPlayer [ playerid ] [ index ] [ attachRZ ], 1.000, 1.000, 1.000 );
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	PlayerInfo [ playerid ] [ pID ] = 0;
	PlayerInfo [ playerid ] [ pUsername ] = EOS;

	for ( new i = 0; i < MAX_INVENTORY; i ++ )
	{
		PlayerInfo [ playerid ] [ pInv ] [ i ] =
		PlayerInfo [ playerid ] [ pInvAmount ] [ i ] = 0;

		PlayerInfo [ playerid ] [ pInvSlotUsed ] [ i ] = false;
	}

	for ( new index = 0; index < MAX_PLAYER_ATTACHED_OBJECTS; index ++ )
	{
		if ( !IsPlayerAttachedObjectSlotUsed ( playerid, index ) )
			continue;
		
		RemovePlayerAttachedObject ( playerid, index );
	}
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

stock SendClientMessageEx(playerid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format

		SendClientMessage(playerid, color, string);

		#emit LCTRL 5
		#emit SCTRL 4
		#emit RETN
	}
	return SendClientMessage(playerid, color, str);
}

stock GetBone ( boneid )
{
	new return_text [ 80 ];
	switch ( boneid )
	{
		case 1: return_text = "Спина";
		case 2: return_text = "Голова";
		case 3: return_text = "Плечо левой руки";
		case 4: return_text = "Плечо правой руки";
		case 5: return_text = "Левая рука";
		case 6: return_text = "Правая рука";
		case 7: return_text = "Левое бедро";
		case 8: return_text = "Правое бедро";
		case 9: return_text = "Левая нога";
		case 10: return_text = "Правая нога";
		case 11: return_text = "Правая голень";
		case 12: return_text = "Левая голень";
		case 13: return_text = "Левое предплечье";
		case 14: return_text = "Правое предплечье";
		case 15: return_text = "Левая ключица";
		case 16: return_text = "Правая ключица";
		case 17: return_text = "Шея";
		case 18: return_text = "Челюсть";
		default: return_text = "Не установлено";
	}
	return return_text;
}

stock ResetPlayerItems ( itemid )
{
	inventory_items [ itemid ] [ itemID ] =
	inventory_items [ itemid ] [ itemModel ] =
	inventory_items [ itemid ] [ itemBone ] = 0;

	inventory_items [ itemid ] [ itemName ] = EOS;
	return 1;
}

Dialog:dCreateItem_N ( params_dialog )
{
	if ( !response )
	{
		ShowPlayerCreateItem ( playerid );
		return 1;
	}

	if ( isnull ( inputtext ) )
		return Dialog_Show ( playerid, dCreateItem_N, DIALOG_STYLE_INPUT, " ", "Введите название предмета до 32-х символов!", "Далее", "Назад" );
	
	new itemid = pTemp [ playerid ] [ tSelect ];
	format ( inventory_items [ itemid ] [ itemName ], 32, inputtext );
	set_item_string ( itemid, "itemName", inputtext );

	ShowPlayerCreateItem ( playerid );
	return 1;
}

Dialog:dCreateItem_Mod ( params_dialog )
{
	if ( !response )
	{
		ShowPlayerCreateItem ( playerid );
		return 1;
	}

	new modelid;
	if ( sscanf ( inputtext, "d", modelid ) )
		return Dialog_Show ( playerid, dCreateItem_Mod, DIALOG_STYLE_INPUT, " ", "Введите id модели", "Далее", "Назад" );

	new itemid = pTemp [ playerid ] [ tSelect ];
	inventory_items [ itemid ] [ itemModel ] = modelid;
	set_item_int ( itemid, "itemModel", listitem );

	ShowPlayerCreateItem ( playerid );
	return 1;
}

Dialog:dCreateItem_Bon ( params_dialog )
{
	if ( !response )
	{
		ShowPlayerCreateItem ( playerid );
		return 1;
	}

	new itemid = pTemp [ playerid ] [ tSelect ];
	inventory_items [ itemid ] [ itemBone ] = listitem;
	set_item_int ( itemid, "itemBone", listitem );

	ShowPlayerCreateItem ( playerid );
	return 1;
}

Dialog:dCreateItem_Ind ( params_dialog )
{
	if ( !response )
	{
		ShowPlayerCreateItem ( playerid );
		return 1;
	}

	new index;
	if ( sscanf ( inputtext, "d", index ) )
		return Dialog_Show ( playerid, dCreateItem_Ind, DIALOG_STYLE_INPUT, " ", "Введите слот, в который надевается предмет (0-9)", "Далее", "Назад" );

	if ( index < 0 || index > 9 )
		return Dialog_Show ( playerid, dCreateItem_Ind, DIALOG_STYLE_INPUT, " ", "Введите слот, в который надевается предмет (0-9)", "Далее", "Назад" );

	new itemid = pTemp [ playerid ] [ tSelect ];
	inventory_items [ itemid ] [ itemIndex ] = index;
	set_item_int ( itemid, "itemIndex", index );

	ShowPlayerCreateItem ( playerid );
	return 1;
}

Dialog:dCreateItem ( params_dialog )
{
	new itemid = pTemp [ playerid ] [ tSelect ];
	if ( !response )
	{
		if ( inventory_items [ itemid ] [ itemID ] <= 0 ) ResetPlayerItems ( itemid );
		return 1;
	}

	switch ( listitem )
	{
		case 0:
			Dialog_Show ( playerid, dCreateItem_N, DIALOG_STYLE_INPUT, " ", "Введите название предмета до 32-х символов!", "Далее", "Назад" );
		case 1:
			Dialog_Show ( playerid, dCreateItem_Mod, DIALOG_STYLE_INPUT, " ", "Введите id модели", "Далее", "Назад" );
		case 2:
		{
			new body_dialog [ 400 ] = "Выберите позицию, куда прекрепить аттач\n";
			
			for ( new i = 1; i < 19; i ++ )
				format ( body_dialog, sizeof body_dialog, "%s%i. %s\n", body_dialog, i, GetBone ( i ) );
		
			Dialog_Show ( playerid, dCreateItem_Bon, DIALOG_STYLE_LIST, " ", body_dialog, "Далее", "Назад" );
		}
		case 3:
			Dialog_Show ( playerid, dCreateItem_Ind, DIALOG_STYLE_INPUT, " ", "Введите слот, в который надевается предмет (0-9)", "Далее", "Назад" );
		case 4:
		{
			if ( inventory_items [ itemid ] [ itemModel ] < 0 )
			{
				ShowPlayerCreateItem ( playerid );
				return SEM ( playerid, "Вы указали некорректный ид модели." );
			}

			if ( inventory_items [ itemid ] [ itemBone ] == 0 )
			{
				ShowPlayerCreateItem ( playerid );
				return SEM ( playerid, "Выберите кость, для изначальной позиции." );
			}
			
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) )
				RemovePlayerAttachedObject ( playerid, 0 );
			
			SetPlayerAttachedObject ( playerid, 0, inventory_items [ itemid ] [ itemModel ], inventory_items [ itemid ] [ itemBone ], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.000, 1.000, 1.000 );
			EditAttachedObject ( playerid, 0 );
		}
		case 5:
		{
			if ( inventory_items [ itemid ] [ itemID ] <= 0 )
			{
				if ( inventory_items [ itemid ] [ itemModel ] < 0 )
				{
					ShowPlayerCreateItem ( playerid );
					return SEM ( playerid, "Вы указали некорректный ид модели." );
				}

				if ( inventory_items [ itemid ] [ itemBone ] == 0 )
				{
					ShowPlayerCreateItem ( playerid );
					return SEM ( playerid, "Выберите кость, для изначальной позиции." );
				}

				new query [ 256 ];
				format ( query, sizeof query, "INSERT INTO items (`itemName`,itemModel,itemBone,`itemX`,`itemY`,`itemZ`,`itemRotX`,`itemRotY`,`itemRotZ`) VALUES ('%s',%i,%i,'%f','%f','%f','%f','%f','%f')",
					inventory_items [ itemid ] [ itemName ],
					inventory_items [ itemid ] [ itemModel ],
					inventory_items [ itemid ] [ itemBone ],
					inventory_items [ itemid ] [ itemX ],
					inventory_items [ itemid ] [ itemY ],
					inventory_items [ itemid ] [ itemZ ],
					inventory_items [ itemid ] [ itemRotX ],
					inventory_items [ itemid ] [ itemRotY ],
					inventory_items [ itemid ] [ itemRotZ ]
				);
				new Cache:mysql_result = mysql_query ( dbHandle, query );

				inventory_items [ itemid ] [ itemID ] = cache_insert_id();
				cache_delete ( mysql_result );

				SendClientMessageEx ( playerid, -1, "Предмет успешно создан" );
				return 1;
			}

			new query [ 144 ];
			format ( query, sizeof query, "DELETE FROM items WHERE id = %i", inventory_items [ itemid ] [ itemID ] );
			mysql_tquery ( dbHandle, query );
			
			ResetPlayerItems ( itemid );
			SendClientMessageEx ( playerid, -1, "Предмет #%i удален", itemid );
			return 1;
		}
	}

	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if ( index == 0 )
	{
		new itemid = pTemp [ playerid ] [ tSelect ];

		if ( IsPlayerAttachedObjectSlotUsed ( playerid, 0 ) )
			RemovePlayerAttachedObject ( playerid, 0 );

		if ( response )
		{
			inventory_items [ itemid ] [ itemX ] = fOffsetX;
			inventory_items [ itemid ] [ itemY ] = fOffsetY;
			inventory_items [ itemid ] [ itemZ ] = fOffsetZ;
			
			inventory_items [ itemid ] [ itemRotX ] = fRotX;
			inventory_items [ itemid ] [ itemRotY ] = fRotY;
			inventory_items [ itemid ] [ itemRotZ ] = fRotZ;
			
			if ( inventory_items [ itemid ] [ itemID ] > 0 )
			{
				new query [ 255 ];
				format ( query, sizeof query, "UPDATE items SET `itemX`='%f',`itemY`='%f',`itemZ`='%f',`itemRotX`='%f',`itemRotY`='%f',`itemRotZ`='%f' WHERE id=%i",
					fOffsetX,
					fOffsetY,
					fOffsetZ,
					fRotX,
					fRotY,
					fRotZ,
					inventory_items [ itemid ] [ itemID ]
				);
				mysql_tquery ( dbHandle, query );
			}
		}
			
		ShowPlayerCreateItem ( playerid );
		return 1;
	}

	return 1;
}


stock ShowPlayerCreateItem ( playerid )
{
	new itemid = pTemp [ playerid ] [ tSelect ];

	Dialog_Show ( playerid, dCreateItem, DIALOG_STYLE_LIST, " ", "\
		- Название предмета: %s\n\
		- Модель предмета: %i\n\
		- Кость предмета: %s\n\
		- Слот для экипировки: %i\n\
		- Редактировать начальную позицию\n\
		%s", "Далее", "Закрыть", inventory_items [ itemid ] [ itemName ], inventory_items [ itemid ] [ itemModel ], GetBone ( inventory_items [ itemid ] [ itemBone ] ), inventory_items [ itemid ] [ itemIndex ], (inventory_items [ itemid ] [ itemID ] > 0)?("Удалить предмет"):("Создать предмет") );
	return 1;
}

CMD:create_item ( playerid )
{
	for ( new i = 1; i < MAX_ITEMS; i ++ )
	{
		if ( inventory_items [ i ] [ itemID ] != 0 )
			continue;
		
		inventory_items [ i ] [ itemID ] = -1;

		pTemp [ playerid ] [ tSelect ] = i;
		ShowPlayerCreateItem ( playerid );
		return 1;
	}

	SEM ( playerid, "Закончились слоты под айтемы." );
	return 1;
}

Dialog:dItemsList ( params_dialog )
{
	if ( !response )
		return 1;

	pTemp [ playerid ] [ tSelect ] = listitem + 1;

	if ( inventory_items [ listitem + 1 ] [ itemID ] == 0 )
		inventory_items [ listitem + 1 ] [ itemID ] = -1; 

	ShowPlayerCreateItem ( playerid );
	return 1;
}

CMD:items ( playerid )
{
	new body_dialog [ sizeof ( inventory_items ) * 30 ];
	
	for ( new i = 1; i < sizeof inventory_items; i ++ )
		format ( body_dialog, sizeof body_dialog, "%s\n%i - %s", body_dialog, i, inventory_items [ i ] [ itemName ] );

	Dialog_Show ( playerid, dItemsList, DIALOG_STYLE_LIST, " ", body_dialog, "Далее", "Закрыть" );
	return 1;
}

Dialog:dItemInfo ( params_dialog )
{
	if ( !response )
		return 1;
	
	new slot = pTemp [ playerid ] [ tSelect ];
	switch ( listitem )
	{
		case 0:
		{
			if ( PlayerInfo [ playerid ] [ pInvSlotUsed ] [ slot ] == true )
				return SEM ( playerid, "Данный аксессуар уже используется!" );

			new itemid = PlayerInfo [ playerid ] [ pInv ] [ slot ],
				index = inventory_items [ itemid ] [ itemIndex ];

			if ( AttachedPlayer [ playerid ] [ index ] [ attachUsed ] == true )
				return SEM ( playerid, "Слот, под который данный аксессуар уже используется!" );

			PlayerInfo [ playerid ] [ pInvSlotUsed ] [ slot ] =
			AttachedPlayer [ playerid ] [ index ] [ attachUsed ] = true;
			
			AttachedPlayer [ playerid ] [ index ] [ attachSlot ] = slot;

			AttachedPlayer [ playerid ] [ index ] [ attachX ] = inventory_items [ itemid ] [ itemX ];
			AttachedPlayer [ playerid ] [ index ] [ attachY ] = inventory_items [ itemid ] [ itemY ];
			AttachedPlayer [ playerid ] [ index ] [ attachZ ] = inventory_items [ itemid ] [ itemZ ];

			AttachedPlayer [ playerid ] [ index ] [ attachRX ] = inventory_items [ itemid ] [ itemRotX ];
			AttachedPlayer [ playerid ] [ index ] [ attachRZ ] = inventory_items [ itemid ] [ itemRotY ];
			AttachedPlayer [ playerid ] [ index ] [ attachRY ] = inventory_items [ itemid ] [ itemRotZ ];

			AttachedPlayer [ playerid ] [ index ] [ attachBoneid ] = inventory_items [ itemid ] [ itemBone ];
			AttachedPlayer [ playerid ] [ index ] [ attachModel ] = inventory_items [ itemid ] [ itemModel ];
			
			new _str [ 5 ];
			format ( _str, sizeof _str, "use%i", slot );

			set_player_int ( playerid, _str, (PlayerInfo [ playerid ] [ pInvSlotUsed ] [ slot ] == true)?1:0 );

			if ( AttachedPlayer [ playerid ] [ index ] [ attachID ] != 0 )
				SavePlayerAttachedSlot ( playerid, index );
			else
			{
				new query [ 255 ];
				format ( query, sizeof query, "INSERT INTO attached (userid,attachSlot,attachBoneid,attachModel,aindex,`attachX`,`attachY`,`attachZ`,`attachRX`,`attachRY`,`attachRZ`) VALUES (%i,%i,%i,%i,%i,'%f','%f','%f','%f','%f','%f')",
					PlayerInfo [ playerid ] [ pID ],
					AttachedPlayer [ playerid ] [ index ] [ attachSlot ],
					AttachedPlayer [ playerid ] [ index ] [ attachBoneid ],
					AttachedPlayer [ playerid ] [ index ] [ attachModel ],
					index,
					AttachedPlayer [ playerid ] [ index ] [ attachX ],
					AttachedPlayer [ playerid ] [ index ] [ attachY ],
					AttachedPlayer [ playerid ] [ index ] [ attachZ ],
					AttachedPlayer [ playerid ] [ index ] [ attachRX ],
					AttachedPlayer [ playerid ] [ index ] [ attachRY ],
					AttachedPlayer [ playerid ] [ index ] [ attachRZ ]
				);
				new Cache:mysql_result = mysql_query ( dbHandle, query );
				AttachedPlayer [ playerid ] [ index ] [ attachID ] = cache_insert_id();
				cache_delete ( mysql_result );
			}
				
			if ( IsPlayerAttachedObjectSlotUsed ( playerid, index+1 ) )
				RemovePlayerAttachedObject ( playerid, index+1 );

			SetPlayerAttachedObject ( playerid, index+1, inventory_items [ itemid ] [ itemModel ], inventory_items [ itemid ] [ itemBone ], inventory_items [ itemid ] [ itemX ], inventory_items [ itemid ] [ itemY ], inventory_items [ itemid ] [ itemZ ], inventory_items [ itemid ] [ itemRotX ], inventory_items [ itemid ] [ itemRotY ], inventory_items [ itemid ] [ itemRotZ ], 1.000, 1.000, 1.000 );
		}
		case 1:
		{
			if ( PlayerInfo [ playerid ] [ pInvSlotUsed ] [ slot ] == false )
				return SEM ( playerid, "Данный предмет не использован." );

			EditAttachedObject ( playerid, inventory_items [ PlayerInfo [ playerid ] [ pInv ] [ slot ] ] [ itemIndex ] + 1 );
		}
		case 2:
		{
			if ( PlayerInfo [ playerid ] [ pInvSlotUsed ] [ slot ] == true )
				return SEM ( playerid, "Данный аксессуар уже используется!" );
		
			PlayerInfo [ playerid ] [ pInv ] [ slot ] =
			PlayerInfo [ playerid ] [ pInvAmount ] [ slot ] = 0;
			SavePlayerSlotInventory ( playerid, slot );
		}
	}

	return 1;
}

Dialog:dInventory ( params_dialog )
{
	if ( !response )
		return 1;

	if ( PlayerInfo [ playerid ] [ pInv ] [ listitem ] == 0 )
		return callcmd::inventory ( playerid );

	pTemp [ playerid ] [ tSelect ] = listitem;

	Dialog_Show ( playerid, dItemInfo, DIALOG_STYLE_LIST, " ", "Нацепить\nИзменить\nУдалить", "Далее", "Закрыть" );
	return 1;
}

CMD:inventory ( playerid )
{
	new body_dialog [ MAX_INVENTORY * 32 ] = "Название\tКоличество\n";
	for ( new i = 0; i < MAX_INVENTORY; i ++ )
	{
		if ( PlayerInfo [ playerid ] [ pInv ] [ i ] != 0 )
			format ( body_dialog, sizeof body_dialog, "%s%i.%s\t%i\n", body_dialog, i+1, inventory_items [ PlayerInfo [ playerid ] [ pInv ] [ i ] ] [ itemName ], PlayerInfo [ playerid ] [ pInvAmount ] [ i ] );
		else
			format ( body_dialog, sizeof body_dialog, "%s%i. Пустой слот\t-\n", body_dialog, i+1 );
	}

	Dialog_Show ( playerid, dInventory, DIALOG_STYLE_TABLIST_HEADERS, " ", body_dialog, "Далее", "Закрыть" );
	return 1;
}

CMD:giveitem ( playerid, params[] )
{
	new itemid,
		amount;
	
	if ( sscanf ( params, "ii", itemid, amount ) )
		return SEM ( playerid, "/giveitem [itemid] [amount]" );
	
	if ( itemid >= MAX_ITEMS )
		return SEM ( playerid, "Данный предмет не может существовать" );
	
	if ( amount < 1 || amount > 10 )
		return SEM ( playerid, "Количество от 1 до 10" );

	for ( new i = 0; i < MAX_INVENTORY; i ++ )
	{
		if ( PlayerInfo [ playerid ] [ pInv ] [ i ] != itemid )
			continue;
		
		SEM ( playerid, "Вы успешно получили %s %i штук", inventory_items [ itemid ] [ itemName ], amount );
		PlayerInfo [ playerid ] [ pInvAmount ] [ i ] += amount;
		return 1;
	}

	for ( new i = 0; i < MAX_INVENTORY; i ++ )
	{
		if ( PlayerInfo [ playerid ] [ pInv ] [ i ] != 0 )
			continue;

		PlayerInfo [ playerid ] [ pInv ] [ i ] = itemid;
		PlayerInfo [ playerid ] [ pInvAmount ] [ i ] = amount;

		SEM ( playerid, "Вы успешно получили %s %i штук", inventory_items [ itemid ] [ itemName ], amount );
		SavePlayerSlotInventory ( playerid, i );
		return 1;
	}

	SEM ( playerid, "У вас нету места!" );
	return 1;
}

#include "gamemodes\source\LoadServerInfo.pwn"
#include "gamemodes\source\MysqlSet.pwn"