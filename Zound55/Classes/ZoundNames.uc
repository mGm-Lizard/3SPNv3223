//================================================================================
// ZoundNames.
//================================================================================
class ZoundNames extends PopupPageBase
	Config(ZoundNames);

var() config array<ZTrigs> ZoundDump;
struct ZTrigs
{
	var string ServerID;
	var string Triggers;
};


function InitComponent (GUIController MyController, export editinlineuse GUIComponent MyOwner)
{
	Super.InitComponent(MyController,MyOwner);
	return;
}

function HandleParameters (string Param1, string Param2)
{
	local bool bFound;
	local int i;
	local int j;

	if ( Param1 == "" )
	{
		return;
	}
	j=Default.ZoundDump.Length;
	i=0;
JL0021:
	if ( i < j )
	{
		if ( Default.ZoundDump[i].ServerID == Param1 )
		{
			bFound=True;
			Default.ZoundDump[i].Triggers=Param2;
		}
		else
		{
			i++;
			goto JL0021;
		}
	}
	if (  !bFound )
	{
		Default.ZoundDump.Length=j + 1;
		Default.ZoundDump[j].ServerID=Param1;
		Default.ZoundDump[j].Triggers=Param2;
	}
	self.StaticSaveConfig();
	Controller.CloseMenu(False);
	return;
}

