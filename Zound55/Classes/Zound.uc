//================================================================================
// Zound.
//================================================================================
class Zound extends Mutator;

var string ZoundPass;
var bool bZound;
var bool ShowTrigger;
var bool ShowToSelf;
var bool bAnnounce;
var bool AnnounceOnce;
var bool bNoSpecPlayer;
var bool b24HourTime;
var bool InGameZound;
var bool bChatLog;
var bool bChatFilter;
var bool bPlayerList;
var bool bBotsTalk;
var int SoundDelay;
var int LoginDelay;
var int DelaysEach;
var int SoundsEach;
var int RepeatDelay;
var int TrigTimeout;
var bool bInitialized;
var int SoundTime;
var bool bHide;
var bool bDedicated;
var bool bHashID;
var bool bLoadRepln;
var bool bStartup;
var int CurrentID;
var int MySeconds;
var int ZPlayers;
var int NumTrigsA;
var int NumTrigsB;
var PlayerController ZoundController[51];
var string ZoundPlayerName[51];
var string ZoundPlayerHash[51];
var string ZoundPlayerMute[51];
var string ZoundPlayerShut[51];
var int ZoundPlayerKill[51];
var int ZoundPlayerGain[51];
var int ZoundPlayerLogID[51];
var int ZoundPlayerSound[51];
var int ZoundPlayerDelay[51];
var int ZoundPlayerTimer[51];
var string ZoundAdmin[51];
var string ZLastPlayers;
var string MySoundA[251];
var string MySoundB[251];
var string MySoundC[251];
var string MySoundD[251];
var string MySoundE[251];
var string MySoundF[251];
var string MySoundG[251];
var string MySoundH[251];
var ZoundBHandler myHandler;
var ZoundConfigs myConfigs;
var ZoundChatLog myChatLog;
var ZoundFilter myFilter;
var ZoundTriggers myTrigs;
var ZoundPlayerList myPlayList;
var ZoundPlayerBan myBanList;
var ZoundTime myTimes;
var ZoundPlayers MyPlayers;
var ZoundReplication ZRI;
var Sound SoundBuff[55];
var int PTypeBuff[55];
var string PTrigBuff[55];
var string PFromBuff[55];
var string LastZound[255];
var int LastCount[255];
var string TotPlayers[51];
var string TotTrigger[51];
var string sCode;
var Color Yellow;
var Color Cyan;

function PostBeginPlay ()
{
	local int i;

	if (  !bInitialized )
	{
		bInitialized=True;
		Log("<<< Starting Zound >>>");
		myHandler=Spawn(Class'ZoundBHandler');
		myConfigs=Spawn(Class'ZoundConfigs');
		myPlayList=Spawn(Class'ZoundPlayerList');
		myBanList=Spawn(Class'ZoundPlayerBan');
		myFilter=Spawn(Class'ZoundFilter');
		myTrigs=Spawn(Class'ZoundTriggers');
		myTimes=Spawn(Class'ZoundTime');
		myChatLog=Spawn(Class'ZoundChatLog');
		MyPlayers=Spawn(Class'ZoundPlayers');
		myConfigs.myMut=self;
		myPlayList.myMut=self;
		myBanList.myMut=self;
		myTimes.myMut=self;
		myFilter.myMut=self;
		myTrigs.myMut=self;
		myHandler.myMut=self;
		MyPlayers.myMut=self;
		ZRI=Spawn(Class'ZoundReplication');
		SoundTime=0;
		myConfigs.LoadZoundConfigs();
		MyPlayers.LoadZoundPlayers();
		myTrigs.LoadSounds();
		myTrigs.LoadNames();
		if ( Level.NetMode != 1 )
		{
			LoginDelay=1;
		}
		if ( DelaysEach < 0 )
		{
			DelaysEach=0;
		}
		if ( SoundDelay < 0 )
		{
			SoundDelay=0;
		}
		i=0;
JL01C7:
		if ( i < 50 )
		{
			ZoundPlayerName[i]="";
			ZoundPlayerHash[i]="";
			ZoundPlayerMute[i]="";
			ZoundPlayerShut[i]="";
			ZoundPlayerSound[i]=0;
			ZoundPlayerDelay[i]=0;
			ZoundPlayerTimer[i]=0;
			ZoundPlayerLogID[i]=-1;
			ZoundPlayerKill[i]=0;
			ZoundPlayerGain[i]=0;
			ZoundController[i]=None;
			ZoundAdmin[i]="";
			SoundBuff[i]=None;
			PTypeBuff[i]=0;
			PTrigBuff[i]="";
			PFromBuff[i]="";
			i++;
			goto JL01C7;
		}
		SoundBuff[50]=None;
		PTypeBuff[50]=0;
		PTrigBuff[50]="";
		PFromBuff[50]="";
		i=0;
JL02E9:
		if ( i < 255 )
		{
			LastZound[i]="";
			LastCount[i]=0;
			i++;
			goto JL02E9;
		}
		if ( TrigTimeout == 0 )
		{
			TrigTimeout=10;
		}
		if ( Level.NetMode == 0 )
		{
			TrigTimeout=10;
		}
		myTrigs.PreloadCustomSounds();
		MySeconds=0;
		bLoadRepln=True;
		bStartup=True;
		SetTimer(1.00,True);
		if ( RepeatDelay > 600 )
		{
			RepeatDelay=600;
		}
		i=Rand(900);
		if ( i < 100 )
		{
			i += 100;
		}
		sCode=string(i);
	}
	Super.PostBeginPlay();
	return;
}

