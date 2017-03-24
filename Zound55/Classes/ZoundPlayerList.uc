//================================================================================
// ZoundPlayerList.
//================================================================================
class ZoundPlayerList extends Info
	Config(Zound55);

var() config array<PlayerList> ListedPlayer;
var Zound myMut;
struct PlayerList
{
	var string NickName;
	var string UniqueID;
};


function PreBeginPlay ()
{
	if ( Default.ListedPlayer.Length == 0 )
	{
		Default.ListedPlayer.Length=1;
		Default.ListedPlayer[0].NickName="Nickname";
		Default.ListedPlayer[0].UniqueID="abcf542decb78f1aaa64fde7c891abce";
		self.StaticSaveConfig();
	}
	Super.PreBeginPlay();
	return;
}

function bool CheckPlayerList (PlayerController Sender, bool byPass)
{
	local string sKey;
	local int i;

	if (  !byPass )
	{
		if (  !myMut.bPlayerList )
		{
			return True;
		}
		if ( Sender == None )
		{
			return True;
		}
	}
	sKey=Sender.GetPlayerIDHash();
	i=0;
JL004A:
	if ( i < Default.ListedPlayer.Length )
	{
		if ( Default.ListedPlayer[i].UniqueID == sKey )
		{
			return True;
		}
		i++;
		goto JL004A;
	}
	return False;
	return;
}

function bool AddRemovePlayer (string sNick)
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
		if ( i < Default.ListedPlayer.Length )
		{
			if ( Default.ListedPlayer[i].UniqueID == sKey )
			{
				Default.ListedPlayer.Remove (i,1);
				self.StaticSaveConfig();
				return False;
			}
			i++;
			goto JL008F;
		}
		i=Default.ListedPlayer.Length;
		Default.ListedPlayer.Length=i + 1;
		Default.ListedPlayer[i].NickName=sNick;
		Default.ListedPlayer[i].UniqueID=sKey;
		self.StaticSaveConfig();
		return True;
	}
	return False;
	return;
}

