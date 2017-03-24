<?php

	include_once(__DIR__.'/class.database.php');

	class manageMaps
	{
		public $link;

		function __construct()
		{
			$db_connection = new dbConnection();
			$this->link = $db_connection->connect();
			return $this->link;
		}

		function registerMap($mapname)
		{
			$query = $this->link->prepare("INSERT INTO maps (mapname) VALUES (?)");
			$query->execute(array($mapname));
			$rowcount = $query->rowCount();
			return $rowcount;
		}

		function getMapInfo($mapname)
		{
			$query = $this->link->prepare("SELECT * FROM maps WHERE mapname=?");
			$query->execute(array($mapname));
			$rowcount = $query->rowCount();
			if($rowcount == 1)
			{
				$result = $query->fetchAll();
				return $result[0];
			}
		}

		function getMapInfoById($id)
		{
			$query = $this->link->prepare("SELECT * FROM maps WHERE id=?");
			$query->execute(array($id));
			$rowcount = $query->rowCount();
			if($rowcount == 1)
			{
				$result = $query->fetchAll();
				return $result[0];
			}			
		}

		function getOrRegisterMapInfo($mapname)
		{
			$result = $this->getMapInfo($mapname);
			if($result == 0)
			{
				$result = $this->registerMap($mapname);
				if($result == 0)
					return 0;
				$result = $this->getMapInfo($mapname);
			}
			return $result;
		}
	}

?>