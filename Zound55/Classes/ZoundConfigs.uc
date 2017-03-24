//================================================================================
// ZoundConfigs.
//================================================================================
class ZoundConfigs extends Info
	Config(Zound55);

var config string ZoundPass;
var config bool bZound;
var config bool ShowTrigger;
var config bool ShowToSelf;
var config bool bAnnounce;
var config bool AnnounceOnce;
var config bool bBotsTalk;
var config bool NoSpecToPlayer;
var config bool Say24HourTime;
var config bool InGameZound;
var config bool UseChatLog;
var config bool UseChatFilter;
var config bool UsePlayerList;
var config int SoundDelay;
var config int LoginDelay;
var config int DelaysEach;
var config int SoundsEach;
var config int RepeatDelay;
var Zound myMut;

function LoadZoundConfigs ()
{
	myMut.ZoundPass=Default.ZoundPass;
	myMut.bZound=Default.bZound;
	myMut.ShowTrigger=Default.ShowTrigger;
	myMut.ShowToSelf=Default.ShowToSelf;
	myMut.bAnnounce=Default.bAnnounce;
	myMut.AnnounceOnce=Default.AnnounceOnce;
	myMut.bBotsTalk=Default.bBotsTalk;
	myMut.bNoSpecPlayer=Default.NoSpecToPlayer;
	myMut.b24HourTime=Default.Say24HourTime;
	myMut.InGameZound=Default.InGameZound;
	myMut.bChatLog=Default.UseChatLog;
	myMut.bChatFilter=Default.UseChatFilter;
	myMut.bPlayerList=Default.UsePlayerList;
	myMut.SoundDelay=Default.SoundDelay;
	myMut.LoginDelay=Default.LoginDelay;
	myMut.DelaysEach=Default.DelaysEach;
	myMut.SoundsEach=Default.SoundsEach;
	myMut.RepeatDelay=Default.RepeatDelay;
	return;
}

function SaveZoundConfigs ()
{
	Default.bZound=myMut.bZound;
	Default.ShowTrigger=myMut.ShowTrigger;
	Default.ShowToSelf=myMut.ShowToSelf;
	Default.bAnnounce=myMut.bAnnounce;
	Default.AnnounceOnce=myMut.AnnounceOnce;
	Default.bBotsTalk=myMut.bBotsTalk;
	Default.NoSpecToPlayer=myMut.bNoSpecPlayer;
	Default.Say24HourTime=myMut.b24HourTime;
	Default.InGameZound=myMut.InGameZound;
	Default.UseChatLog=myMut.bChatLog;
	Default.UseChatFilter=myMut.bChatFilter;
	Default.UsePlayerList=myMut.bPlayerList;
	Default.SoundDelay=myMut.SoundDelay;
	Default.LoginDelay=myMut.LoginDelay;
	Default.DelaysEach=myMut.DelaysEach;
	Default.SoundsEach=myMut.SoundsEach;
	Default.RepeatDelay=myMut.RepeatDelay;
	self.StaticSaveConfig();
	return;
}

defaultproperties
{
    bZound=True
    ShowToSelf=True
    bAnnounce=True
    SoundDelay=5
    LoginDelay=5
    DelaysEach=1
    SoundsEach=10
    RepeatDelay=5
}
