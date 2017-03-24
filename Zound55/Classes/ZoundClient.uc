//================================================================================
// ZoundClient.
//================================================================================
class ZoundClient extends Interaction
	Config(ZoundClient);

struct ZCTriggers
{
	var string ServerID;
	var string MutedWords;
	var string Favourites;
};

var config bool ZoundInitial;
var config bool ZoundEnabled;
var config int ZoundMenuKey;
var config int ZoundVolume;
var string KeyBind[125];
var() config array<ZCTriggers> ZoundServer;
var() string MyServerID;
var string MesgLogon;
var string MesgBind;
var bool bShowMesg;
var bool bMesgDone;
var bool bMyInit;
var float MyTime;

function Initialized ()
{
	local string sBind;

	if (  !ZoundInitial )
	{
		Default.ZoundInitial=True;
		Default.ZoundEnabled=True;
		Default.ZoundMenuKey=35;
		Default.ZoundVolume=80;
		self.StaticSaveConfig();
	}
	SetKeyBindList();
	sBind=KeyBind[Default.ZoundMenuKey];
	MesgLogon="- This server uses Zound -";
	if ( sBind != "" )
	{
		MesgBind="- ZoundMenu Keybind on " $ sBind $ " key -";
	}
	MyTime=0.03;
	ClientLogon();
	Enable('Tick');
	bShowMesg=True;
	return;
}

function bool KeyEvent (out EInputKey Key, out EInputAction Action, float Delta)
{
	local PlayerController PLC;

	PLC=ViewportOwner.Actor;
	if ( Action != 1 )
	{
		return False;
	}
	else
	{
		if ( (Key == Default.ZoundMenuKey) && (Default.ZoundMenuKey != 0) )
		{
			PLC.ConsoleCommand("Mutate ZoundMenu");
			return True;
		}
	}
	return False;
	return;
}

function Tick (float Delta)
{
	MyTime += Delta;
	if ( (MyTime >= 3) &&  !bMyInit )
	{
		bMyInit=True;
		ClientLogon();
	}
	if ( (MyTime > 10) &&  !bMesgDone )
	{
		bMesgDone=True;
		bShowMesg=False;
	}
	if ( MyTime == 20 )
	{
		Disable('Tick');
	}
	return;
}

function ClientLogon ()
{
	local string sTemp;
	local string sMute;

	GetServerIP();
	sMute=GetMutedWords();
	if ( Len(sMute) > 199 )
	{
		sMute=Left(sMute,199);
	}
	if ( (sMute != "") && (Mid(sMute,Len(sMute) - 1) != ",") )
	{
		sMute=sMute $ ",";
	}
	if ( Default.ZoundEnabled == True )
	{
		sTemp="1,";
	}
	else
	{
		sTemp="0,";
	}
	sTemp=sTemp $ string(Default.ZoundVolume) $ ",";
	sTemp=sTemp $ sMute;
	ViewportOwner.Actor.ConsoleCommand("Mutate ZoundClientLogon-" $ sTemp);
	return;
}

function string GetMutedWords ()
{
	local string sTemp;
	local int i;
	local int j;

	j=Default.ZoundServer.Length;
	if ( j == 0 )
	{
		return "";
	}
	sTemp="";
	i=0;
JL0029:
	if ( i < j )
	{
		if ( Default.ZoundServer[i].ServerID == Default.MyServerID )
		{
			sTemp=Default.ZoundServer[i].MutedWords;
		}
		else
		{
			i++;
			goto JL0029;
		}
	}
	return sTemp;
	return;
}

function GetServerIP ()
{
	local string sTemp;
	local int i;

	sTemp=ViewportOwner.Actor.GetServerNetworkAddress();
	i=InStr(sTemp,".");
JL002E:
	if ( i != -1 )
	{
		sTemp=Left(sTemp,i) $ Mid(sTemp,i + 1);
		i=InStr(sTemp,".");
		goto JL002E;
	}
	i=InStr(sTemp,":");
	if ( i != -1 )
	{
		sTemp=Left(sTemp,i) $ Mid(sTemp,i + 1);
	}
	if ( sTemp == "" )
	{
		sTemp="Local";
	}
	Default.MyServerID=sTemp;
	return;
}

function PostRender (Canvas C)
{
	local PlayerController PLC;
	local bool bMiddle;

	PLC=ViewportOwner.Actor;
	if ( PLC == None )
	{
		return;
	}
	if ( PLC.IsInState('GameEnded') )
	{
		return;
	}
	bMiddle=C.bCenter;
	C.bCenter=True;
	if ( bShowMesg )
	{
		C.DrawColor.R=250;
		C.DrawColor.G=250;
		C.DrawColor.B=0;
		if ( C.DrawColor.A > 10 )
		{
			C.DrawColor.A=255 - 25 * MyTime;
		}
		C.Font=PLC.myHUD.GetFontSizeIndex(C,-2);
		C.SetPos(0.00,C.ClipY / 8 * 6.83);
		C.DrawText(MesgLogon);
		C.SetPos(0.00,C.ClipY / 8 * 7.05);
		C.DrawText(MesgBind);
	}
	C.bCenter=bMiddle;
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
	return;
}

function NotifyLevelChange ()
{
	bRequiresTick=False;
	Disable('Tick');
	Master.RemoveInteraction(self);
	return;
}

defaultproperties
{
    bVisible=True
    bRequiresTick=True
}