function LoadReplicationInfo ()
{
	local int i;

	if ( ZRI == None )
	{
		ZRI=Spawn(Class'ZoundReplication');
	}
	i=0;
JL0020:
	if ( i < 250 )
	{
		ZRI.SoundA[i]=MySoundA[i];
		i++;
		goto JL0020;
	}
	i=0;
JL005D:
	if ( i < 250 )
	{
		ZRI.SoundB[i]=MySoundB[i];
		i++;
		goto JL005D;
	}
	i=0;
JL009A:
	if ( i < 250 )
	{
		ZRI.SoundC[i]=MySoundC[i];
		i++;
		goto JL009A;
	}
	i=0;
JL00D7:
	if ( i < 250 )
	{
		ZRI.SoundD[i]=MySoundD[i];
		i++;
		goto JL00D7;
	}
	i=0;
JL0114:
	if ( i < 250 )
	{
		ZRI.SoundE[i]=MySoundE[i];
		i++;
		goto JL0114;
	}
	i=0;
JL0151:
	if ( i < 250 )
	{
		ZRI.SoundF[i]=MySoundF[i];
		i++;
		goto JL0151;
	}
	i=0;
JL018E:
	if ( i < 250 )
	{
		ZRI.SoundG[i]=MySoundG[i];
		i++;
		goto JL018E;
	}
	i=0;
JL01CB:
	if ( i < 250 )
	{
		ZRI.SoundH[i]=MySoundH[i];
		i++;
		goto JL01CB;
	}
	ZRI.Dummy++;
	return;
}

function ModifyPlayer (Pawn Other)
{
	local Controller C;

	C=Other.Controller;
	if ( (C != None) && (C.PlayerReplicationInfo != None) )
	{
		if (  !C.PlayerReplicationInfo.bBot && bStartup )
		{
			bStartup=False;
			MySeconds=0;
		}
	}
	Super.ModifyPlayer(Other);
	return;
}

function SetClientClass (PlayerController PC)
{
	local ZoundSpawn ZSRI;

	if ( PC == None )
	{
		return;
	}
	foreach DynamicActors(Class'ZoundSpawn',ZSRI)
	{
		if ( PC == ZSRI.Owner )
		{
			ZSRI.Destroy();
		}
	}
	ZSRI=Spawn(Class'ZoundSpawn',PC);
	ZSRI.PLC=PC;
	ZSRI.Dummy++;
	Log(GetDateTime(True) $ " SetClientClass for: " $ PC.PlayerReplicationInfo.PlayerName,'Zound');
	return;
}

function CenterMessage (PlayerController Sender, string Mesg, Color cColr, int Time)
{
	if ( Sender != None )
	{
		if ( myBanList.CheckBanList(Sender) )
		{
			return;
		}
		Sender.ClearProgressMessages();
		if ( Mesg != " " )
		{
			Sender.SetProgressTime(Time);
			Sender.SetProgressMessage(0,Mesg,cColr);
		}
	}
	return;
}

function Tick (float DeltaTime)
{
	local Controller C;

	Super.Tick(DeltaTime);
	if ( Level.Game.NumPlayers != ZPlayers )
	{
		ZPlayers=Level.Game.NumPlayers;
		LoadRepPlayers();
	}
	if ( Level.Game.CurrentID > CurrentID )
	{
		C=Level.ControllerList;
JL0084:
		if ( C != None )
		{
			if ( (C != None) && (C.PlayerReplicationInfo != None) )
			{
				if ( C.PlayerReplicationInfo.PlayerID == CurrentID )
				{
					goto JL00EB;
				}
			}
			C=C.nextController;
			goto JL0084;
		}
JL00EB:
		CurrentID++;
		if ( (C != None) && (C.PlayerReplicationInfo != None) )
		{
			if ( C.PlayerReplicationInfo.bBot )
			{
				return;
			}
			if ( C.IsA('PlayerController') )
			{
				if ( MessagingSpectator(C) == None )
				{
					SetClientClass(PlayerController(C));
				}
			}
		}
	}
	return;
}

function LoadRepPlayers ()
{
	local Controller C;
	local int X;

	X=0;
JL0007:
	if ( X < 32 )
	{
		ZRI.Players[X]="";
		X++;
		goto JL0007;
	}
	X=0;
	C=Level.ControllerList;
JL004F:
	if ( C != None )
	{
		if ( C.IsA('PlayerController') && (MessagingSpectator(C) == None) && (C.PlayerReplicationInfo.PlayerName != "WebAdmin") )
		{
			if (  !C.PlayerReplicationInfo.bOnlySpectator && (C.PlayerReplicationInfo.PlayerName != "DemoRecSpectator") )
			{
				ZRI.Players[X]=C.PlayerReplicationInfo.PlayerName;
				X++;
			}
		}
		C=C.nextController;
		goto JL004F;
	}
	ZRI.Dummy++;
	return;
}

function bool CheckForNoZound (PlayerController PC)
{
	local string sNick;
	local int i;

	if ( PC == None )
	{
		return False;
	}
	sNick=PC.PlayerReplicationInfo.PlayerName;
	i=0;
JL0031:
	if ( i < 50 )
	{
		if ( ZoundPlayerName[i] == sNick )
		{
			if ( ZoundPlayerKill[i] == 0 )
			{
				return True;
			}
			else
			{
				return False;
			}
		}
		i++;
		goto JL0031;
	}
	return False;
	return;
}

function SetupMuted (PlayerController PC, string sMute, bool bPlayer)
{
	local string sTemp;
	local string sNick;
	local int i;

	if ( PC == None )
	{
		return;
	}
	sNick=PC.PlayerReplicationInfo.PlayerName;
	sTemp="";
	i=0;
JL0039:
	if ( i < 50 )
	{
		if ( ZoundPlayerName[i] == sNick )
		{
			if ( bPlayer )
			{
				if ( sMute == "None" )
				{
					sMute="";
				}
				ZoundPlayerShut[i]=sMute;
				return;
			}
			if ( sMute != "" )
			{
				sTemp=Mid(sMute,Len(sMute) - 1);
				if ( sTemp != "," )
				{
					sMute=sMute $ ",";
				}
				ZoundPlayerMute[i]=sMute;
				return;
			}
		}
		i++;
		goto JL0039;
	}
	return;
}

