//================================================================================
// ZoundMenuTrigs.
//================================================================================
class ZoundMenuTrigs extends PopupPageBase
	Config(User);

var string sCode;
var string MyMutes;
var string MyFavors;
var string MyServerID;
var string MyTrigger;
var string MyPlayer;
var bool bSaveMute;
var bool bSaveFavs;
var bool bSaveClient;
var bool bSavePlayer;
var bool bSaveBind;
var bool bTimer1;
var bool bTimer2;
var bool bStartup;
var bool bRepWait;
var bool bAdmin;
var() bool bReset;
var string sText;
var int iTotal;
var int numSounds;
var int RepSecs;
var int NumTrigsA;
var int NumTrigsB;
var string MySoundA[251];
var string MySoundB[251];
var string MySoundC[251];
var string MySoundD[251];
var string MySoundE[251];
var string MySoundF[251];
var string MySoundG[251];
var string MySoundH[251];
var string KeyBind[125];
var bool MyZound;
var int MyKeyBind;
var int MyVolume;
var export editinlineuse moCheckBox bZoundCnt;
var export editinlineuse GUIListBox PlayerList;
var export editinlineuse GUIListBox KeyBindList;
var export editinlineuse GUISlider BindSlider;
var export editinlineuse moEditBox ChatLine;
var export editinlineuse GUILabel Muted;
var export editinlineuse GUILabel total;
var export editinlineuse GUILabel LabSounds;
var export editinlineuse GUIButton btnSave;
var export editinlineuse GUIListBox AllTrigList;
var export editinlineuse GUIListBox MutedList;
var export editinlineuse GUIListBox FavorList;
var export editinlineuse GUIScrollTextBox CodedList;
var ZoundReplication ZRI;
var Color clRed;

function InitComponent (GUIController MyController, export editinlineuse GUIComponent MyOwner);

function HandleParameters (string Param1, string Param2)
{
	local string sTemp;
	local string P1;
	local string P2;
	local int i;
	local int res;

	if ( ZRI == None )
	{
		CheckReplication();
	}
	P1=Param1;
	P2=Param2;
	sTemp=UnknownFunction812().ConsoleCommand("GETCURRENTRES");
	i=InStr(sTemp,"x");
	if ( i > 0 )
	{
		res=int(Left(sTemp,i));
		if ( (res != 0) && (res < 900) )
		{
			GUILabel(Controls[3]).WinLeft=0.39;
			i=0;
JL00B7:
			if ( i < 36 )
			{
				if ( Controls[i].IsA('GUILabel') )
				{
					GUILabel(Controls[i]).TextFont="UT2IRCFont";
				}
				i++;
				goto JL00B7;
			}
		}
	}
	i=InStr(Param1,",");
	sCode=Left(Param1,i);
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	bAdmin=bool(Left(Param1,i));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	bZoundCnt.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	bRepWait=bool(sTemp);
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	NumTrigsA=int(sTemp);
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	NumTrigsB=int(sTemp);
	Param1=Mid(Param1,i + 1);
	i=InStr(Param2,",");
	sTemp=Left(Param2,i);
	MyPlayer=sTemp;
	Param2=Mid(Param2,i + 1);
	i=InStr(Param2,",");
	sTemp=Left(Param2,i);
	numSounds=int(sTemp);
	Param2=Mid(Param2,i + 1);
	SetPlayerList();
	CheckNumSounds(True);
	if (  !bZoundCnt.IsChecked() )
	{
		ClearAllZoundOptions();
	}
	if (  !bRepWait )
	{
		LoadTriggers(True);
	}
	bStartup=True;
	UnknownFunction813(0.33,True);
	LoadFavorWords();
	LoadFavorList();
	if ( bAdmin )
	{
		Muted.Caption="Coded Triggers   ";
		Controls[8].WinLeft=0.31;
		Controls[9].WinLeft=0.85;
		Controls[9].DisableMe();
		Controls[9].bVisible=False;
		Controls[8].bVisible=True;
		Controls[11].bVisible=False;
		Controls[12].bVisible=False;
		Controls[15].bVisible=True;
		Controls[16].bVisible=True;
		Controls[17].bVisible=True;
		Controls[18].bVisible=True;
		Controls[21].bVisible=True;
		Controls[22].bVisible=False;
	}
	else
	{
		Controls[8].bVisible=False;
		Controls[8].WinLeft=0.85;
		Controls[9].WinLeft=0.31;
		Controls[8].DisableMe();
		Controls[21].bVisible=True;
		LoadMutedWords();
		LoadMutedList();
	}
	FavorList.List.SetIndex(0);
	LoadClientStuff();
	bSaveFavs=False;
	bSaveMute=False;
	bSaveClient=False;
	btnSave.Caption="Save";
	ChatLine.SetText("");
	Controls[20].SetFocus(None);
	return;
}

function ResetFocus ()
{
	Controls[7].SetFocus(None);
	return;
}

