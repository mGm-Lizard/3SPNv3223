//================================================================================
// ZoundMenuAbout.
//================================================================================
class ZoundMenuAbout extends PopupPageBase
	Config(User);

function InitComponent (GUIController MyController, export editinlineuse GUIComponent MyOwner)
{
	Super.InitComponent(MyController,MyOwner);
	Controls[3].SetFocus(None);
	return;
}

function bool OnClickClose (export editinlineuse GUIComponent Sender)
{
	Controller.CloseMenu(False);
	return True;
	return;
}

function OnClose (optional bool bCanceled)
{
	Class'ZoundMenuTrigs'.Default.bReset=True;
	return;
}

defaultproperties
{
    bAllowedAsLast=True
    Controls=[0]=GUIImage'ZoundMenuAbout.DialogBackground'
[1]=GUIImage'ZoundMenuAbout.LogoImage'
[2]=GUILabel'ZoundMenuAbout.lblHeader'
[3]=GUIButton'ZoundMenuAbout.NoneButton'
[4]=GUILabel'ZoundMenuAbout.lblVersion'
[5]=GUILabel'ZoundMenuAbout.lblCopy'
[6]=GUILabel'ZoundMenuAbout.lblCredits'
[7]=GUILabel'ZoundMenuAbout.lblDesign'
[8]=GUILabel'ZoundMenuAbout.lblTeam'
[9]=GUIButton'ZoundMenuAbout.CloseButton'
    WinTop=0.23
    WinLeft=0.34
    WinWidth=0.28
    WinHeight=0.28
}