function bool CheckMuted (PlayerController PC, string sTrig, string sWho)
{
	local string sTemp;
	local string sNick;
	local int i;

	if ( PC == None )
	{
		return True;
	}
	if ( sTrig == "" )
	{
		return False;
	}
	sNick=PC.PlayerReplicationInfo.PlayerName;
	i=0;
JL003F:
	if ( i < 50 )
	{
		if ( ZoundPlayerName[i] == sNick )
		{
			sTemp=ZoundPlayerMute[i];
			if ( InStr(sTemp,sTrig $ ",") != -1 )
			{
				return True;
			}
			if ( (ZoundPlayerShut[i] != "") && (ZoundPlayerShut[i] == sWho) )
			{
				return True;
			}
		}
		else
		{
			i++;
			goto JL003F;
		}
	}
	return False;
	return;
}

function int GetClientGain (PlayerController PC)
{
	local string sNick;
	local int i;

	if ( PC == None )
	{
		return 0;
	}
	sNick=PC.PlayerReplicationInfo.PlayerName;
	i=0;
JL0031:
	if ( i < 50 )
	{
		if ( ZoundPlayerName[i] == sNick )
		{
			return ZoundPlayerGain[i];
		}
		i++;
		goto JL0031;
	}
	return 0;
	return;
}

function Timer ()
{
	local Sound MySound;
	local string sTemp;
	local float MyGain;
	local int i;
	local int j;

	Super.Timer();
	MySeconds++;
	if ( (MySeconds >= 3) && bLoadRepln )
	{
		bLoadRepln=False;
		LoadReplicationInfo();
		MySeconds=0;
	}
	if ( SoundTime > 0 )
	{
		SoundTime--;
	}
	if ( (SoundTime == 0) && (SoundBuff[0] != None) )
	{
		BroadcastSound(SoundBuff[0],PTypeBuff[0],PTrigBuff[0],PFromBuff[0]);
		i=0;
JL008E:
		if ( i < 51 )
		{
			SoundBuff[i]=SoundBuff[i + 1];
			PTypeBuff[i]=PTypeBuff[i + 1];
			PTrigBuff[i]=PTrigBuff[i + 1];
			PFromBuff[i]=PFromBuff[i + 1];
			i++;
			goto JL008E;
		}
	}
	i=0;
JL0113:
	if ( i < 50 )
	{
		if ( ZoundPlayerDelay[i] > 0 )
		{
			ZoundPlayerDelay[i]--;
		}
		if ( ZoundPlayerTimer[i] > 0 )
		{
			ZoundPlayerTimer[i]--;
			if ( ZoundPlayerTimer[i] == 0 )
			{
				if (  !myBanList.CheckBanList(ZoundController[i]) )
				{
					if ( CheckForNoZound(ZoundController[i]) )
					{
						ZoundController[i].ClientMessage("< Zound is Disabled >");
					}
					else
					{
						ZoundController[i].ClientMessage("< Zound is Enabled >");
						if ( bAnnounce )
						{
							j=-1;
							if ( AnnounceOnce )
							{
								j=InStr(ZLastPlayers,ZoundPlayerName[i]);
							}
							if ( j == -1 )
							{
								sTemp=ZoundPlayerName[i];
								MySound=GetCustomSound(sTemp,ZoundController[i],False,True);
								if ( MySound == None )
								{
									sTemp="PlayerEnter";
									MySound=GetCustomSound(sTemp,ZoundController[i],False,True);
								}
							}
							if ( MySound != None )
							{
								if (  !CheckMuted(ZoundController[i],sTemp,"") )
								{
									MyGain=GetMyVolume(ZoundController[i]);
									ZoundController[i].ClientPlaySound(MySound,True,MyGain);
								}
							}
						}
					}
				}
			}
		}
		i++;
		goto JL0113;
	}
	i=0;
JL0318:
	if ( i < 255 )
	{
		if ( LastZound[i] != "" )
		{
			LastCount[i]--;
			if ( LastCount[i] <= 0 )
			{
				LastZound[i]="";
				LastCount[i]=0;
			}
		}
		i++;
		goto JL0318;
	}
	return;
}

function AddToSoundBuff (Sound MySound, int PL, string sTrig, string sNick)
{
	local int j;

	j=0;
JL0007:
	if ( j < 50 )
	{
		if ( SoundBuff[j] == None )
		{
			SoundBuff[j]=MySound;
			PTypeBuff[j]=PL;
			PTrigBuff[j]=sTrig;
			PFromBuff[j]=sNick;
		}
		else
		{
			j++;
			goto JL0007;
		}
	}
	return;
}

function BroadcastSound (Sound MySound, optional int iNum, optional string sTrig, optional string FromWho)
{
	local Controller C;
	local float MyGain;

	if ( SoundTime > 0 )
	{
		return;
	}
	if (  !bZound )
	{
		return;
	}
	if (  !InGameZound &&  !Level.Game.bGameEnded &&  !Level.Game.bWaitingToStartMatch )
	{
		return;
	}
	if ( MySound == None )
	{
		return;
	}
	SoundTime=SoundDelay;
	C=Level.ControllerList;
JL0091:
	if ( C != None )
	{
		if ( (C != None) && C.IsA('PlayerController') &&  !C.PlayerReplicationInfo.bBot )
		{
			if ( myPlayList.CheckPlayerList(PlayerController(C),False) || CheckZoundAdmin(PlayerController(C)) )
			{
				if (  !CheckForNoZound(PlayerController(C)) )
				{
					if (  !CheckMuted(PlayerController(C),sTrig,FromWho) )
					{
						MyGain=GetMyVolume(PlayerController(C));
						if ( bNoSpecPlayer && (iNum == 1) )
						{
							if ( C.PlayerReplicationInfo.bOnlySpectator )
							{
								PlayerController(C).ClientPlaySound(MySound,True,MyGain);
							}
						}
						else
						{
							if ( bNoSpecPlayer && (iNum == 2) )
							{
								if (  !C.PlayerReplicationInfo.bOnlySpectator )
								{
									PlayerController(C).ClientPlaySound(MySound,True,MyGain);
								}
							}
							else
							{
								PlayerController(C).ClientPlaySound(MySound,True,MyGain);
							}
						}
					}
				}
			}
		}
		C=C.nextController;
		goto JL0091;
	}
	return;
}