function Timer ()
{
	if ( Default.bReset )
	{
		Default.bReset=False;
		ResetFocus();
	}
	if ( bRepWait )
	{
		RepSecs++;
		if ( RepSecs == 3 )
		{
			RepSecs=0;
			LoadTriggers(False);
		}
	}
	if ( bStartup )
	{
		bStartup=False;
		ChatLine.SetText("");
	}
	if ( bSaveFavs || bSaveMute || bSaveClient || bSavePlayer || bSaveBind )
	{
		bTimer1= !bTimer1;
		if ( bTimer1 )
		{
			btnSave.Caption=Chr(27) $ Chr(240) $ Chr(16) $ Chr(16) $ "Save";
		}
		else
		{
			btnSave.Caption=Chr(27) $ Chr(240) $ Chr(240) $ Chr(240) $ "Save";
		}
	}
	return;
}

function bool CheckNumSounds (optional bool bStart)
{
	if ( bAdmin )
	{
		LabSounds.Caption="AdminOnly";
		LabSounds.TextColor=clRed;
		LabSounds.TextAlign=0;
		return True;
	}
	if ( numSounds >= 9999 )
	{
		LabSounds.Caption="Unlimited Zounds";
		return True;
	}
	else
	{
		if ( numSounds == 0 )
		{
			LabSounds.Caption="Zounds left: " $ string(numSounds);
			return False;
		}
		else
		{
			if (  !bStart )
			{
				numSounds--;
			}
			LabSounds.Caption="Zounds left: " $ string(numSounds);
			return True;
		}
	}
	return;
}

function ClearAllZoundOptions ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 36 )
	{
		if ( (i != 25) && (i != 26) && (i != 33) )
		{
			Controls[i].DisableMe();
		}
		i++;
		goto JL0007;
	}
	return;
}

function LoadMutedList ()
{
	local string sTemp;
	local string sMutes;
	local int j;

	MutedList.List.Clear();
	sMutes=MyMutes;
	j=InStr(sMutes,",");
JL0033:
	if ( j != -1 )
	{
		sTemp=Left(sMutes,j);
		if ( sTemp == "" )
		{
			goto JL00A8;
		}
		MutedList.List.Add(sTemp);
		sMutes=Mid(sMutes,j + 1);
		j=InStr(sMutes,",");
		goto JL0033;
	}
JL00A8:
	MutedList.List.Sort();
	MutedList.List.SetIndex(0);
	return;
}

function LoadFavorList ()
{
	local string sTemp;
	local string sFavr;
	local int j;

	FavorList.List.Clear();
	sFavr=MyFavors;
	j=InStr(sFavr,",");
JL0033:
	if ( j != -1 )
	{
		sTemp=Left(sFavr,j);
		if ( sTemp == "" )
		{
			goto JL00A8;
		}
		FavorList.List.Add(sTemp);
		sFavr=Mid(sFavr,j + 1);
		j=InStr(sFavr,",");
		goto JL0033;
	}
JL00A8:
	FavorList.List.Sort();
	FavorList.List.SetIndex(0);
	return;
}

function CheckReplication ()
{
	foreach UnknownFunction812().DynamicActors(Class'ZoundReplication',ZRI)
	{
		goto JL001B;
JL001B:
	}
	return;
}

function LoadTriggers (bool bDone)
{
	local int i;

	if ( ZRI == None )
	{
		CheckReplication();
	}
	if ( ZRI == None )
	{
		return;
	}
	AllTrigList.List.Clear();
	iTotal=0;
	sText="";
	i=0;
JL004C:
	if ( i < 250 )
	{
		if ( MySoundA[i] == "" )
		{
			MySoundA[i]=ZRI.SoundA[i];
			if ( MySoundA[i] == "" )
			{
				goto JL00C0;
			}
		}
		AddToAllTriggers(MySoundA[i],bAdmin);
		i++;
		goto JL004C;
	}
JL00C0:
	i=0;
JL00C7:
	if ( i < 250 )
	{
		if ( MySoundB[i] == "" )
		{
			MySoundB[i]=ZRI.SoundB[i];
			if ( MySoundB[i] == "" )
			{
				goto JL013B;
			}
		}
		AddToAllTriggers(MySoundB[i],bAdmin);
		i++;
		goto JL00C7;
	}
JL013B:
	i=0;
JL0142:
	if ( i < 250 )
	{
		if ( MySoundC[i] == "" )
		{
			MySoundC[i]=ZRI.SoundC[i];
			if ( MySoundC[i] == "" )
			{
				goto JL01B6;
			}
		}
		AddToAllTriggers(MySoundC[i],bAdmin);
		i++;
		goto JL0142;
	}
JL01B6:
	i=0;
JL01BD:
	if ( i < 250 )
	{
		if ( MySoundD[i] == "" )
		{
			MySoundD[i]=ZRI.SoundD[i];
			if ( MySoundD[i] == "" )
			{
				goto JL0231;
			}
		}
		AddToAllTriggers(MySoundD[i],bAdmin);
		i++;
		goto JL01BD;
	}
JL0231:
	i=0;
JL0238:
	if ( i < 250 )
	{
		if ( MySoundE[i] == "" )
		{
			MySoundE[i]=ZRI.SoundE[i];
			if ( MySoundE[i] == "" )
			{
				goto JL02AC;
			}
		}
		AddToAllTriggers(MySoundE[i],bAdmin);
		i++;
		goto JL0238;
	}
JL02AC:
	i=0;
JL02B3:
	if ( i < 250 )
	{
		if ( MySoundF[i] == "" )
		{
			MySoundF[i]=ZRI.SoundF[i];
			if ( MySoundF[i] == "" )
			{
				goto JL0327;
			}
		}
		AddToAllTriggers(MySoundF[i],bAdmin);
		i++;
		goto JL02B3;
	}
JL0327:
	i=0;
JL032E:
	if ( i < 250 )
	{
		if ( MySoundG[i] == "" )
		{
			MySoundG[i]=ZRI.SoundG[i];
			if ( MySoundG[i] == "" )
			{
				goto JL03A2;
			}
		}
		AddToAllTriggers(MySoundG[i],bAdmin);
		i++;
		goto JL032E;
	}
JL03A2:
	i=0;
JL03A9:
	if ( i < 250 )
	{
		if ( MySoundH[i] == "" )
		{
			MySoundH[i]=ZRI.SoundH[i];
			if ( MySoundH[i] == "" )
			{
				goto JL041D;
			}
		}
		AddToAllTriggers(MySoundH[i],bAdmin);
		i++;
		goto JL03A9;
	}
JL041D:
	if ( bAdmin )
	{
		if ( sText == "" )
		{
			sText="      ";
		}
		CodedList.MyScrollText.SetContent(sText,Chr(10));
	}
	ShowTotalTriggers(iTotal,bDone);
	return;
}

