<?php

include_once('../classes/class.serverlink.php');
include_once('../classes/class.manageGameStats.php');
include_once('../classes/class.managePlayers.php');
include_once('../classes/class.manageServers.php');
include_once('../classes/class.manageGames.php');

function requestHandlerRegisterGame($accountname, $params)
{
	if(count($params)!=3)
	{
		echo "Incorrect parameters for stats from server \"$accountname\" with params: ".implode(" ",$params)."\n";
		return false;
	}

	$gametime = $params[0];
	$mapname = $params[1];
	$team_scores = $params[2];

	$games = new manageGames();
	$result = $games->registerGame($accountname, $gametime, $mapname, $team_scores);
	if($result == 0)
	{
		echo "Unable to register stats from server \"$accountname\" with params: ".implode(" ",$params)."\n";
		return false;
	}

	echo "Registered game for server \"$accountname\"\n";
	return false;
}

function requestHandlerRegisterStats($accountname, $params)
{
	if(count($params)!=10)
	{
		echo "Incorrect parameters for stats from server \"$accountname\" with params: ".implode(" ",$params)."\n";
		return false;
	}

	$gametime = $params[0];
	$playername = $params[1];
	$playerhash = $params[2];
	$team_idx = (int)$params[3];
	$rounds = (int)$params[4];
	$score = (float)$params[5];
	$kills = (int)$params[6];
	$deaths = (int)$params[7];
	$thaws = (int)$params[8];
	$git = (int)$params[9];

	$gamestats = new manageGameStats();
	$result = $gamestats->registerGameStats($accountname,$gametime,$playername,$playerhash,$team_idx,$rounds,$score,$kills,$deaths,$thaws,$git);
	if($result == 0)
	{
		echo "Unable to register stats from server \"$accountname\" with params: ".implode(" ",$params)."\n";
		return false;
	}

	echo "Registered stats from server \"$accountname\" for player \"$playername\": gametime:$gametime, rounds:$rounds, score:$score, kills:$kills, deaths:$deaths, thaws:$thaws, git:$git\n";
	return false;
}

function requestHandlerGetStats($accountname, $params)
{
	if(count($params)!=2)
	{
		echo "Incorrect parameters for stats update from server \"$accountname\" with params: ".implode(" ",$params)."\n";
		return false;
	}

	$playerIndex = $params[0];
	$playerhash = $params[1];

	$players = new managePlayers();
	$playerInfo = $players->getPlayerInfoByHash($playerhash);
	if($playerInfo == 0)
	{
		echo "Player record not found for player hash: $playerhash\n";
		return "STATS_UPDATE $playerIndex 0 0.0\n";
	}

	$servers = new manageServers();
	$serverInfo = $servers->getServerInfo($accountname);
	if($serverInfo == 0)
	{
		echo "Server info not found for server: $accountname\n";
		return "STATS_UPDATE $playerIndex 0 0.0\n";
	}
	$serverId = $serverInfo['id'];
	$stats_time_days = $serverInfo['stats_time_days'];
	if($stats_time_days == 0)
		$stats_time_days = 60;
	$stats_ppr_cnt = $serverInfo['stats_ppr_cnt'];
	if($stats_ppr_cnt == 0)
		$stats_ppr_cnt = 20;
	$use_relative_rank = $serverInfo['use_relative_rank'];
	$max_rank_score = $serverInfo['max_rank_score'];
	if($max_rank_score == 0)
		$max_rank_score = 20000;

	$gamestats = new manageGameStats();
	$playerId = $playerInfo['id'];
	$stats = $gamestats->getPlayerStatsById($serverId,$playerId,$stats_time_days);
	if($stats == 0)
	{
		echo "Unable to retrieve stats for player ID: $playerId\n";
		return "STATS_UPDATE $playerIndex 0 0.0\n";
	}

	$rounds = $stats['rounds'];
	$score = $stats['score'];

	if($use_relative_rank)
	{
		$top_score = $gamestats->getServerTopStatsSum($serverId,'score',1,$stats_time_days);
		if($top_score !== false && $top_score[0] != 0)
		{
			$top_score = $top_score[0];
			$top_score = max($max_rank_score, $top_score['score']);
			$rank = max(0.0, min(1.0, number_format((float)$score/(float)$top_score,3,'.','')));
		}
		else
		{
			$rank = "0";
		}
	}
	else
	{
		$rank = max(0.0, min(1.0, number_format((float)$score/(float)$max_rank_score,3,'.','')));
	}

	$statPPR = $gamestats->getPlayerStatFracAvgByCount($serverId,$playerId,'score','rounds','ppr',$stats_ppr_cnt);
	$avgPPR = $statPPR!==false ? number_format($statPPR['ppr'],1,'.','') : "0";

	echo "Stats request from server \"$accountname\" for player \"".$playerInfo['playername']."\": rank:$rank, avgPPR:$avgPPR\n";
	return "STATS_UPDATE $playerIndex $rank $avgPPR\n";
}

