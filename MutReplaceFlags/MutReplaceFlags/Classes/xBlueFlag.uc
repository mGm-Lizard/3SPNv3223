//=============================================================================
// xBlueFlag.
//=============================================================================
class xBlueFlag    extends CTFFlag;

simulated function UpdateForTeam()
{
//    if ( (GRI != None) && (DefenderTeamIndex < 2) && (GRI.TeamSymbols[DefenderTeamIndex] != None) )
//        TexScaler(Combiner(Shader(FinalBlend(Skins[0]).Material).Diffuse).Material2).Material = GRI.TeamSymbols[DefenderTeamIndex];
}

simulated function PostBeginPlay()
{    
    Super.PostBeginPlay();  
      
    LoopAnim('flag',0.8);
    SimAnim.bAnimLoop = true;  
}

defaultproperties
{
     TeamNum=1
     LightHue=130
     Mesh=VertMesh'XGame_rc.FlagMesh'
     DrawScale=0.900000
     Skins(0)=FinalBlend'myLevel.Flags.BlueFlagShader_F'
}