function ShowTotalTriggers (int iTot, bool bDone)
{
	local string sTemp;
	local string sTotal;
	local int t;

	if ( bAdmin )
	{
		t=NumTrigsA;
	}
	else
	{
		t=NumTrigsB;
	}
	sTemp=GetStringTriggers(iTot);
	if ( (iTot >= t) || bDone )
	{
		t=iTot;
		bRepWait=False;
		sTotal=GetStringTriggers(t);
		total.Caption="Total Triggers: " $ sTemp $ "/" $ sTotal;
	}
	else
	{
		sTotal=GetStringTriggers(t + 1);
		total.Caption="Loading...... : " $ sTemp $ "/" $ sTotal;
	}
	return;
}

function string GetStringTriggers (int iNum)
{
	local string sTemp;

	sTemp="";
	if ( iNum < 10 )
	{
		sTemp="000";
	}
	else
	{
		if ( iNum < 100 )
		{
			sTemp="00";
		}
		else
		{
			if ( iNum < 1000 )
			{
				sTemp="0";
			}
		}
	}
	sTemp=sTemp $ string(iNum);
	return sTemp;
	return;
}

function AddToAllTriggers (string sTrig, bool bAdm)
{
	local string sTemp;

	if ( sTrig != "" )
	{
		sTemp=Left(sTrig,1);
		sTrig=Mid(sTrig,1);
		if (  !bAdm && ((sTemp == "{") || (sTemp == "}") || (sTemp == "[") || (sTemp == "]")) )
		{
			return;
		}
		AllTrigList.List.Add(sTrig);
		iTotal++;
		if ( bAdm )
		{
			AddToCodedList(sTrig,sTemp);
		}
	}
	return;
}

function AddToCodedList (string sTrig, string sLeft)
{
	local string Yel;
	local string Red;
	local string Wht;
	local string Blu;
	local string Grn;
	local string Vio;
	local string Aqu;

	Yel="רר";
	Red="ר";
	Wht="ררר";
	Blu="€ר";
	Grn="א";
	Vio="רר";
	Aqu="רר";
	if ( (sTrig == "") || (sLeft == "") )
	{
		return;
	}
	if ( sLeft == "}" )
	{
		sTrig=Red $ sTrig $ Blu $ "*" $ Wht;
	}
	else
	{
		if ( sLeft == "{" )
		{
			sTrig=Red $ sTrig $ Wht;
		}
		else
		{
			if ( sLeft == "]" )
			{
				sTrig=Yel $ sTrig $ Blu $ "*" $ Wht;
			}
			else
			{
				if ( sLeft == "[" )
				{
					sTrig=Yel $ sTrig $ Wht;
				}
				else
				{
					if ( sLeft == ")" )
					{
						sTrig=Grn $ sTrig $ Blu $ "*" $ Wht;
					}
					else
					{
						if ( sLeft == "(" )
						{
							sTrig=Grn $ sTrig $ Wht;
						}
						else
						{
							if ( sLeft == ">" )
							{
								sTrig=sTrig $ Blu $ "*" $ Wht;
							}
						}
					}
				}
			}
		}
	}
	sText=sText $ sTrig $ Chr(10);
	return;
}

function bool FavorListDblClick (export editinlineuse GUIComponent Sender)
{
	local string sTemp;
	local int i;

	i=FavorList.List.Index;
	if ( i < 0 )
	{
		return False;
	}
	sTemp=FavorList.List.GetItemAtIndex(i);
	if ( sTemp == "" )
	{
		return False;
	}
	MyTrigger=sTemp;
	ChatLine.SetText("");
	ResetFocus();
	if (  !bAdmin &&  !CheckNumSounds() )
	{
		return False;
	}
	UnknownFunction812().ConsoleCommand("Say " $ sTemp);
	return;
}

