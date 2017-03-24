//================================================================================
// ZoundMenuAdmin.
//================================================================================
class ZoundMenuAdmin extends PopupPageBase
	Config(User);

var bool bAdmin;
var string sCode;
var export editinlineuse GUILabel lblBind;
var export editinlineuse moCheckBox bZoundSvr;
var export editinlineuse moCheckBox bShowTrigger;
var export editinlineuse moCheckBox bShowToSelf;
var export editinlineuse moCheckBox bAnnounce;
var export editinlineuse moCheckBox Announce1;
var export editinlineuse moCheckBox bBotsTalk;
var export editinlineuse moCheckBox bSpecPlay;
var export editinlineuse moCheckBox b24HourTime;
var export editinlineuse moCheckBox bInGameZound;
var export editinlineuse moCheckBox bChatLog;
var export editinlineuse moCheckBox bChatFilter;
var export editinlineuse moCheckBox bPlayerList;
var export editinlineuse moNumericEdit SoundDelay;
var export editinlineuse moNumericEdit LoginDelay;
var export editinlineuse moNumericEdit DelaysEach;
var export editinlineuse moNumericEdit SoundsEach;
var export editinlineuse moNumericEdit RepeatDelay;
var export editinlineuse GUIListBox PlayerList;

function InitComponent (GUIController MyController, export editinlineuse GUIComponent MyOwner)
{
	MyController.RegisterStyle(Class'ZoundStyle',True);
	Super.InitComponent(MyController,MyOwner);
	bZoundSvr=moCheckBox(Controls[3]);
	bShowTrigger=moCheckBox(Controls[4]);
	bShowToSelf=moCheckBox(Controls[5]);
	bAnnounce=moCheckBox(Controls[6]);
	Announce1=moCheckBox(Controls[7]);
	bBotsTalk=moCheckBox(Controls[8]);
	bSpecPlay=moCheckBox(Controls[9]);
	b24HourTime=moCheckBox(Controls[10]);
	bInGameZound=moCheckBox(Controls[11]);
	bChatLog=moCheckBox(Controls[12]);
	bChatFilter=moCheckBox(Controls[13]);
	bPlayerList=moCheckBox(Controls[14]);
	SoundDelay=moNumericEdit(Controls[15]);
	LoginDelay=moNumericEdit(Controls[16]);
	DelaysEach=moNumericEdit(Controls[17]);
	SoundsEach=moNumericEdit(Controls[18]);
	RepeatDelay=moNumericEdit(Controls[19]);
	PlayerList=GUIListBox(Controls[20]);
	Controls[1].SetFocus(None);
	bShowTrigger.Hint="Everyone sees the Triggers." $ Chr(10) $ "Only effects dedicated triggers.";
	bShowToSelf.Hint="Always show in own chat." $ Chr(10) $ "Only effects dedicated triggers.";
	bBotsTalk.Hint="Allows Bots to use Zound" $ Chr(10) $ "Mainly effects ServerBots2";
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
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	bZoundSvr.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	bShowTrigger.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	bShowToSelf.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	bAnnounce.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	Announce1.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	bBotsTalk.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	bSpecPlay.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	b24HourTime.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	bInGameZound.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	bChatLog.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	bChatFilter.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	bPlayerList.Checked(bool(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	SoundDelay.SetValue(int(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	LoginDelay.SetValue(int(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	DelaysEach.SetValue(int(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	SoundsEach.SetValue(int(sTemp));
	Param1=Mid(Param1,i + 1);
	i=InStr(Param1,",");
	sTemp=Left(Param1,i);
	RepeatDelay.SetValue(int(sTemp));
	Param1=Mid(Param1,i + 1);
	PlayerList.List.Clear();
	j=0;
JL05B1:
	if ( j < 30 )
	{
		i=InStr(Param2,",");
		sTemp=Left(Param2,i);
		if ( sTemp == "" )
		{
			goto JL062F;
		}
		Param2=Mid(Param2,i + 1);
		PlayerList.List.Add(" " $ sTemp);
		j++;
		goto JL05B1;
	}
JL062F:
	PlayerList.List.SetIndex(0);
	PlayerList.List.TextAlign=0;
	return;
}

function string GetSettings ()
{
	local string sTemp;

	sTemp="";
	if ( bZoundSvr.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	if ( bShowTrigger.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	if ( bShowToSelf.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	if ( bAnnounce.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	if ( Announce1.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	if ( bBotsTalk.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	if ( bSpecPlay.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	if ( b24HourTime.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	if ( bInGameZound.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	if ( bChatLog.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	if ( bChatFilter.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	if ( bPlayerList.IsChecked() )
	{
		sTemp=sTemp $ "1,";
	}
	else
	{
		sTemp=sTemp $ "0,";
	}
	sTemp=sTemp $ string(SoundDelay.GetValue()) $ "," $ string(LoginDelay.GetValue()) $ "," $ string(DelaysEach.GetValue()) $ "," $ string(SoundsEach.GetValue()) $ ",";
	sTemp=sTemp $ string(RepeatDelay.GetValue()) $ ",";
	return sTemp;
	return;
}

function bool OnClickBan (export editinlineuse GUIComponent Sender)
{
	local string sTemp;

	sTemp=PlayerList.List.Get();
	if ( sTemp == "" )
	{
		return False;
	}
	sTemp=Mid(sTemp,1);
	sTemp=sCode $ "ZoundBanPlayerList-" $ sTemp;
	UnknownFunction812().Player.Console.DelayedConsoleCommand("MUTATE " $ sTemp);
	return True;
	return;
}

function bool OnClickList (export editinlineuse GUIComponent Sender)
{
	local string sTemp;

	sTemp=PlayerList.List.Get();
	if ( sTemp == "" )
	{
		return False;
	}
	sTemp=Mid(sTemp,1);
	sTemp=sCode $ "ZoundAddPlayerList-" $ sTemp;
	UnknownFunction812().Player.Console.DelayedConsoleCommand("MUTATE " $ sTemp);
	return True;
	return;
}

function bool OnClickSubmit (export editinlineuse GUIComponent Sender)
{
	local string sTemp;

	sTemp=GetSettings();
	UnknownFunction812().Player.Console.DelayedConsoleCommand("MUTATE " $ sCode $ "ZoundAdminSubmit-" $ sTemp);
	Controller.CloseAll(False);
	return True;
	return;
}

function bool OnClickLogout (export editinlineuse GUIComponent Sender)
{
	UnknownFunction812().Player.Console.DelayedConsoleCommand("MUTATE ZoundLogout");
	Controller.CloseMenu(False);
	return True;
	return;
}

function bool OnClickTotal (export editinlineuse GUIComponent Sender)
{
	UnknownFunction812().Player.Console.DelayedConsoleCommand("MUTATE " $ sCode $ "DisplayTotals");
	Controller.CloseMenu(False);
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
    Controls=[0]=GUIImage'ZoundMenuAdmin.DialogBackground'
[1]=GUIButton'ZoundMenuAdmin.NoneButton'
[2]=GUILabel'ZoundMenuAdmin.MyPageHeader'
[3]=moCheckBox'ZoundMenuAdmin.Set0'
[4]=moCheckBox'ZoundMenuAdmin.Set1'
[5]=moCheckBox'ZoundMenuAdmin.Set2'
[6]=moCheckBox'ZoundMenuAdmin.Set3'
[7]=moCheckBox'ZoundMenuAdmin.Set4'
[8]=moCheckBox'ZoundMenuAdmin.Set5'
[9]=moCheckBox'ZoundMenuAdmin.Set6'
[10]=moCheckBox'ZoundMenuAdmin.Set7'
[11]=moCheckBox'ZoundMenuAdmin.Set8'
[12]=moCheckBox'ZoundMenuAdmin.Set9'
[13]=moCheckBox'ZoundMenuAdmin.Set10'
[14]=moCheckBox'ZoundMenuAdmin.Set11'
[15]=moNumericEdit'ZoundMenuAdmin.Adj1'
[16]=moNumericEdit'ZoundMenuAdmin.Adj2'
[17]=moNumericEdit'ZoundMenuAdmin.Adj3'
[18]=moNumericEdit'ZoundMenuAdmin.Adj4'
[19]=moNumericEdit'ZoundMenuAdmin.Repeat'
[20]=GUIListBox'ZoundMenuAdmin.Playlist'
[21]=GUIButton'ZoundMenuAdmin.BanButton'
[22]=GUIButton'ZoundMenuAdmin.ListButton'
[23]=GUIButton'ZoundMenuAdmin.TotalButton'
[24]=GUIButton'ZoundMenuAdmin.LogoutButton'
[25]=GUIButton'ZoundMenuAdmin.SubmitButton'
[26]=GUIButton'ZoundMenuAdmin.CloseButton'
    WinTop=0.12
    WinLeft=0.61
    WinWidth=0.34
    WinHeight=0.73
}
