//=============================================================================
// xBlueFlagBase.
//=============================================================================
class xBlueFlagBase extends zRealCTFBase
	placeable;

simulated function PostBeginPlay()
{
    local xCTFBase xbase;

    Super.PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
    {    
        xbase = Spawn(class'XGame.xCTFBase',self,,Location-BaseOffset,rot(0,0,0));
        xbase.Skins[0] = Texture'XGameTextures.FlagBaseTexB';
    }
}

defaultproperties
{
     FlagType=Class'myLevel.xBlueFlag'
     DefenderTeamIndex=1
     DefenseScriptTags="DefendBlueFlag"
     ObjectiveName="Blue Flag"
     Skins(0)=FinalBlend'myLevel.Flags.BlueFlagShader_F'
}