function bool CheckMessage (out byte Key, out byte State, float Delta)
{
	local string sTemp;

	if ( (Key == 13) && (State == 1) )
	{
		sTemp=ChatLine.GetText();
		ChatLine.SetText("");
		if ( CheckIfTrigger(sTemp) )
		{
			if (  !bAdmin &&  !CheckNumSounds() )
			{
				return False;
			}
		}
		UnknownFunction812().ConsoleCommand("Say " $ sTemp);
		return True;
	}
	return False;
	return;
}

function bool CheckIfTrigger (string sTrig)
{
	local string sTemp;
	local int i;
	local int j;
	local int L;

	L=AllTrigList.List.ItemCount;
	if ( L == 0 )
	{
		return False;
	}
	sTrig=Caps(sTrig);
	i=1;
JL003E:
	if ( i < 50 )
	{
		if ( Left(sTrig,1) == " " )
		{
			sTrig=Mid(sTrig,1);
		}
		i++;
		goto JL003E;
	}
	i=InStr(sTrig,"  ");
JL0083:
	if ( i != -1 )
	{
		sTrig=Left(sTrig,i) $ Mid(sTrig,i + 1);
		i=InStr(sTrig,"  ");
		goto JL0083;
	}
	if ( (sTrig != "") && (Mid(sTrig,Len(sTrig) - 1) == " ") )
	{
		if ( Mid(sTrig,Len(sTrig)) == "" )
		{
			if ( InStr(sTrig," ") == -1 )
			{
				sTrig=Left(sTrig,Len(sTrig) - 1);
			}
		}
	}
	i=0;
JL0137:
	if ( i < L )
	{
		sTemp=Caps(AllTrigList.List.GetItemAtIndex(i));
		if ( sTrig == sTemp )
		{
			return True;
		}
		sTemp=sTemp $ " ";
		if ( sTrig == sTemp )
		{
			return True;
		}
		sTemp=" " $ sTemp;
		j=InStr(sTrig,sTemp);
		if ( j != -1 )
		{
			return True;
		}
		i++;
		goto JL0137;
	}
	return False;
	return;
}

function bool AllTrigListDblClick (export editinlineuse GUIComponent Sender)
{
	local string sTemp;
	local int i;

	i=AllTrigList.List.Index;
	if ( i < 0 )
	{
		return False;
	}
	sTemp=AllTrigList.List.GetItemAtIndex(i);
	if ( sTemp == "" )
	{
		return False;
	}
	MyTrigger=sTemp;
	ChatLine.SetText("");
	ResetFocus();
	if (  !bAdmin &&  !CheckNumSounds() )
	{
		return False;
	}
	UnknownFunction812().ConsoleCommand("Say " $ sTemp);
	return True;
	return;
}

function bool OnClickSubFav (export editinlineuse GUIComponent Sender)
{
	local string sTemp;
	local int i;

	ResetFocus();
	if ( FavorList.List.ItemCount == 0 )
	{
		return False;
	}
	i=FavorList.List.Index;
	sTemp=FavorList.List.GetItemAtIndex(i);
	i=InStr(Caps(MyFavors),Caps(sTemp) $ ",");
	if ( i == -1 )
	{
		UnknownFunction812().ClientMessage("< Cannot find " $ sTemp $ " in your Favourite List >");
		UnknownFunction812().ClientPlaySound(Sound'UDamagePickup');
		return False;
	}
	MyFavors=Left(MyFavors,i) $ Mid(MyFavors,i + Len(sTemp) + 1);
	LoadFavorList();
	btnSave.Caption=Chr(27) $ Chr(254) $ Chr(16) $ Chr(16) $ "Save";
	bSaveFavs=True;
	return True;
	return;
}

function bool OnClickAddFav (export editinlineuse GUIComponent Sender)
{
	local string sTemp;
	local int i;

	ResetFocus();
	i=AllTrigList.List.Index;
	sTemp=AllTrigList.List.GetItemAtIndex(i);
	i=InStr(Caps(MyFavors),Caps(sTemp) $ ",");
	if ( i != -1 )
	{
		UnknownFunction812().ClientMessage("< " $ sTemp $ " is already in your Favourite List >");
		UnknownFunction812().ClientPlaySound(Sound'UDamagePickup');
		return False;
	}
	if ( Len(MyFavors) + Len(sTemp) + 1 > 249 )
	{
		UnknownFunction812().ClientMessage("< Your Favourites buffer has reached its Limit >");
		UnknownFunction812().ClientPlaySound(Sound'UDamagePickup');
		return False;
	}
	MyFavors=sTemp $ "," $ MyFavors;
	LoadFavorList();
	btnSave.Caption=Chr(27) $ Chr(254) $ Chr(16) $ Chr(16) $ "Save";
	bSaveFavs=True;
	return True;
	return;
}

