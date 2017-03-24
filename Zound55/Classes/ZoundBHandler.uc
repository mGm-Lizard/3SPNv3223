//================================================================================
// ZoundBHandler.
//================================================================================
class ZoundBHandler extends BroadcastHandler;

var Zound myMut;
var bool bInit;

function PreBeginPlay ()
{
	local BroadcastHandler bh;

	if (  !bInit )
	{
		bInit=True;
		if ( Level.Game.BroadcastHandler.IsA('UT2VoteChatHandler') )
		{
			foreach AllActors(Class'BroadcastHandler',bh)
			{
				if ( bh.Class == Level.Game.Default.BroadcastClass )
				{
					bh.RegisterBroadcastHandler(self);
				}
				else
				{
				}
			}
		}
		else
		{
			Level.Game.BroadcastHandler.RegisterBroadcastHandler(self);
		}
	}
	return;
}

function BroadcastText (PlayerReplicationInfo SenderPRI, PlayerController Receiver, coerce string Msg, optional name Type)
{
	if ( (SenderPRI != None) && ((Type == 'Say') || (Type == 'TeamSay')) )
	{
		Msg=myMut.ChatHandler(Controller(SenderPRI.Owner),Msg,Receiver);
		if ( Msg == "" )
		{
			return;
		}
	}
	Super.BroadcastText(SenderPRI,Receiver,Msg,Type);
	return;
}