function float GetMyVolume (PlayerController Sender)
{
	local int Gn;
	local float fVol;

	Gn=GetClientGain(Sender);
	if ( Gn == 0 )
	{
		return 0.00;
	}
	fVol=Gn;
	fVol=fVol / 100;
	return 2.00 * fVol;
	return;
}

function Sound GetCustomSound (string CustomSound, Controller Sender, bool bInGame, optional bool bDedicated)
{
	local Sound LoadSound;

	if (  !CheckInGameZound(Sender) )
	{
		return None;
	}
	if ( Len(CustomSound) < 2 )
	{
		return None;
	}
	if ( Sender != None )
	{
		if (  !myPlayList.CheckPlayerList(PlayerController(Sender),False) &&  !CheckZoundAdmin(PlayerController(Sender)) )
		{
			return None;
		}
	}
	LoadSound=myTrigs.GetCustomSound(CustomSound,Sender,bInGame,bDedicated);
	if ( LoadSound != None )
	{
		return LoadSound;
	}
	return None;
	return;
}

function DoChatLog (Controller Who, string Cmd)
{
	local string sTemp;
	local string sNick;
	local string DateTime;
	local int i;

	if ( Who.PlayerReplicationInfo.bBot )
	{
		return;
	}
	sTemp="                ";
	DateTime=GetDateTime(False);
	sNick=Who.PlayerReplicationInfo.PlayerName;
	i=Len(sNick);
	if ( i < 16 )
	{
		sNick=sNick $ Mid(sTemp,i);
	}
	else
	{
		sNick=Left(sNick,16);
	}
	myChatLog.WriteChatLog(DateTime $ " - " $ sNick $ " : " $ Cmd);
	return;
}

function string GetDateTime (bool bTimeOnly)
{
	local string AbsoluteTime;

	if (  !bTimeOnly )
	{
		AbsoluteTime=string(Level.Year);
		if ( Level.Month < 10 )
		{
			AbsoluteTime=AbsoluteTime $ "/0" $ string(Level.Month);
		}
		else
		{
			AbsoluteTime=AbsoluteTime $ "/" $ string(Level.Month);
		}
		if ( Level.Day < 10 )
		{
			AbsoluteTime=AbsoluteTime $ "/0" $ string(Level.Day);
		}
		else
		{
			AbsoluteTime=AbsoluteTime $ "/" $ string(Level.Day);
		}
		AbsoluteTime=AbsoluteTime $ " - ";
	}
	if ( Level.Hour < 10 )
	{
		AbsoluteTime=AbsoluteTime $ "0" $ string(Level.Hour);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ string(Level.Hour);
	}
	if ( Level.Minute < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ":0" $ string(Level.Minute);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ ":" $ string(Level.Minute);
	}
	if ( Level.Second < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ":0" $ string(Level.Second);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ ":" $ string(Level.Second);
	}
	if ( Level.Millisecond < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ":00" $ string(Level.Millisecond);
	}
	else
	{
		if ( Level.Millisecond < 100 )
		{
			AbsoluteTime=AbsoluteTime $ ":0" $ string(Level.Millisecond);
		}
		else
		{
			AbsoluteTime=AbsoluteTime $ ":" $ string(Level.Millisecond);
		}
	}
	return AbsoluteTime;
	return;
}

function OpenZoundMenu (PlayerController Sender)
{
	local string Param1;
	local string Param2;
	local string sNick;
	local string MPlayer;
	local bool bAdmin;
	local int i;
	local int S;

	if ( CheckZoundAdmin(Sender) )
	{
		bAdmin=True;
	}
	if (  !bZound &&  !bAdmin )
	{
		return;
	}
	if (  !bAdmin && myBanList.CheckBanList(Sender) )
	{
		Sender.ClientMessage("< You have been banned from using Zound! >");
		return;
	}
	sNick=Sender.PlayerReplicationInfo.PlayerName;
	if ( bStartup )
	{
		bStartup=False;
		if ( Level.Game.bWaitingToStartMatch )
		{
			MySeconds=0;
			Log(GetDateTime(True) $ " OpenZoundMenu - Started Replication Timer by " $ sNick,'Zound');
		}
	}
	if (  !myPlayList.CheckPlayerList(Sender,False) &&  !CheckZoundAdmin(Sender) )
	{
		return;
	}
	Param1=sCode $ ",";
	if ( CheckZoundAdmin(Sender) )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	if ( CheckForNoZound(Sender) )
	{
		Param1=Param1 $ "0,";
	}
	else
	{
		Param1=Param1 $ "1,";
	}
	if ( MySeconds < TrigTimeout )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	Param1=Param1 $ string(NumTrigsA) $ "," $ string(NumTrigsB) $ ",";
	S=9999;
	i=0;
JL0239:
	if ( i < 50 )
	{
		if ( ZoundPlayerName[i] == sNick )
		{
			MPlayer=ZoundPlayerShut[i];
			if ( MPlayer == "" )
			{
				MPlayer="None";
			}
			if (  !bAdmin && (SoundsEach != 0) )
			{
				S=SoundsEach - ZoundPlayerSound[i];
			}
			if ( S < 0 )
			{
				S=0;
			}
		}
		else
		{
			i++;
			goto JL0239;
		}
	}
	Param2=MPlayer $ "," $ string(S) $ ",";
	Sender.ClientOpenMenu("Zound55.ZoundMenuTrigs",False,Param1,Param2);
	return;
}