function bool OnClickSubMute (export editinlineuse GUIComponent Sender)
{
	local string sTemp;
	local int i;

	ResetFocus();
	if ( FavorList.List.ItemCount == 0 )
	{
		return False;
	}
	i=MutedList.List.Index;
	sTemp=MutedList.List.GetItemAtIndex(i);
	i=InStr(Caps(MyMutes),Caps(sTemp) $ ",");
	if ( i == -1 )
	{
		UnknownFunction812().ClientMessage("< Cannot find " $ sTemp $ " in your Mute buffer >");
		UnknownFunction812().ClientPlaySound(Sound'UDamagePickup');
		return False;
	}
	MyMutes=Left(MyMutes,i) $ Mid(MyMutes,i + Len(sTemp) + 1);
	LoadMutedList();
	btnSave.Caption=Chr(27) $ Chr(254) $ Chr(16) $ Chr(16) $ "Save";
	bSaveMute=True;
	return True;
	return;
}

function bool OnClickAddMute (export editinlineuse GUIComponent Sender)
{
	local string sTemp;
	local int i;

	ResetFocus();
	i=AllTrigList.List.Index;
	sTemp=AllTrigList.List.GetItemAtIndex(i);
	i=InStr(Caps(MyMutes),Caps(sTemp) $ ",");
	if ( i != -1 )
	{
		UnknownFunction812().ClientMessage("< " $ sTemp $ " is already in your Mute buffer >");
		UnknownFunction812().ClientPlaySound(Sound'UDamagePickup');
		return False;
	}
	if ( Len(MyMutes) + Len(sTemp) + 1 > 199 )
	{
		UnknownFunction812().ClientMessage("< Your Mute buffer has reached its Limit >");
		UnknownFunction812().ClientPlaySound(Sound'UDamagePickup');
		return False;
	}
	MyMutes=sTemp $ "," $ MyMutes;
	LoadMutedList();
	btnSave.Caption=Chr(27) $ Chr(254) $ Chr(16) $ Chr(16) $ "Save";
	bSaveMute=True;
	return True;
	return;
}

function bool OnRightClickSave (export editinlineuse GUIComponent Sender)
{
	ResetFocus();
	bSaveMute=False;
	bSaveFavs=False;
	bSaveClient=False;
	bSavePlayer=False;
	bSaveBind=False;
	btnSave.Caption="Save";
	return True;
	return;
}

function bool OnClickSave (export editinlineuse GUIComponent Sender)
{
	local string sTemp;
	local int i;

	ResetFocus();
	if ( bSaveFavs )
	{
		bSaveFavs=False;
		if ( Len(MyFavors) < 250 )
		{
			SaveFavorWords();
		}
		else
		{
			UnknownFunction812().ClientMessage("< Your Favourites buffer has reached its Limit >");
			UnknownFunction812().ClientPlaySound(Sound'UDamagePickup');
		}
	}
	if ( bSaveMute )
	{
		bSaveMute=False;
		sTemp=MyMutes;
		if ( (sTemp != "") && (Mid(sTemp,Len(sTemp) - 1) != ",") )
		{
			sTemp=sTemp $ ",";
		}
		if ( Len(sTemp) < 200 )
		{
			UnknownFunction812().Player.Console.DelayedConsoleCommand("MUTATE " $ sCode $ "ZoundClientMute-" $ sTemp);
			SaveMutedWords();
		}
		else
		{
			UnknownFunction812().ClientMessage("< Your Mute buffer has reached its Limit >");
			UnknownFunction812().ClientPlaySound(Sound'UDamagePickup');
		}
	}
	if ( bSaveClient )
	{
		bSaveClient=False;
		SaveClientStuff(False);
	}
	if ( bSavePlayer )
	{
		i=PlayerList.List.Index;
		sTemp=PlayerList.List.GetItemAtIndex(i);
		MyPlayer=sTemp;
		UnknownFunction812().Player.Console.DelayedConsoleCommand("MUTATE " $ sCode $ "ZoundClientMutePlayer-" $ sTemp);
		bSavePlayer=False;
		SetPlayerList();
	}
	if ( bSaveBind )
	{
		i=KeyBindList.List.Index;
		sTemp=KeyBindList.List.GetItemAtIndex(i);
		sTemp=Mid(sTemp,5);
		MyKeyBind=FindKeyBind(sTemp);
		SaveClientStuff(True);
		bSaveBind=False;
	}
	btnSave.Caption="Save";
	return True;
	return;
}

function LoadMutedWords ()
{
	local int i;
	local int j;

	j=Class'ZoundClient'.Default.ZoundServer.Length;
	if ( j == 0 )
	{
		return;
	}
	MyServerID=Class'ZoundClient'.Default.MyServerID;
	i=0;
JL003D:
	if ( i < j )
	{
		if ( Class'ZoundClient'.Default.ZoundServer[i].ServerID == MyServerID )
		{
			MyMutes=Class'ZoundClient'.Default.ZoundServer[i].MutedWords;
			if ( Len(MyMutes) > 199 )
			{
				MyMutes=Left(MyMutes,199);
			}
			if ( (MyMutes != "") && (Mid(MyMutes,Len(MyMutes) - 1) != ",") )
			{
				MyMutes=MyMutes $ ",";
			}
			return;
		}
		i++;
		goto JL003D;
	}
	return;
}

