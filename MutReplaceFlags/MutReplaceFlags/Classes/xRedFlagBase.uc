//=============================================================================
// xRedFlagBase.
//=============================================================================
class xRedFlagBase extends zRealCTFBase
	placeable;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    
    if ( Level.NetMode != NM_DedicatedServer )
    {
        Spawn(class'XGame.xCTFBase',self,,Location-BaseOffset,rot(0,0,0));
    }
}

defaultproperties
{
     FlagType=Class'myLevel.xRedFlag'
     DefenseScriptTags="DefendRedFlag"
     ObjectiveName="Red Flag"
     Skins(0)=FinalBlend'myLevel.Flags.RedFlagShader_F'
}