function OpenAdminMenu (PlayerController Sender)
{
	local string Param1;
	local string Param2;
	local Controller C;
	local bool bAdmin;

	if ( Sender == None )
	{
		return;
	}
	if (  !CheckZoundAdmin(Sender) )
	{
		return;
	}
	bAdmin=True;
	Param1=sCode $ ",";
	if ( bZound )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	if ( ShowTrigger )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	if ( ShowToSelf )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	if ( bAnnounce )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	if ( AnnounceOnce )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	if ( bBotsTalk )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	if ( bNoSpecPlayer )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	if ( b24HourTime )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	if ( InGameZound )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	if ( bChatLog )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	if ( bChatFilter )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	if ( bPlayerList )
	{
		Param1=Param1 $ "1,";
	}
	else
	{
		Param1=Param1 $ "0,";
	}
	Param1=Param1 $ string(SoundDelay) $ "," $ string(LoginDelay) $ "," $ string(DelaysEach) $ "," $ string(SoundsEach) $ "," $ string(RepeatDelay) $ ",";
	Param2="";
	C=Level.ControllerList;
JL02CC:
	if ( C != None )
	{
		if ( C.IsA('PlayerController') && (MessagingSpectator(C) == None) && (C.PlayerReplicationInfo.PlayerName != "WebAdmin") && (C.PlayerReplicationInfo.PlayerName != "DemoRecSpectator") )
		{
			Param2=Param2 $ C.PlayerReplicationInfo.PlayerName $ ",";
			if ( Len(Param1) + Len(Param2) > 420 )
			{
				goto JL03B2;
			}
		}
		C=C.nextController;
		goto JL02CC;
	}
JL03B2:
	Sender.ClientOpenMenu("Zound55.ZoundMenuAdmin",False,Param1,Param2);
	return;
}

