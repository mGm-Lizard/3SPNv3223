//================================================================================
// ZoundMenuHist.
//================================================================================
class ZoundMenuHist extends PopupPageBase
	Config(User);

var string sCode;
var string Plays[50];
var string Trigs[50];
var export editinlineuse GUIListBox Playlist;
var export editinlineuse GUIListBox TrigList;

function InitComponent (GUIController MyController, export editinlineuse GUIComponent MyOwner)
{
	MyController.RegisterStyle(Class'ZoundStyle',True);
	Super.InitComponent(MyController,MyOwner);
	Playlist=GUIListBox(Controls[3]);
	TrigList=GUIListBox(Controls[4]);
	Controls[2].SetFocus(None);
	return;
}

function HandleParameters (string Param1, string Param2)
{
	local string sTemp;
	local int i;
	local int j;

	UnknownFunction812().Player.Console.TypingClose();
	UnknownFunction812().Player.Console.ConsoleClose();
	i=InStr(Param1,",");
	sCode=Left(Param1,i);
	Param1=Mid(Param1,i + 1);
	Playlist.List.Clear();
	TrigList.List.Clear();
	i=0;
JL00AC:
	if ( i < 50 )
	{
		j=InStr(Param1,",");
		if ( j > 0 )
		{
			sTemp=Left(Param1,j);
			Param1=Mid(Param1,j + 1);
			if ( sTemp == "" )
			{
				goto JL0147;
			}
			Playlist.List.Add(sTemp);
			Plays[i]=sTemp;
		}
		else
		{
			goto JL0147;
		}
		i++;
		goto JL00AC;
	}
JL0147:
	i=0;
JL014E:
	if ( i < 50 )
	{
		j=InStr(Param2,"~");
		if ( j > -1 )
		{
			sTemp=Left(Param2,j);
			Param2=Mid(Param2,j + 1);
			if ( sTemp == "" )
			{
				goto JL01CA;
			}
			Trigs[i]=sTemp;
		}
		i++;
		goto JL014E;
	}
JL01CA:
	Playlist.List.SetIndex(0);
	Playlist.List.TextAlign=0;
	TrigList.List.TextAlign=0;
	GetPlayerTrigs();
	return;
}

function GetPlayerTrigs ()
{
	local string sTemp;
	local int i;
	local int j;

	i=Playlist.List.Index;
	if ( i > -1 )
	{
		sTemp=Trigs[i];
		TrigList.List.Clear();
		i=0;
JL005C:
		if ( i < 50 )
		{
			j=InStr(sTemp,",");
			if ( j > -1 )
			{
				TrigList.List.Add(Left(sTemp,j));
				sTemp=Mid(sTemp,j + 1);
				if ( (sTemp == "") || (Left(sTemp,1) == "~") )
				{
					goto JL00EB;
				}
			}
			i++;
			goto JL005C;
		}
	}
JL00EB:
	TrigList.List.SetIndex(0);
	TrigList.List.TextAlign=0;
	return;
}

function bool OnClickList (export editinlineuse GUIComponent Sender)
{
	GetPlayerTrigs();
	return True;
	return;
}

function bool OnClickLog (export editinlineuse GUIComponent Sender)
{
	local string sTemp;
	local int i;

	i=0;
JL0007:
	if ( i < 50 )
	{
		if ( Plays[i] != "" )
		{
			sTemp="Total Triggers for " $ Plays[i] $ Chr(9) $ " = " $ Trigs[i];
			Log(sTemp,'Zound');
		}
		i++;
		goto JL0007;
	}
	Controls[5].MenuState=4;
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
    bAllowedAsLast=True
    Controls=[0]=GUIImage'ZoundMenuHist.DialogBackground'
[1]=GUILabel'ZoundMenuHist.MyPageHeader'
[2]=GUIButton'ZoundMenuHist.NoneButton'
[3]=GUIListBox'ZoundMenuHist.PlayerList'
[4]=GUIListBox'ZoundMenuHist.TriggerList'
[5]=GUIButton'ZoundMenuHist.LogButton'
[6]=GUIButton'ZoundMenuHist.CloseButton'
    WinTop=0.12
    WinLeft=0.26
    WinWidth=0.45
    WinHeight=0.39
}
