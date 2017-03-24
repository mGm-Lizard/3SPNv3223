<?php
	
	include_once(__DIR__.'/../config.php');

	class dbConnection
	{
		protected $db_conn;

		function connect()
		{
			global $db_name, $db_user, $db_pass, $db_host, $db_hosttype, $db_hostname;
			
			try
			{
				$this->db_conn = new PDO("mysql:$db_hosttype=$db_hostname;dbname=$db_name;charset=latin1",$db_user,$db_pass);
				$this->db_conn->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
				return $this->db_conn;
			}
			catch(PDOException $e)
			{
				return $e->getMessage();
			}
		}
	}

?>

