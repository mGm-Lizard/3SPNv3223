<?php

	include_once(__DIR__.'/class.database.php');

	class manageGameStats
	{
		public $link;

		function __construct()
		{
			$db_connection = new dbConnection();
			$this->link = $db_connection->connect();
			return $this->link;
		}

		function registerGameStats($accountname, $gametime, $playername, $playerhash, $team_idx, $rounds, $score, $kills, $deaths, $thaws, $git)
		{
			include_once(__DIR__.'/class.manageServers.php');
			$servers = new manageServers();
			$serverInfo = $servers->getServerInfo($accountname);
			if($serverInfo == 0)
				return 0;
			$serverId = $serverInfo['id'];

			include_once(__DIR__.'/class.manageGames.php');
			$games = new manageGames();
			$gameInfo = $games->getGameId($serverId, $gametime);
			if($gameInfo == 0)
				return 0;
			$gameId = $gameInfo['id'];

			include_once(__DIR__.'/class.managePlayers.php');
			$players = new managePlayers();
			$playerInfo = $players->getOrRegisterPlayerInfo($playername, $playerhash);
			if($playerInfo == 0)
				return 0;
			$playerId = $playerInfo['id'];
			if($playername != $playerInfo['playername'])
				$players->updatePlayerName($playerId, $playername);

			$query = $this->link->prepare("INSERT INTO gamestats (server_id,game_id,player_id,team_idx,rounds,score,kills,deaths,thaws,git) VALUES (?,?,?,?,?,?,?,?,?,?)");
			$query->execute(array($serverId, $gameId, $playerId, $team_idx, $rounds, $score, $kills, $deaths, $thaws, $git));

			$rowcount = $query->rowCount();			
			if($rowcount > 0)
			{
				$statsId = $this->link->lastInsertId();
				$query = $this->link->query("UPDATE games SET gamestats_ids = CONCAT_WS(',',NULLIF(gamestats_ids,''),'$statsId') WHERE id = '$gameId'");

				$rowcount = $query->rowCount();
			}

			return $rowcount;
		}

		function getGameStatsByServerId($server_id,$max_games)
		{
			$query = $this->link->prepare("SELECT game_id,player_id,team_idx,rounds,score,kills,deaths,thaws,git FROM gamestats WHERE server_id=? ORDER BY id DESC LIMIT ?");
			$query->bindValue(1, $server_id);
			$query->bindValue(2, (int)$max_games, PDO::PARAM_INT);
			$query->execute();
			$rowcount = $query->rowCount();
			if($rowcount > 0)
			{
				$result = $query->fetchAll();
				return $result;
			}
			else
			{
				return $rowcount;
			}
		}

		function getGameStatsById($stats_id)
		{
			$query = $this->link->prepare("SELECT game_id,player_id,team_idx,rounds,score,kills,deaths,thaws,git FROM gamestats WHERE id=?");
			$query->execute(array($stats_id));
			$rowcount = $query->rowCount();
			if($rowcount > 0)
			{
				$result = $query->fetchAll();
				return $result[0];
			}
			else
			{
				return $rowcount;
			}
		}

		function getPlayerStatsById($server_id,$player_id,$stats_time_days)
		{
			$query = $this->link->prepare("SELECT SUM(rounds) AS rounds, SUM(score) AS score, SUM(kills) AS kills, SUM(deaths) AS deaths, SUM(thaws) AS thaws, SUM(git) AS git FROM gamestats WHERE server_id=? AND player_id=? AND TIMESTAMPDIFF(DAY, timestamp, SYSDATE()) < ?");
			$query->execute(array($server_id, $player_id, $stats_time_days));
			$rowcount = $query->rowCount();
			if($rowcount == 1)
			{
				$result = $query->fetchAll();
				return $result[0];
			}
			else
			{
				return $rowcount;
			}
		}

		function getServerTopStatsSum($server_id,$field,$max_count,$stats_time_days)
		{
			$query = $this->link->prepare("SELECT t2.playername,SUM(t1.$field) AS $field FROM gamestats AS t1 INNER JOIN players AS t2 ON t1.player_id=t2.id WHERE t1.server_id=? AND TIMESTAMPDIFF(DAY, t1.timestamp, SYSDATE()) < ? GROUP BY t1.player_id ORDER BY SUM(t1.$field) DESC LIMIT ?");
			$query->bindValue(1, $server_id);
			$query->bindValue(2, $stats_time_days);
			$query->bindValue(3, (int)$max_count, PDO::PARAM_INT);
			$query->execute();
			$rowcount = $query->rowCount();
			if($rowcount > 0)
			{
				$result = $query->fetchAll();
				return $result;
			}
			else
			{
				return $rowcount;
			}
		}

		function getServerTopStatsFracAvg($server_id,$field1,$field2,$field_name,$max_count,$stats_time_days)
		{
			$query = $this->link->prepare("SELECT t2.playername,AVG(t1.$field1/t1.$field2) AS $field_name FROM gamestats AS t1 INNER JOIN players AS t2 ON t1.player_id=t2.id WHERE t1.server_id=? AND TIMESTAMPDIFF(DAY, t1.timestamp, SYSDATE())<? AND t1.$field2>0 GROUP BY t1.player_id ORDER BY $field_name DESC");
			$query->bindValue(1, $server_id);
			$query->bindValue(2, $stats_time_days);
			$query->execute();
			$rowcount = $query->rowCount();
			if($rowcount > 0)
			{
				$result = $query->fetchAll();
				return $result;
			}
			else
			{
				return $rowcount;
			}
		}

		function getPlayerStatFracAvgByCount($server_id,$player_id,$field1,$field2,$field_name,$stats_cnt)
		{
			$query = $this->link->prepare("SELECT AVG($field1/$field2) AS $field_name FROM (SELECT $field1,$field2 FROM gamestats WHERE server_id=? AND player_id=? AND $field2>0 ORDER BY timestamp DESC LIMIT ?) AS t1");
			$query->bindValue(1, $server_id);
			$query->bindValue(2, $player_id);
			$query->bindValue(3, (int)$stats_cnt, PDO::PARAM_INT);
			$query->execute();
			$rowcount = $query->rowCount();
			if($rowcount > 0)
			{
				$result = $query->fetchAll();
				return $result[0];
			}
			else
			{
				return $rowcount;
			}
		}
	}

?>