function AdminSubmit (PlayerController Sender, string Options)
{
	local string sTemp;
	local int i;

	i=InStr(Options,",");
	sTemp=Left(Options,i);
	bZound=bool(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	ShowTrigger=bool(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	ShowToSelf=bool(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	bAnnounce=bool(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	AnnounceOnce=bool(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	bBotsTalk=bool(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	bNoSpecPlayer=bool(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	b24HourTime=bool(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	InGameZound=bool(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	if ( bChatLog && (sTemp == "0") )
	{
		myChatLog.CloseChatLog();
	}
	bChatLog=bool(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	bChatFilter=bool(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	bPlayerList=bool(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	SoundDelay=int(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	LoginDelay=int(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	DelaysEach=int(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	SoundsEach=int(sTemp);
	Options=Mid(Options,i + 1);
	i=InStr(Options,",");
	sTemp=Left(Options,i);
	RepeatDelay=int(sTemp);
	Options=Mid(Options,i + 1);
	myConfigs.SaveZoundConfigs();
	return;
}

function Mutate (string MutateString, PlayerController Sender)
{
	local string sTemp;
	local string sNick;
	local bool bDone;

	if ( Sender == None )
	{
		return;
	}
	if ( (MutateString ~= "Zound On") || (MutateString ~= "Zound Off") || (MutateString ~= "Zound OnOff") )
	{
		CheckZoundPlayer(Sender,"0,80,",True);
		return;
	}
	if ( (Left(MutateString,9) ~= "ZoundMenu") || (MutateString ~= "Zounds") )
	{
		sTemp=Mid(MutateString,10);
		if ( sTemp != "" )
		{
			if ( (ZoundPass != "") && (Caps(ZoundPass) != "NONE") )
			{
				if ( (Mid(MutateString,10) == ZoundPass) &&  !CheckZoundAdmin(Sender) )
				{
					AddRemoveZoundAdmin(Sender,True);
					Sender.ClientMessage("< You have logged in as Zound Admin >");
				}
				else
				{
					AddRemoveZoundAdmin(Sender,False);
					Sender.ClientMessage("< You have logged out as Zound Admin >");
					Sender.ConsoleCommand("AdminLogout");
				}
			}
		}
		OpenZoundMenu(Sender);
	}
	if ( MutateString ~= "ZoundLogout" )
	{
		if ( CheckZoundAdmin(Sender) )
		{
			AddRemoveZoundAdmin(Sender,False);
			Sender.ClientMessage("< You have logged out as Zound Admin >");
			Sender.ConsoleCommand("AdminLogout");
		}
	}
	if ( Left(MutateString,17) == "ZoundClientLogon-" )
	{
		CheckZoundPlayer(Sender,Mid(MutateString,17));
		return;
	}
	if ( Left(MutateString,10) ~= "ZoundLogin" )
	{
		if ( (ZoundPass != "") && (Caps(ZoundPass) != "NONE") )
		{
			if ( (Mid(MutateString,11) == ZoundPass) &&  !CheckZoundAdmin(Sender) )
			{
				AddRemoveZoundAdmin(Sender,True);
				Sender.ClientMessage("< You have logged in as Zound Admin >");
			}
			else
			{
				AddRemoveZoundAdmin(Sender,False);
				Sender.ClientMessage("< You have logged out as Zound Admin >");
				Sender.ConsoleCommand("AdminLogout");
			}
		}
	}
	if ( Left(MutateString,3) == sCode )
	{
		sTemp=Mid(MutateString,3);
		if ( sTemp == "ZoundAdminMenu" )
		{
			OpenAdminMenu(Sender);
			return;
		}
		if ( Left(sTemp,18) == "ZoundClientSubmit-" )
		{
			CheckZoundPlayer(Sender,Mid(sTemp,18));
			return;
		}
		if ( Left(sTemp,16) == "ZoundClientMute-" )
		{
			SetupMuted(Sender,Mid(sTemp,16),False);
			return;
		}
		if ( Left(sTemp,22) == "ZoundClientMutePlayer-" )
		{
			SetupMuted(Sender,Mid(sTemp,22),True);
			return;
		}
		if ( sTemp == "DisplayTotals" )
		{
			GetPlayerTrigs(Sender);
			return;
		}
		if ( Left(sTemp,17) == "ZoundAdminSubmit-" )
		{
			AdminSubmit(Sender,Mid(sTemp,17));
			return;
		}
		if ( Left(sTemp,19) == "ZoundAddPlayerList-" )
		{
			sNick=Mid(sTemp,19);
			bDone=myPlayList.AddRemovePlayer(sNick);
			if ( bDone )
			{
				sTemp="< " $ sNick $ " was added to the PlayerList >";
			}
			else
			{
				sTemp="< " $ sNick $ " was removed from the PlayerList >";
			}
			Sender.ClientMessage(sTemp);
			Log(GetDateTime(False) $ " " $ sTemp,'Zound');
			return;
		}
		if ( Left(sTemp,19) == "ZoundBanPlayerList-" )
		{
			sNick=Mid(sTemp,19);
			bDone=myBanList.AddRemoveBan(sNick);
			if ( bDone )
			{
				sTemp="< " $ sNick $ " is now banned from using Zound >";
				CheckZoundPlayer(GetSender(sNick),"0,0,");
			}
			else
			{
				sTemp="< " $ sNick $ " was removed from the Banned List >";
				CheckZoundPlayer(GetSender(sNick),"1,80,");
			}
			Sender.ClientMessage(sTemp);
			Log(GetDateTime(False) $ " " $ sTemp,'Zound');
			return;
		}
	}
	if ( NextMutator != None )
	{
		NextMutator.Mutate(MutateString,Sender);
	}
	return;
}

function PlayerController GetSender (string sNick)
{
	local Controller C;

	C=Level.ControllerList;
JL0014:
	if ( C != None )
	{
		if ( C.PlayerReplicationInfo.PlayerName ~= sNick )
		{
			return PlayerController(C);
		}
		C=C.nextController;
		goto JL0014;
	}
	return None;
	return;
}

function CheckZoundPlayer (PlayerController Sender, string sMesg, optional bool bMutate)
{
	local string sNick;
	local int i;
	local int k;
	local int iZnd;
	local int iVol;

	sNick=Sender.PlayerReplicationInfo.PlayerName;
	i=InStr(sMesg,",");
	iZnd=int(Left(sMesg,i));
	sMesg=Mid(sMesg,i + 1);
	i=InStr(sMesg,",");
	iVol=int(Left(sMesg,i));
	sMesg=Mid(sMesg,i + 1);
	i=0;
JL0096:
	if ( i < 50 )
	{
		if ( ZoundPlayerName[i] == sNick )
		{
			if ( bMutate )
			{
				k=ZoundPlayerKill[i];
				k=k + 1;
				if ( k > 1 )
				{
					k=0;
				}
				ZoundPlayerKill[i]=k;
				if ( k == 0 )
				{
					Sender.ClientMessage("< Your Zound is disabled on this level >");
				}
				else
				{
					Sender.ClientMessage("< Your Zound is enabled on this level >");
				}
				return;
			}
			ZoundPlayerKill[i]=iZnd;
			ZoundPlayerGain[i]=iVol;
			ZoundController[i]=Sender;
			ZoundPlayerHash[i]=Sender.GetPlayerIDHash();
			ZoundPlayerLogID[i]=Sender.PlayerReplicationInfo.PlayerID;
			return;
		}
		i++;
		goto JL0096;
	}
	if ( bMutate )
	{
		return;
	}
	i=0;
JL0212:
	if ( i < 50 )
	{
		if ( ZoundPlayerName[i] == "" )
		{
			ZoundPlayerName[i]=sNick;
			ZoundPlayerKill[i]=iZnd;
			ZoundPlayerGain[i]=iVol;
			ZoundController[i]=Sender;
			ZoundPlayerHash[i]=Sender.GetPlayerIDHash();
			ZoundPlayerLogID[i]=Sender.PlayerReplicationInfo.PlayerID;
			ZoundPlayerTimer[i]=LoginDelay;
			ZoundPlayerSound[i]=0;
			ZoundPlayerDelay[i]=0;
		}
		else
		{
			i++;
			goto JL0212;
		}
	}
	if ( Len(sMesg) > 3 )
	{
		SetupMuted(Sender,sMesg,False);
	}
	return;
}

function ModifyLogin (out string Portal, out string Options)
{
	Log(GetDateTime(True) $ " Zound PlayerLogin: " $ Options,'Zound');
	if ( NextMutator != None )
	{
		NextMutator.ModifyLogin(Portal,Options);
	}
	return;
}

function NotifyLogout (Controller Exiting)
{
	local string sTemp;
	local Sound MySound;

	if ( bAnnounce &&  !Level.Game.bGameEnded &&  !Exiting.PlayerReplicationInfo.bBot )
	{
		sTemp="PlayerExit";
		MySound=GetCustomSound(sTemp,None,False,True);
		if ( MySound != None )
		{
			AddToSoundBuff(MySound,3,sTemp,"");
		}
	}
	if ( NextMutator != None )
	{
		NextMutator.NotifyLogout(Exiting);
	}
	return;
}

function string GetPlayerIDType (PlayerController Sender)
{
	if ( Class'MasterServerUplink'.Default.DoUplink )
	{
		bHashID=True;
		return Sender.GetPlayerIDHash();
	}
	else
	{
		bHashID=False;
		return string(Sender.PlayerReplicationInfo.PlayerID);
	}
	return;
}

function bool AllowSayTrig (string sSound, bool IsAdmin)
{
	local int i;

	if ( (RepeatDelay == 0) || IsAdmin )
	{
		return True;
	}
	i=0;
JL001F:
	if ( i < 255 )
	{
		if ( LastZound[i] == sSound )
		{
			return False;
		}
		i++;
		goto JL001F;
	}
	i=0;
JL0053:
	if ( i < 255 )
	{
		if ( LastZound[i] == "" )
		{
			LastZound[i]=sSound;
			LastCount[i]=RepeatDelay;
			return True;
		}
		i++;
		goto JL0053;
	}
	return True;
	return;
}

function bool CheckZoundAdmin (PlayerController Sender)
{
	local string sTemp;
	local int i;

	if ( (Sender == None) || (Sender.PlayerReplicationInfo == None) )
	{
		return False;
	}
	sTemp=Sender.PlayerReplicationInfo.PlayerName;
	i=0;
JL0047:
	if ( i < 50 )
	{
		if ( ZoundAdmin[i] == sTemp )
		{
			return True;
		}
		i++;
		goto JL0047;
	}
	if ( Sender.PlayerReplicationInfo.bAdmin )
	{
		return True;
	}
	else
	{
		return False;
	}
	return;
}

function AddRemoveZoundAdmin (PlayerController Sender, bool bAdd)
{
	local string sTemp;
	local int i;

	if ( (Sender == None) || (Sender.PlayerReplicationInfo == None) )
	{
		return;
	}
	sTemp=Sender.PlayerReplicationInfo.PlayerName;
	i=0;
JL0047:
	if ( i < 50 )
	{
		if ( bAdd )
		{
			if ( (ZoundAdmin[i] == "") || (ZoundAdmin[i] == sTemp) )
			{
				ZoundAdmin[i]=sTemp;
				return;
			}
		}
		else
		{
			if ( ZoundAdmin[i] == sTemp )
			{
				ZoundAdmin[i]="";
				return;
			}
		}
		i++;
		goto JL0047;
	}
	return;
}

function SetPlayerTrigs (string sNick, string sTrig)
{
	local int i;

	i=0;
JL0007:
	if ( i < 50 )
	{
		if ( TotPlayers[i] == sNick )
		{
			TotTrigger[i]=TotTrigger[i] $ sTrig $ ",";
		}
		else
		{
			if ( TotPlayers[i] == "" )
			{
				TotPlayers[i]=sNick;
				TotTrigger[i]=sTrig $ ",";
			}
			else
			{
				i++;
				goto JL0007;
			}
		}
	}
	return;
}

function GetPlayerTrigs (PlayerController Sender)
{
	local string Param1;
	local string Param2;
	local bool bAdmin;
	local int i;

	bAdmin=CheckZoundAdmin(Sender);
	if (  !bAdmin )
	{
		return;
	}
	Param1=sCode $ ",";
	Param2="";
	i=0;
JL003E:
	if ( i < 50 )
	{
		if ( TotPlayers[i] != "" )
		{
			Param1=Param1 $ TotPlayers[i] $ ",";
			Param2=Param2 $ TotTrigger[i] $ "~";
		}
		if ( Len(Param1) + Len(Param2) > 440 )
		{
			goto JL00BD;
		}
		i++;
		goto JL003E;
	}
JL00BD:
	Sender.ClientOpenMenu("Zound55.ZoundMenuHist",False,Param1,Param2);
	return;
}

function string CheckOutTrigger (string sTrig)
{
	local string sTemp;
	local int i;

	sTemp=sTrig;
	i=1;
JL0012:
	if ( i < 50 )
	{
		if ( Left(sTemp,1) == " " )
		{
			sTemp=Mid(sTemp,1);
		}
		i++;
		goto JL0012;
	}
	i=InStr(sTemp,"  ");
JL0057:
	if ( i != -1 )
	{
		sTemp=Left(sTemp,i) $ Mid(sTemp,i + 1);
		i=InStr(sTemp,"  ");
		goto JL0057;
	}
	if ( (sTemp != "") && (Mid(sTemp,Len(sTemp) - 1) == " ") )
	{
		if ( Mid(sTemp,Len(sTemp)) == "" )
		{
			if ( InStr(sTemp," ") == -1 )
			{
				sTemp=Left(sTemp,Len(sTemp) - 1);
			}
		}
	}
	return sTemp;
	return;
}

function string ChatHandler (Controller Who, string Cmd, Controller ToWho)
{
	local string sTemp;
	local string sTemp2;
	local string sTemp3;
	local string sComd;
	local string sTrig;
	local string sLog;
	local Sound MySound;
	local bool IsAdmin;
	local bool bWhoToWho;
	local bool bMeOnly;
	local int i;
	local int j;
	local int PL;

	sTrig=Cmd;
	sLog=Cmd;
	bHide=False;
	bDedicated=False;
	if ( ToWho.PlayerReplicationInfo.PlayerName ~= "WebAdmin" )
	{
		return Cmd;
	}
	if ( Who == ToWho )
	{
		bWhoToWho=True;
	}
	IsAdmin=CheckZoundAdmin(PlayerController(Who));
	if ( Who.IsA('PlayerController') && Who.PlayerReplicationInfo.bOnlySpectator )
	{
		PL=1;
	}
	else
	{
		PL=2;
	}
	sTrig=CheckOutTrigger(sTrig);
	if ( bChatFilter || bChatLog )
	{
		sTemp=Cmd;
		if ( bChatFilter )
		{
			sTemp=myFilter.FilterString(Who,Cmd);
		}
		if ( bChatLog && (Who == ToWho) )
		{
			DoChatLog(Who,sTemp);
		}
		Cmd=sTemp;
	}
	if ( Left(sTrig,1) == "~" )
	{
		bMeOnly=True;
		sTrig=Mid(sTrig,1);
	}
	if ( sTrig ~= "time?" )
	{
		sTrig="?time";
	}
	j=InStr(Caps(Cmd),"?TIME");
	if ( j != -1 )
	{
		sTrig="?time";
	}
	if ( sTrig ~= "?time" )
	{
		if ( Who == ToWho )
		{
			myTimes.SpeakTheTime(PlayerController(Who));
			SetPlayerTrigs(Who.PlayerReplicationInfo.PlayerName,sTrig);
		}
		return "";
	}
	else
	{
		if (  !IsAdmin &&  !myPlayList.CheckPlayerList(PlayerController(Who),False) )
		{
			return Cmd;
		}
		if (  !IsAdmin )
		{
			if ( (sTrig ~= "PlayerEnter") || (sTrig ~= "PlayerExit") )
			{
				return Cmd;
			}
		}
		if ( Who == ToWho )
		{
			if (  !myBanList.CheckBanList(PlayerController(Who)) )
			{
				MySound=GetCustomSound(sTrig,Who,True);
			}
			if ( bMeOnly && (MySound != None) )
			{
				PlayerController(Who).ClientPlaySound(MySound,True,GetMyVolume(PlayerController(Who)));
			}
		}
		else
		{
			MySound=None;
		}
	}
	if ( bMeOnly )
	{
		return "";
	}
	if (  !IsAdmin &&  !InGameZound &&  !Level.Game.bGameEnded &&  !Level.Game.bWaitingToStartMatch )
	{
		return Cmd;
	}
	if (  !Who.PlayerReplicationInfo.bBot )
	{
		sTrig=myTrigs.GetTriggerWord(Cmd,False,IsAdmin);
		if ( sTrig == "" )
		{
			return Cmd;
		}
		if ( myBanList.CheckBanList(PlayerController(Who)) )
		{
			if ( sTrig ~= Cmd )
			{
				Cmd="";
			}
			return Cmd;
		}
		i=InStr(Caps(Cmd),Caps(sTrig));
		if ( i != -1 )
		{
			sComd=Cmd;
			if ( (Who != ToWho) && bHide )
			{
				sTemp=Caps(sTrig);
				sTemp2=Caps(sTrig) $ " ";
				sTemp3=Caps(sTrig) $ "  ";
				if ( Caps(Cmd) ~= Caps(sTrig) )
				{
					sComd="";
				}
				if ( (Caps(Cmd) == sTemp2) || (Caps(Cmd) == sTemp3) )
				{
					sComd="";
				}
			}
			else
			{
				if (  !ShowToSelf &&  !ShowTrigger && (Who == ToWho) && bDedicated )
				{
					sComd="";
				}
			}
			Cmd=sComd;
		}
		bHide=False;
		sTemp=GetPlayerIDType(PlayerController(Who));
		if ( (MySound != None) &&  !AllowSayTrig(sTrig,IsAdmin) )
		{
			return Cmd;
		}
		if ( MySound != None )
		{
			i=0;
JL057E:
			if ( i < 50 )
			{
				if (  !IsAdmin && bHashID && (ZoundPlayerHash[i] == sTemp) ||  !bHashID && (string(ZoundPlayerLogID[i]) == sTemp) )
				{
					if ( (ZoundPlayerSound[i] >= SoundsEach) && (SoundsEach != 0) )
					{
						PlayerController(Who).ClientMessage("< Only " $ string(SoundsEach) $ " Zound Triggers allowed per Player >");
						if ( (Caps(sTrig) == Caps(Cmd)) && bDedicated )
						{
							return "";
						}
						else
						{
							return Cmd;
						}
					}
					else
					{
						if ( ZoundPlayerDelay[i] > 0 )
						{
							if ( (Caps(sTrig) == Caps(Cmd)) && bDedicated )
							{
								return "";
							}
							else
							{
								return Cmd;
							}
						}
						else
						{
							if (  !IsAdmin )
							{
								ZoundPlayerSound[i]++;
							}
							ZoundPlayerDelay[i]=ZoundPlayerSound[i] * DelaysEach;
							goto JL06FB;
						}
					}
				}
				i++;
				goto JL057E;
			}
		}
JL06FB:
	}
	else
	{
		if (  !bBotsTalk )
		{
			return Cmd;
		}
	}
	if ( MySound != None )
	{
		AddToSoundBuff(MySound,PL,sTrig,Who.PlayerReplicationInfo.PlayerName);
		SetPlayerTrigs(Who.PlayerReplicationInfo.PlayerName,sTrig);
	}
	return Cmd;
	return;
}

function bool CheckInGameZound (Controller C)
{
	local bool IsAdmin;

	if ( (C != None) && C.IsA('PlayerController') )
	{
		IsAdmin=CheckZoundAdmin(PlayerController(C));
	}
	if (  !IsAdmin &&  !InGameZound &&  !Level.Game.bGameEnded &&  !Level.Game.bWaitingToStartMatch )
	{
		return False;
	}
	else
	{
		return True;
	}
	return;
}

function GetServerDetails (out ServerResponseLine ServerState)
{
	local int i;

	i=ServerState.ServerInfo.Length;
	ServerState.ServerInfo.Length=i + 1;
	ServerState.ServerInfo[i].Key="Zound";
	ServerState.ServerInfo[i].Value="v5.5";
	return;
}

function ServerTraveling (string URL, bool bItems)
{
	MyPlayers.SaveZoundPlayers();
	Log(GetDateTime(True) $ " ServerTraveling - URL = " $ URL,'Zound');
	if ( NextMutator != None )
	{
		NextMutator.ServerTraveling(URL,bItems);
	}
	return;
}

defaultproperties
{
    Yellow=(R=0, G=250, B=250, A=255)
    Cyan=(R=255, G=160, B=0, A=255)
    bAddToServerPackages=True
    GroupName="Zound"
    FriendlyName="Zound"
    Description="Plays sounds triggered by chat messages - v5.5"
}
