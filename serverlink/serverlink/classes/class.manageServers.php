<?php

	include_once(__DIR__.'/class.database.php');

	class manageServers
	{
		public $link;

		function __construct()
		{
			$db_connection = new dbConnection();
			$this->link = $db_connection->connect();
			return $this->link;
		}
		
		
		
		function registerServer($servername,$accountname,$password,$ip_address,$port,$admin,$gametracker)
		{
			$query = $this->link->prepare("INSERT INTO servers (servername,accountname,password,ip_address,port,admin,gametracker) VALUES (?,?,?,?,?,?,?)");
			$query->execute(array($servername,$accountname,$password,$ip_address,$port,$admin,$gametracker));
			$counts = $query->rowCount();
			return $counts;
		}

		function editServer($accountname,$values)
		{
			$result = 1;
			foreach($values as $key=>$value)
			{
				$query = $this->link->prepare("UPDATE servers SET $key=? WHERE accountname=?");
				$query->execute(array($value,$accountname));
				if($query->errorCode()!=0)
					$result = 0;
				elseif($key=='accountname')
					$accountname = $value;
			}
			return $result;
		}

		function deleteServer($server_id)
		{
			$query = $this->link->prepare("DELETE FROM servers WHERE id=? LIMIT 1");
			$query->execute(array($server_id));
			$counts = $query->rowCount();
			return $counts;
		}

		function loginServer($accountname,$password)
		{
			$query = $this->link->prepare("SELECT * FROM servers WHERE accountname=? AND password=?");
			$query->execute(array($accountname,$password));
			$rowcount = $query->rowCount();
			return $rowcount;
		}

		function getServerInfo($accountname)
		{
			$query = $this->link->prepare("SELECT * FROM servers WHERE accountname=?");
			$query->execute(array($accountname));
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

		function getServerInfoById($server_id)
		{
			$query = $this->link->prepare("SELECT * FROM servers WHERE id=?");
			$query->execute(array($server_id));
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

		function getServerInfoByAccount($accountname)
		{
			$query = $this->link->prepare("SELECT * FROM servers WHERE accountname=?");
			$query->execute(array($accountname));
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

		function getServerInfoByAdmin($admin)
		{
			$query = $this->link->prepare("SELECT * FROM servers WHERE admin=?");
			$query->execute(array($admin));
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

		function getAllServers()
		{
			$query = $this->link->query("SELECT id,servername,ip_address,port,admin,gametracker FROM servers");
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

		function updateStatsCounterById($server_id,$num)
		{
			$query = $this->link->prepare("UPDATE servers SET stats_counter=stats_counter+$num WHERE id=?");
			$query->execute(array($server_id));
			$rowcount = $query->rowCount();
			return $rowcount;
		}		
	}

?>