function stat_allowed($stats_lists_allowed, $stat_name)
{
	return count($stats_lists_allowed)==0 || array_search($stat_name, $stats_lists_allowed)!==false;
}

function getStatsListByIndex($accountname, $stats_lists_allowed, $index)
{
	switch($index % 20)
	{
	case 0: if(stat_allowed($stats_lists_allowed, 'score')) return getStatsList_GetTopStats($accountname, "Top10_Score_24_Hour", 'score', 10, 1); break;
	case 1: if(stat_allowed($stats_lists_allowed, 'score')) return getStatsList_GetTopStats($accountname, "Top10_Score_7_Day", 'score', 10, 7); break;
	case 2: if(stat_allowed($stats_lists_allowed, 'score')) return getStatsList_GetTopStats($accountname, "Top10_Score_30_Day", 'score', 10, 30); break;
	case 3: if(stat_allowed($stats_lists_allowed, 'score')) return getStatsList_GetTopStats($accountname, "Top10_Score_180_Day", 'score', 10, 180); break;
	case 4: if(stat_allowed($stats_lists_allowed, 'ppr')) return getStatsList_GetTopStatsFracAvg($accountname, "Top10_PPR_24_Hour", 'score', 'rounds', 'PPR', 10, 1); break;
	case 5: if(stat_allowed($stats_lists_allowed, 'ppr')) return getStatsList_GetTopStatsFracAvg($accountname, "Top10_PPR_7_Day", 'score', 'rounds', 'PPR', 10, 7); break;
	case 6: if(stat_allowed($stats_lists_allowed, 'ppr')) return getStatsList_GetTopStatsFracAvg($accountname, "Top10_PPR_30_Day", 'score', 'rounds', 'PPR', 10, 30); break;
	case 7: if(stat_allowed($stats_lists_allowed, 'ppr')) return getStatsList_GetTopStatsFracAvg($accountname, "Top10_PPR_180_Day", 'score', 'rounds', 'PPR', 10, 180); break;
	case 8: if(stat_allowed($stats_lists_allowed, 'kills')) return getStatsList_GetTopStats($accountname, "Top10_Kills_24_Hour", 'kills', 10, 1); break;
	case 9: if(stat_allowed($stats_lists_allowed, 'kills')) return getStatsList_GetTopStats($accountname, "Top10_Kills_7_Day", 'kills', 10, 7); break;
	case 10: if(stat_allowed($stats_lists_allowed, 'kills')) return getStatsList_GetTopStats($accountname, "Top10_Kills_30_Day", 'kills', 10, 30); break;
	case 11: if(stat_allowed($stats_lists_allowed, 'kills')) return getStatsList_GetTopStats($accountname, "Top10_Kills_180_Day", 'kills', 10, 180); break;
	case 12: if(stat_allowed($stats_lists_allowed, 'deaths')) return getStatsList_GetTopStats($accountname, "Top10_Deaths_24_Hour", 'deaths', 10, 1); break;
	case 13: if(stat_allowed($stats_lists_allowed, 'deaths')) return getStatsList_GetTopStats($accountname, "Top10_Deaths_7_Day", 'deaths', 10, 7); break;
	case 14: if(stat_allowed($stats_lists_allowed, 'deaths')) return getStatsList_GetTopStats($accountname, "Top10_Deaths_30_Day", 'deaths', 10, 30); break;
	case 15: if(stat_allowed($stats_lists_allowed, 'deaths')) return getStatsList_GetTopStats($accountname, "Top10_Deaths_180_Day", 'deaths', 10, 180); break;
	case 16: if(stat_allowed($stats_lists_allowed, 'thaws')) return getStatsList_GetTopStats($accountname, "Top10_Thaws_24_Hour", 'thaws', 10, 1); break;
	case 17: if(stat_allowed($stats_lists_allowed, 'thaws')) return getStatsList_GetTopStats($accountname, "Top10_Thaws_7_Day", 'thaws', 10, 7); break;
	case 18: if(stat_allowed($stats_lists_allowed, 'thaws')) return getStatsList_GetTopStats($accountname, "Top10_Thaws_30_Day", 'thaws', 10, 30); break;
	case 19: if(stat_allowed($stats_lists_allowed, 'thaws')) return getStatsList_GetTopStats($accountname, "Top10_Thaws_180_Day", 'thaws', 10, 180); break;
	default: break;
	}

	return false;
}

