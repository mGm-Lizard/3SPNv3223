//================================================================================
// ZoundChatLog.
//================================================================================
class ZoundChatLog extends Info;

var FileLog ChatLog;
var string LastMesg;

function PreBeginPlay ()
{
	Enable('Tick');
	return;
}

function CloseChatLog ()
{
	if ( ChatLog != None )
	{
		ChatLog.Destroy();
		ChatLog=None;
	}
	return;
}

function WriteChatLog (string sLog)
{
	local string sDay;

	if ( ChatLog == None )
	{
		sDay=GetDay();
		ChatLog=Spawn(Class'FileLog',Level);
		ChatLog.OpenLog("ZoundChat" $ sDay);
	}
	if ( ChatLog != None )
	{
		if ( sLog != LastMesg )
		{
			ChatLog.Logf(sLog);
		}
		LastMesg=sLog;
	}
	return;
}

function Tick (float Delta)
{
	if ( (Level.NextURL != "") && (ChatLog != None) )
	{
		CloseChatLog();
	}
	return;
}

function string GetDay ()
{
	if ( Level.Day < 10 )
	{
		return "0" $ string(Level.Day);
	}
	else
	{
		return "" $ string(Level.Day);
	}
	return;
}

