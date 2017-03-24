<?php

	include_once(__DIR__.'/class.database.php');

	class managePlayers
	{
		public $link;

		function __construct()
		{
			$db_connection = new dbConnection();
			$this->link = $db_connection->connect();
			return $this->link;
		}

		function registerPlayer($playername, $playerhash)
		{
			$query = $this->link->prepare("INSERT INTO players (playername,playerhash) VALUES (?,?)");
			$query->execute(array($playername, $playerhash));
			$rowcount = $query->rowCount();
			return $rowcount;
		}

		function getPlayerInfoByHash($playerhash)
		{
			$query = $this->link->prepare("SELECT * FROM players WHERE playerhash=?");
			$query->execute(array($playerhash));
			$rowcount = $query->rowCount();
			if($rowcount == 1)
			{
				$result = $query->fetchAll();
				return $result[0];
			}
		}

		function getPlayerInfoById($id)
		{
			$query = $this->link->prepare("SELECT * FROM players WHERE id=?");
			$query->execute(array($id));
			$rowcount = $query->rowCount();
			if($rowcount == 1)
			{
				$result = $query->fetchAll();
				return $result[0];
			}			
		}

		function getOrRegisterPlayerInfo($playername, $playerhash)
		{
			$result = $this->getPlayerInfoByHash($playerhash);
			if($result == 0)
			{
				$result = $this->registerPlayer($playername, $playerhash);
				if($result == 0)
					return 0;
				$result = $this->getPlayerInfoByHash($playerhash);
			}
			return $result;
		}

		function updatePlayerName($player_id, $playername)
		{
			$query = $this->link->prepare("UPDATE players SET playername=(?) WHERE id=$player_id");
			$query->execute(array($playername));
			$rowcount = $query->rowCount();
			return $rowcount;
		}
	}

?>