function SaveMutedWords ()
{
	local string sTemp;
	local int i;
	local int j;

	j=Class'ZoundClient'.Default.ZoundServer.Length;
	MyServerID=Class'ZoundClient'.Default.MyServerID;
	sTemp=MyMutes;
	if ( (sTemp != "") && (Mid(sTemp,Len(sTemp) - 1) == ",") )
	{
		sTemp=Left(sTemp,Len(sTemp) - 1);
	}
	if ( j != 0 )
	{
		i=0;
JL0084:
		if ( i < j )
		{
			if ( Class'ZoundClient'.Default.ZoundServer[i].ServerID == MyServerID )
			{
				Class'ZoundClient'.Default.ZoundServer[i].MutedWords=sTemp;
				Class'ZoundClient'.StaticSaveConfig();
				return;
			}
			i++;
			goto JL0084;
		}
	}
	if ( j > 1000 )
	{
		return;
	}
	Class'ZoundClient'.Default.ZoundServer.Length=j + 1;
	Class'ZoundClient'.Default.ZoundServer[j].ServerID=MyServerID;
	Class'ZoundClient'.Default.ZoundServer[j].MutedWords=sTemp;
	Class'ZoundClient'.StaticSaveConfig();
	return;
}

function LoadFavorWords ()
{
	local int i;
	local int j;

	j=Class'ZoundClient'.Default.ZoundServer.Length;
	if ( j == 0 )
	{
		return;
	}
	MyServerID=Class'ZoundClient'.Default.MyServerID;
	i=0;
JL003D:
	if ( i < j )
	{
		if ( Class'ZoundClient'.Default.ZoundServer[i].ServerID == MyServerID )
		{
			MyFavors=Class'ZoundClient'.Default.ZoundServer[i].Favourites;
			if ( Len(MyFavors) > 249 )
			{
				MyFavors=Left(MyFavors,249);
			}
			if ( (MyFavors != "") && (Mid(MyFavors,Len(MyFavors) - 1) != ",") )
			{
				MyFavors=MyFavors $ ",";
			}
			return;
		}
		i++;
		goto JL003D;
	}
	return;
}

function SaveFavorWords ()
{
	local string sTemp;
	local int i;
	local int j;

	j=Class'ZoundClient'.Default.ZoundServer.Length;
	MyServerID=Class'ZoundClient'.Default.MyServerID;
	sTemp=MyFavors;
	if ( (sTemp != "") && (Mid(sTemp,Len(sTemp) - 1) == ",") )
	{
		sTemp=Left(sTemp,Len(sTemp) - 1);
	}
	if ( j != 0 )
	{
		i=0;
JL0084:
		if ( i < j )
		{
			if ( Class'ZoundClient'.Default.ZoundServer[i].ServerID == MyServerID )
			{
				Class'ZoundClient'.Default.ZoundServer[i].Favourites=sTemp;
				Class'ZoundClient'.StaticSaveConfig();
				return;
			}
			i++;
			goto JL0084;
		}
	}
	if ( j >= 1000 )
	{
		return;
	}
	Class'ZoundClient'.Default.ZoundServer.Length=j + 1;
	Class'ZoundClient'.Default.ZoundServer[j].ServerID=MyServerID;
	Class'ZoundClient'.Default.ZoundServer[j].Favourites=sTemp;
	Class'ZoundClient'.StaticSaveConfig();
	return;
}

function bool OnClickAdmin (export editinlineuse GUIComponent Sender)
{
	UnknownFunction812().Player.Console.DelayedConsoleCommand("MUTATE " $ sCode $ "ZoundAdminMenu");
	Controller.CloseMenu(False);
	return True;
	return;
}

function bool OnClickAllList (export editinlineuse GUIComponent Sender)
{
	local int i;

	i=AllTrigList.List.Index;
	if ( i < 0 )
	{
		return False;
	}
	MyTrigger=AllTrigList.List.GetItemAtIndex(i);
	return True;
	return;
}

function bool OnClickMutedList (export editinlineuse GUIComponent Sender)
{
	local int i;

	i=MutedList.List.Index;
	if ( i < 0 )
	{
		return False;
	}
	MyTrigger=MutedList.List.GetItemAtIndex(i);
	return True;
	return;
}

function bool OnClickFavorList (export editinlineuse GUIComponent Sender)
{
	local int i;

	i=FavorList.List.Index;
	if ( i < 0 )
	{
		return False;
	}
	MyTrigger=FavorList.List.GetItemAtIndex(i);
	return True;
	return;
}

function bool OnClickTest (export editinlineuse GUIComponent Sender)
{
	if ( MyTrigger != "" )
	{
		UnknownFunction812().ConsoleCommand("Say ~" $ MyTrigger);
		ChatLine.SetText("");
		ResetFocus();
	}
	return True;
	return;
}

function bool OnClickDump (export editinlineuse GUIComponent Sender)
{
	local string sTemp;
	local string sDump;
	local string SvrID;
	local int i;
	local int j;
	local int X;
	local int Z;

	ResetFocus();
	if ( MyServerID == "" )
	{
		return False;
	}
	SvrID=MyServerID;
	Z=2;
	X=AllTrigList.List.ItemCount;
	i=0;
JL004B:
	if ( i < X )
	{
		sTemp=AllTrigList.List.GetItemAtIndex(i);
		sDump=sDump $ sTemp $ ",";
		j=Len(sDump);
		if ( j > 960 )
		{
			Controller.OpenMenu("Zound55.ZoundNames",SvrID,sDump);
			SvrID=MyServerID $ "_" $ string(Z);
			sDump="";
			Z++;
			j=0;
		}
		i++;
		goto JL004B;
	}
	if ( j > 3 )
	{
		Controller.OpenMenu("Zound55.ZoundNames",SvrID,sDump);
	}
	ResetFocus();
	return True;
	return;
}

