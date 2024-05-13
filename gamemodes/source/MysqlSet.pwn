stock set_item_int ( itemid, rows[], value )
{
    if ( inventory_items [ itemid ] [ itemID ] <= 0 )
        return 1;

    new query [ 144 ];
    format ( query, sizeof query, "UPDATE items SET %s=%i WHERE id=%i", rows, value, inventory_items [ itemid ] [ itemID ] );
    mysql_tquery ( dbHandle, query );
    return 1;
}

stock set_item_string ( itemid, rows[], value[] )
{
    if ( inventory_items [ itemid ] [ itemID ] <= 0 )
        return 1;
    
    new query [ 144 ];
    format ( query, sizeof query, "UPDATE items SET `%s`='%s' WHERE id=%i", rows, value, inventory_items [ itemid ] [ itemID ] );
    mysql_tquery ( dbHandle, query );
    return 1;
}

stock set_item_float ( itemid, rows[], Float:value )
{
    if ( inventory_items [ itemid ] [ itemID ] <= 0 )
        return 1;
    
    new query [ 144 ];
    format ( query, sizeof query, "UPDATE items SET `%s`='%f' WHERE id=%i", rows, value, inventory_items [ itemid ] [ itemID ] );
    mysql_tquery ( dbHandle, query );
    return 1;
}

stock set_player_int ( playerid, rows[], value )
{
    new query [ 144 ];
    format ( query, sizeof query, "UPDATE player SET %s=%i WHERE id=%i", rows, value, PlayerInfo [ playerid ] [ pID ] );
    mysql_tquery ( dbHandle, query );
    return 1;
}

stock SavePlayerAttachedSlot ( playerid, index )
{
    new query [ 255 ];
    format ( query, sizeof query, "UPDATE attached SET attachSlot=%i,attachBoneid=%i,attachModel=%i,`attachX`='%f',`attachY`='%f',`attachZ`='%f',`attachRX`='%f',`attachRY`='%f',`attachRZ`='%f' WHERE id=%i",
        AttachedPlayer [ playerid ] [ index ] [ attachSlot ],
        AttachedPlayer [ playerid ] [ index ] [ attachBoneid ],
        AttachedPlayer [ playerid ] [ index ] [ attachModel ],
        AttachedPlayer [ playerid ] [ index ] [ attachX ],
        AttachedPlayer [ playerid ] [ index ] [ attachY ],
        AttachedPlayer [ playerid ] [ index ] [ attachZ ],
        AttachedPlayer [ playerid ] [ index ] [ attachRX ],
        AttachedPlayer [ playerid ] [ index ] [ attachRY ],
        AttachedPlayer [ playerid ] [ index ] [ attachRZ ],
        AttachedPlayer [ playerid ] [ index ] [ attachID ]
    );
    mysql_tquery ( dbHandle, query );
    return 1;
}

stock SavePlayerSlotInventory ( playerid, slot )
{
    new query [ 144 ];
    format ( query, sizeof query, "UPDATE player SET i%i=%i, a%i=%i, use%i=%i WHERE id=%i",
        slot, PlayerInfo [ playerid ] [ pInv ] [ slot ],
        slot, PlayerInfo [ playerid ] [ pInvAmount ] [ slot ],
        slot, (PlayerInfo [ playerid ] [ pInvSlotUsed ] [ slot ] == true)?1:0,
        PlayerInfo [ playerid ] [ pID ]
    );
    mysql_tquery ( dbHandle, query );
    return 1;
}