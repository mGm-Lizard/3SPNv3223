<?php

	include_once(__DIR__.'/class.database.php');

	class manageGames
	{
		public $link;

		function __construct()
		{
			$db_connection = new dbConnection();
			$this->link = $db_connection->connect();
			return $this->link;
		}

		function registerGame($accountname, $gametime, $mapname, $team_scores)
		{
			include_once(__DIR__.'/class.manageServers.php');
			$servers = new manageServers();
			$serverInfo = $servers->getServerInfo($accountname);
			if($serverInfo == 0)
				return 0;
			$serverId = $serverInfo['id'];

			include_once(__DIR__.'/class.manageMaps.php');
			$maps = new manageMaps();
			$mapInfo = $maps->getOrRegisterMapInfo($mapname);
			if($mapInfo == 0)
				return 0;
			$mapId = $mapInfo['id'];

			$query = $this->link->prepare("INSERT INTO games (gametime,server_id,map_id,team_scores) VALUES (?,?,?,?)");
			$query->execute(array($gametime, $serverId, $mapId, $team_scores));
			$counts = $query->rowCount();
			return $counts;
		}

		function getGameId($server_id, $gametime)
		{
			$query = $this->link->prepare("SELECT id FROM games WHERE server_id=? AND gametime=?");
			$query->execute(array($server_id, $gametime));
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

		function getGameById($game_id)
		{
			$query = $this->link->prepare("SELECT gametime,map_id,team_scores,gamestats_ids FROM games WHERE id=?");
			$query->execute(array($game_id));
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

		function getGamesByServerId($server_id,$max_games)
		{
			$query = $this->link->prepare("SELECT id,gametime,map_id,team_scores,gamestats_ids FROM games WHERE server_id=? ORDER BY id DESC LIMIT ?");
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
	}

?>