function OnChangeClient (export editinlineuse GUIComponent Sender)
{
	ResetFocus();
	btnSave.Caption=Chr(27) $ Chr(254) $ Chr(16) $ Chr(16) $ "Save";
	bSaveClient=True;
	return;
}

function SaveClientStuff (bool bBind)
{
	local string sTemp;

	MyZound=bZoundCnt.IsChecked();
	MyVolume=GUISlider(Controls[35]).Value;
	Class'ZoundClient'.Default.ZoundEnabled=MyZound;
	if ( bBind )
	{
		Class'ZoundClient'.Default.ZoundMenuKey=MyKeyBind;
	}
	Class'ZoundClient'.Default.ZoundVolume=MyVolume;
	Class'ZoundClient'.StaticSaveConfig();
	sTemp="";
	if ( bZoundCnt.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	sTemp=sTemp $ string(MyVolume) $ ",";
	UnknownFunction812().Player.Console.DelayedConsoleCommand("MUTATE " $ sCode $ "ZoundClientSubmit-" $ sTemp);
	return;
}

function LoadClientStuff ()
{
	local string sTemp;
	local int i;
	local int j;

	MyZound=Class'ZoundClient'.Default.ZoundEnabled;
	bZoundCnt.Checked(MyZound);
	MyKeyBind=Class'ZoundClient'.Default.ZoundMenuKey;
	MyVolume=Class'ZoundClient'.Default.ZoundVolume;
	GUISlider(Controls[35]).SetValue(MyVolume);
	sTemp="Key: " $ KeyBind[MyKeyBind];
	j=KeyBindList.List.ItemCount;
	KeyBindList.List.SetIndex(0);
	i=0;
JL00C8:
	if ( i < j )
	{
		if ( KeyBindList.List.GetItemAtIndex(i) == sTemp )
		{
			sTemp="";
			KeyBindList.List.SetIndex(i);
		}
		else
		{
			KeyBindList.List.MyScrollBar.UnknownFunction202(Default.MySoundA,1);
			i++;
			goto JL00C8;
			ChatLine.SetText("");
			// There are 2 jump destination(s) inside the last statement!
		}
	}
	return;
}

function SetPlayerList ()
{
	local string sTemp;
	local int i;

	PlayerList.List.Clear();
	PlayerList.List.Add(MyPlayer);
	if ( MyPlayer != "None" )
	{
		PlayerList.List.Add("None");
	}
	i=0;
JL006A:
	if ( i < 32 )
	{
		sTemp=ZRI.Players[i];
		if ( sTemp == "" )
		{
			goto JL0108;
		}
		if ( (sTemp != MyPlayer) && (sTemp != UnknownFunction812().PlayerReplicationInfo.PlayerName) && (sTemp != "None") )
		{
			PlayerList.List.Add(sTemp);
		}
		i++;
		goto JL006A;
	}
JL0108:
	PlayerList.List.SetIndex(0);
	return;
}

function bool OnClickBindList (export editinlineuse GUIComponent Sender)
{
	bSaveBind=True;
	return True;
	return;
}

function bool OnClickMutePlayer (export editinlineuse GUIComponent Sender)
{
	if ( PlayerList.List.ItemCount > 1 )
	{
		bSavePlayer=True;
	}
	return True;
	return;
}

function SetKeyBindList ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 125 )
	{
		KeyBind[i]="";
		i++;
		goto JL0007;
	}
	KeyBind[0]="None";
	KeyBind[32]="SpaceBar";
	KeyBind[33]="PageUp";
	KeyBind[34]="PageDn";
	KeyBind[35]="End";
	KeyBind[36]="Home";
	KeyBind[37]="Left";
	KeyBind[38]="Up";
	KeyBind[39]="Right";
	KeyBind[40]="Down";
	KeyBind[44]="PrintScn";
	KeyBind[45]="Insert";
	KeyBind[46]="Delete";
	KeyBind[65]="A";
	KeyBind[66]="B";
	KeyBind[67]="C";
	KeyBind[68]="D";
	KeyBind[69]="E";
	KeyBind[70]="F";
	KeyBind[71]="G";
	KeyBind[72]="H";
	KeyBind[73]="I";
	KeyBind[74]="J";
	KeyBind[75]="K";
	KeyBind[76]="L";
	KeyBind[77]="M";
	KeyBind[78]="N";
	KeyBind[79]="O";
	KeyBind[80]="P";
	KeyBind[81]="Q";
	KeyBind[82]="R";
	KeyBind[83]="S";
	KeyBind[84]="T";
	KeyBind[85]="U";
	KeyBind[86]="V";
	KeyBind[87]="W";
	KeyBind[88]="X";
	KeyBind[89]="Y";
	KeyBind[90]="Z";
	KeyBind[96]="NumPad0";
	KeyBind[97]="NumPad1";
	KeyBind[98]="NumPad2";
	KeyBind[99]="NumPad3";
	KeyBind[100]="NumPad4";
	KeyBind[101]="NumPad5";
	KeyBind[102]="NumPad6";
	KeyBind[103]="NumPad7";
	KeyBind[104]="NumPad8";
	KeyBind[105]="NumPad9";
	KeyBind[106]="GreyStar";
	KeyBind[107]="GreyPlus";
	KeyBind[109]="GreyMinus";
	KeyBind[111]="GreySlash";
	KeyBind[112]="F1";
	KeyBind[113]="F2";
	KeyBind[114]="F3";
	KeyBind[115]="F4";
	KeyBind[116]="F5";
	KeyBind[117]="F6";
	KeyBind[118]="F7";
	KeyBind[119]="F8";
	KeyBind[120]="F9";
	KeyBind[121]="F10";
	KeyBind[122]="F11";
	KeyBind[123]="F12";
	KeyBindList.List.Clear();
	i=0;
