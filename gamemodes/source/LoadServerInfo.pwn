forward LoadDynamicItems ();
public LoadDynamicItems ()
{
	new rows = cache_num_rows(),
	    time = GetTickCount(),
		total;

	if ( !rows )
	{
	    print ( "[LoadDynamicItems] Записи не найдены." );
	    return 1;
	}

	for ( new i = 0; i < rows; i ++ )
	{
        cache_get_value_name_int ( i, "id", inventory_items [ i + 1 ] [ itemID ] );
        cache_get_value_name_int ( i, "itemModel", inventory_items [ i + 1 ] [ itemModel ] );
        cache_get_value_name_int ( i, "itemBone", inventory_items [ i + 1 ] [ itemBone ] );

        cache_get_value_name ( i, "itemName", inventory_items [ i + 1 ] [ itemName ] );
        cache_get_value_name_float ( i, "itemX", inventory_items [ i + 1 ] [ itemX ] );
        cache_get_value_name_float ( i, "itemY", inventory_items [ i + 1 ] [ itemY ] );
        cache_get_value_name_float ( i, "itemZ", inventory_items [ i + 1 ] [ itemZ ] );
        cache_get_value_name_float ( i, "itemRotX", inventory_items [ i + 1 ] [ itemRotX ] );
        cache_get_value_name_float ( i, "itemRotY", inventory_items [ i + 1 ] [ itemRotY ] );
        cache_get_value_name_float ( i, "itemRotZ", inventory_items [ i + 1 ] [ itemRotZ ] );

		total ++;
	}
	printf ( "[LoadDynamicItems] Строк - %i. Загружено - %i. Затрачено: %i ms.", rows, total, GetTickCount()-time );
	return 1;
}