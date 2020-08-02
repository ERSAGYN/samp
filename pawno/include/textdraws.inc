new Text:SelectSkin0;
new Text:SelectSkin1;
new Text:SelectSkin2;

stock TD_SelectSkin(playerid)
{
	SelectSkin0 = TextDrawCreate(170.000000, 350.000000, "selectleftarrow");
	TextDrawLetterSize(SelectSkin0, 0.0, 0.0);
	TextDrawTextSize(SelectSkin0, 70.000000, 70.000000);
	TextDrawAlignment(SelectSkin0, 1);
	TextDrawColor(SelectSkin0, -1);
	TextDrawSetShadow(SelectSkin0, 0);
	TextDrawFont(SelectSkin0, 5);
	TextDrawSetSelectable(SelectSkin0, true);
	TextDrawSetPreviewModel(SelectSkin0, 19134);
	TextDrawSetPreviewRot(SelectSkin0, 0.000000, 90.000000, 90.000000, 1.000000);
	TextDrawBackgroundColor(SelectSkin0, -256);

	SelectSkin1 = TextDrawCreate(400.000000, 350.000000, "selectrightarrow");
	TextDrawLetterSize(SelectSkin1, 0.000000, 0.000000);
	TextDrawTextSize(SelectSkin1, 70.000000, 70.000000);
	TextDrawAlignment(SelectSkin1, 1);
	TextDrawColor(SelectSkin1, -1);
	TextDrawSetShadow(SelectSkin1, 0);
	TextDrawFont(SelectSkin1, 5);
	TextDrawSetSelectable(SelectSkin1, true);
	TextDrawSetPreviewModel(SelectSkin1, 19134);
	TextDrawSetPreviewRot(SelectSkin1, 0.000000, -90.000000, 90.000000, 1.000000);
	TextDrawBackgroundColor(SelectSkin1, -256);

	SelectSkin2 = TextDrawCreate(265.000000, 365.000000, "SELECT");
	TextDrawLetterSize(SelectSkin2, 1.000000, 4.000000);
	TextDrawTextSize(SelectSkin2, 375.0, 30.0);
	TextDrawAlignment(SelectSkin2, 1);
	TextDrawColor(SelectSkin2, -1);
	TextDrawSetShadow(SelectSkin2, 0);
	TextDrawSetOutline(SelectSkin2, 1);
	TextDrawFont(SelectSkin2, 1);
	TextDrawSetProportional(SelectSkin2, 1);
	TextDrawSetSelectable(SelectSkin2, true);
	
	TextDrawShowForPlayer(playerid, SelectSkin0);
	TextDrawShowForPlayer(playerid, SelectSkin1);
	TextDrawShowForPlayer(playerid, SelectSkin2);
	SelectTextDraw(playerid, 0xFFCC00FF);
}