JL03F3:
	if ( i < 125 )
	{
		if ( KeyBind[i] != "" )
		{
			KeyBindList.List.Add("Key: " $ KeyBind[i]);
		}
		i++;
		goto JL03F3;
	}
	return;
}

function int FindKeyBind (string sBind)
{
	local int i;

	i=0;
JL0007:
	if ( i < 125 )
	{
		if ( KeyBind[i] == sBind )
		{
			return i;
		}
		i++;
		goto JL0007;
	}
	return 0;
	return;
}

function bool OnClickAbout (export editinlineuse GUIComponent Sender)
{
	Controller.OpenMenu("Zound55.ZoundMenuAbout");
	return True;
	return;
}

function bool OnClickClose (export editinlineuse GUIComponent Sender)
{
	Controller.CloseMenu(False);
	return True;
	return;
}

function InternalOnCreateComponent (export editinlineuse GUIComponent NewComp, export editinlineuse GUIComponent Sender)
{
	return;
}

function OnClose (optional bool bCanceled)
{
	Controller.PurgeObjectReferences();
	Controller.VerifyStack();
	return;
}

defaultproperties
{
    clRed=(R=10, G=10, B=255, A=255)
    bAllowedAsLast=True
    Controls=[0]=GUIImage'ZoundMenuTrigs.BackDialog'
[1]=GUIImage'ZoundMenuTrigs.MyPageHeader'
[2]=GUILabel'ZoundMenuTrigs.MyHeaderLabel'
[3]=GUILabel'ZoundMenuTrigs.LabelNum'
[4]=GUILabel'ZoundMenuTrigs.LabelTrigs'
[5]=GUILabel'ZoundMenuTrigs.LabelFavor'
[6]=GUILabel'ZoundMenuTrigs.LabelMuted'
[7]=GUIListBox'ZoundMenuTrigs.ListAllTrigs'
[8]=GUIScrollTextBox'ZoundMenuTrigs.CodedNames'
[9]=GUIListBox'ZoundMenuTrigs.ListMuted'
[10]=GUIListBox'ZoundMenuTrigs.ListFavor'
[11]=GUIButton'ZoundMenuTrigs.AddMuteButton'
[12]=GUIButton'ZoundMenuTrigs.SubMuteButton'
[13]=GUIButton'ZoundMenuTrigs.AddFButton'
[14]=GUIButton'ZoundMenuTrigs.SubFavButton'
[15]=GUILabel'ZoundMenuTrigs.LabelNorm'
[16]=GUILabel'ZoundMenuTrigs.LabelDed'
[17]=GUILabel'ZoundMenuTrigs.LabelRnd'
[18]=GUILabel'ZoundMenuTrigs.LabelHid'
[19]=GUILabel'ZoundMenuTrigs.LabelLeft'
[20]=moEditBox'ZoundMenuTrigs.Chat'
[21]=GUIButton'ZoundMenuTrigs.AdminButton'
[22]=GUIButton'ZoundMenuTrigs.AboutButton'
[23]=GUIButton'ZoundMenuTrigs.TestButton'
[24]=GUIButton'ZoundMenuTrigs.DumpButton'
[25]=GUIButton'ZoundMenuTrigs.SaveButton'
[26]=GUIButton'ZoundMenuTrigs.CloseButton'
[27]=GUIImage'ZoundMenuTrigs.ClientHeader'
[28]=GUILabel'ZoundMenuTrigs.ClientLabel'
[29]=GUILabel'ZoundMenuTrigs.LabelOptions'
[30]=GUIListBox'ZoundMenuTrigs.ListPlayers'
[31]=GUILabel'ZoundMenuTrigs.BindLabel'
[32]=GUIListBox'ZoundMenuTrigs.ListBind'
[33]=moCheckBox'ZoundMenuTrigs.ZEnable'
[34]=GUILabel'ZoundMenuTrigs.LabelVol'
[35]=GUISlider'ZoundMenuTrigs.VolSlider'
    WinTop=0.12
    WinLeft=0.13
    WinWidth=0.70
    WinHeight=0.48
}
