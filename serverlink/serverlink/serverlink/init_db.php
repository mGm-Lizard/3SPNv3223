<?php

include_once('../classes/class.database.php');
include_once('../include/utils.php');

$db_connection = new dbConnection();
$link = $db_connection->connect();

// games
echo "Creating games table...<br>\n";

//echo "Link is [$link]<br>\n";

$gamesQuery = "CREATE TABLE IF NOT EXISTS games ("
			. "id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY, "
			. "timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "
			. "gametime VARCHAR(20) NOT NULL, "
			. "server_id INT(11) NOT NULL, "
			. "map_id INT(11) NOT NULL, "
			. "team_scores VARCHAR(16) NOT NULL, "
			. "gamestats_ids VARCHAR(128) NOT NULL)";

$result = $link->query($gamesQuery);
if(is_null($result) || $result->errorCode()!=0)
{
	echo "Failed\n";
	return;
}

// gamestats
echo "Creating gamestats table...\n";

$gamestatsQuery = "CREATE TABLE IF NOT EXISTS gamestats ("
				. "id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY, "
				. "timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "
				. "server_id INT(11) NOT NULL, "
				. "game_id INT(11) NOT NULL, "
				. "player_id INT(11) NOT NULL, "
				. "team_idx INT(11) NOT NULL, "
				. "rounds INT(11) NOT NULL, "
				. "score DECIMAL(10,2) NOT NULL, "
				. "kills INT(11) NOT NULL, "
				. "deaths INT(11) NOT NULL, "
				. "thaws INT(11) NOT NULL, "
				. "git INT(11) NOT NULL)";

$result = $link->query($gamestatsQuery);
if(is_null($result) || $result->errorCode()!=0)
{
	echo "Failed\n";
	return;
}

// maps
echo "Creating maps table...\n";

$mapsQuery	= "CREATE TABLE IF NOT EXISTS maps ("
			. "id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY, "
			. "mapname VARCHAR(40) NOT NULL)";

$result = $link->query($mapsQuery);
if(is_null($result) || $result->errorCode()!=0)
{
	echo "Failed\n";
	return;
}

// players
echo "Creating players table...\n";

$playersQuery	= "CREATE TABLE IF NOT EXISTS players ("
				. "id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY, "
				. "playername VARCHAR(40) NOT NULL, "
				. "playerhash VARCHAR(128) NOT NULL)";

$result = $link->query($playersQuery);
if(is_null($result) || $result->errorCode()!=0)
{
	echo "Failed\n";
	return;
}

// servers
echo "Creating servers table...\n";

$serversQuery	= "CREATE TABLE IF NOT EXISTS servers ("
				. "id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY, "
				. "accountname VARCHAR(40) NOT NULL, "
				. "servername VARCHAR(40) NOT NULL, "
				. "password VARCHAR(40) NOT NULL, "
				. "ip_address VARCHAR(20) NOT NULL, "
				. "port INT(11) NOT NULL, "
				. "admin VARCHAR(40) NOT NULL, "
				. "gametracker INT(11) NOT NULL, "
				. "use_relative_rank TINYINT(1) NOT NULL, "
				. "max_rank_score INT(11) NOT NULL DEFAULT '20000', "
				. "stats_time_days INT(11) NOT NULL DEFAULT '60',"
				. "stats_ppr_cnt INT(11) NOT NULL DEFAULT '20',"
				. "stats_lists_allowed VARCHAR(256) NOT NULL,"
				. "stats_counter INT(11) NOT NULL)";

$result = $link->query($serversQuery);
if(is_null($result) || $result->errorCode()!=0)
{
	echo "Failed\n";
	return;
}

// users
echo "Creating users table...\n";

$usersQuery		= "CREATE TABLE IF NOT EXISTS users ("
				. "id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY, "
				. "timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "
				. "username VARCHAR(40) NOT NULL, "
				. "password VARCHAR(40) NOT NULL, "
				. "email VARCHAR(40) NOT NULL, "
				. "ip_address VARCHAR(20) NOT NULL, "
				. "user_status INT(11) NOT NULL, "
				. "admin TINYINT(1) NOT NULL, "
				. "server_admin TINYINT(1) NOT NULL, "
				. "validation_code VARCHAR(64) NOT NULL)";

$result = $link->query($usersQuery);
if(is_null($result) || $result->errorCode()!=0)
{
	echo "Failed\n";
	return;
}

// admin account
echo "Creating admin account username:admin, password:password...\n";

include_once('../classes/class.manageUsers.php');
$users = new manageUsers();

$result = $users->registerUser("admin", saltedHashedPwd("password"), "", "", true);
if($result == 0)
{
	echo "Failed\n";
	return;
}


?>