function requestHandlerGetStatsList($accountname, $params)
{
	$servers = new manageServers();
	$serverInfo = $servers->getServerInfo($accountname);
	if($serverInfo == 0)
	{
		echo "Server info not found for server: $accountname\n";
		return false;
	}
	$server_id = $serverInfo['id'];

	$stats_lists_allowed = strtokarray($serverInfo['stats_lists_allowed'],',');
	$stats_counter = $serverInfo['stats_counter'];

	$cnt = 0;
	$retval = false;

	while($cnt < 20)
	{
		++$cnt;
		$retval = getStatsListByIndex($accountname, $stats_lists_allowed, $stats_counter);
		if($retval != false)
			break;
		++$stats_counter;
	}

	$result = $servers->updateStatsCounterById($server_id,$cnt);
	if($result == 0)
	{
		echo "Unable to update stats counter for server: $accountname\n";
	}

	return $retval;
}

function getStatsList_GetTopStats($accountname, $listname, $field, $max_count, $stats_time_days)
{
	$servers = new manageServers();
	$serverInfo = $servers->getServerInfo($accountname);
	if($serverInfo == 0)
	{
		echo "Server info not found for server: $accountname\n";
		return false;
	}
	$server_id = $serverInfo['id'];

	$gamestats = new manageGameStats();
	$stats = $gamestats->getServerTopStatsSum($server_id,$field,$max_count,$stats_time_days);
	if($stats == 0)
	{
		//echo "Unable to retrieve stats $field over $stats_time_days days for server: $accountname\n";
		return false;
	}

	$result = array("SL_NAME $listname\n");

	for($i=0; $i<count($stats) && $i<10; ++$i)
	{
		$stat = $stats[$i];
		$playername = $stat['playername'];
		$value = $stat[$field];
		array_push($result, "SL_IDX $i ".$playername." ".((int)$value)."\n");
	}

	echo str_replace("\n", "", implode("; ",$result))."\n";
	return $result;
}

function getStatsList_GetTopStatsFracAvg($accountname, $listname, $field1, $field2, $field_name, $max_count, $stats_time_days)
{
	$servers = new manageServers();
	$serverInfo = $servers->getServerInfo($accountname);
	if($serverInfo == 0)
	{
		echo "Server info not found for server: $accountname\n";
		return false;
	}
	$server_id = $serverInfo['id'];

	$gamestats = new manageGameStats();
	$stats = $gamestats->getServerTopStatsFracAvg($server_id,$field1,$field2,$field_name,$max_count,$stats_time_days);
	if($stats == 0)
	{
		//echo "Unable to retrieve stats $field1/$field2 $stats_time_days days for server: $accountname\n";
		return false;
	}

	$result = array("SL_NAME $listname\n");

	for($i=0; $i<count($stats) && $i<10; ++$i)
	{
		$stat = $stats[$i];
		$playername = $stat['playername'];
		$value = $stat[$field_name];
		array_push($result, "SL_IDX $i ".$playername." ".number_format($value,1,'.','')."\n");
	}

	echo str_replace("\n", "", implode("; ",$result))."\n";
	return $result;
}

?>
