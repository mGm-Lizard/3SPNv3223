//================================================================================
// ZoundPlayers.
//================================================================================
class ZoundPlayers extends Info;

var config string ZLastPlayers;
var Zound myMut;

function LoadZoundPlayers ()
{
	myMut.ZLastPlayers=Default.ZLastPlayers;
	Default.ZLastPlayers="";
	self.StaticSaveConfig();
	return;
}

function SaveZoundPlayers ()
{
	local string sTemp;
	local int i;

	sTemp="";
	i=0;
JL000F:
	if ( i < 32 )
	{
		if ( myMut.ZoundPlayerName[i] == "" )
		{
			goto JL0069;
		}
		sTemp=sTemp $ myMut.ZoundPlayerName[i] $ " ";
		i++;
		goto JL000F;
	}
JL0069:
	Default.ZLastPlayers=sTemp;
	self.StaticSaveConfig();
	return;
}

