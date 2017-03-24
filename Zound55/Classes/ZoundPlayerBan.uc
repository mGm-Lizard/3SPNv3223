//================================================================================
// ZoundPlayerBan.
//================================================================================
class ZoundPlayerBan extends Info
	Config(Zound55);

var() config array<PlayerBans> BannedPlayer;
var Zound myMut;
struct PlayerBans
{
	var string NickName;
	var string UniqueID;
};


function PreBeginPlay ()
{
	if ( Default.BannedPlayer.Length == 0 )
	{
		Default.BannedPlayer.Length=1;
		Default.BannedPlayer[0].NickName="Nickname";
		Default.BannedPlayer[0].UniqueID="abcf542decb78f1aaa64fde7c891abce";
		self.StaticSaveConfig();
	}
	Super.PreBeginPlay();
	return;
}

function bool CheckBanList (PlayerController Sender)
{
	local string sNick;
	local string sKey;
	local int i;

	if ( (Sender != None) && (Sender.PlayerReplicationInfo != None) )
	{
		sNick=Sender.PlayerReplicationInfo.PlayerName;
		sKey=Sender.GetPlayerIDHash();
		i=0;
JL005A:
		if ( i < Default.BannedPlayer.Length )
		{
			if ( Default.BannedPlayer[i].NickName == sNick )
			{
				return True;
			}
			i++;
			goto JL005A;
		}
		i=0;
JL0097:
		if ( i < Default.BannedPlayer.Length )
		{
			if ( Default.BannedPlayer[i].UniqueID == sKey )
			{
				return True;
			}
			i++;
			goto JL0097;
		}
	}
	return False;
	return;
}

function bool AddRemoveBan (string sNick)
{
	local string sKey;
	local Controller C;
	local int i;

	sKey="";
	C=Level.ControllerList;
JL001C:
	if ( C != None )
	{
		if ( C.PlayerReplicationInfo.PlayerName ~= sNick )
		{
			sKey=PlayerController(C).GetPlayerIDHash();
		}
		else
		{
			C=C.nextController;
			goto JL001C;
		}
	}
	if ( sKey != "" )
	{
		i=0;
JL008F:
		if ( i < Default.BannedPlayer.Length )
		{
			if ( Default.BannedPlayer[i].NickName == sNick )
			{
				Default.BannedPlayer.Remove (i,1);
				self.StaticSaveConfig();
				return False;
			}
			i++;
			goto JL008F;
		}
		i=0;
JL00E3:
		if ( i < Default.BannedPlayer.Length )
		{
			if ( Default.BannedPlayer[i].UniqueID == sKey )
			{
				Default.BannedPlayer.Remove (i,1);
				self.StaticSaveConfig();
				return False;
			}
			i++;
			goto JL00E3;
		}
		i=Default.BannedPlayer.Length;
		Default.BannedPlayer.Length=i + 1;
		Default.BannedPlayer[i].NickName=sNick;
		Default.BannedPlayer[i].UniqueID=sKey;
		self.StaticSaveConfig();
		return True;
	}
	return False;
	return;
}

