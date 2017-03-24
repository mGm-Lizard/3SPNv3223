//================================================================================
// ZoundFilter.
//================================================================================
class ZoundFilter extends Info
	Config(Zound55);

struct CensoredWords
{
	var string CensorWord;
	var string BadWords;
};

var Zound myMut;
var() config array<CensoredWords> filter;

function PreBeginPlay ()
{
	if ( Default.filter.Length == 0 )
	{
		Default.filter.Length=1;
		Default.filter[0].CensorWord="****";
		Default.filter[0].BadWords="badword1,badword2,badword3,badword10,";
		self.StaticSaveConfig();
	}
	Super.PreBeginPlay();
	return;
}

function string FilterString (Controller Sender, coerce string Msg)
{
	local string sWords;
	local string sTemp;
	local int i;
	local int j;
	local int k;

	if ( Default.filter.Length == 0 )
	{
		return Msg;
	}
	i=0;
JL0019:
	if ( i < Default.filter.Length )
	{
		sWords=Default.filter[i].BadWords;
		j=InStr(sWords,",");
		if ( j > -1 )
		{
JL005E:
			if ( j > -1 )
			{
				sTemp=Left(sWords,j);
				k=InStr(Caps(Msg),Caps(sTemp));
				if ( k > -1 )
				{
JL00A4:
					if ( k > -1 )
					{
						Msg=Left(Msg,k) $ Chr(1) $ Mid(Msg,k + Len(sTemp));
						k=InStr(Caps(Msg),Caps(sTemp));
						goto JL00A4;
					}
					Msg=UnknownFunction201(Msg,Chr(1),Default.filter[i].CensorWord);
				}
				sWords=Mid(sWords,j + 1);
				j=InStr(sWords,",");
				goto JL005E;
			}
		}
		i++;
		goto JL0019;
	}
	return Msg;
	return;
}

