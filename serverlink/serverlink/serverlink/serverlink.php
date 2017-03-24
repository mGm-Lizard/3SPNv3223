<?php

mb_internal_encoding("latin1");

include_once('../classes/class.manageServers.php');
include_once('../classes/class.serverlink.php');
include_once('requestHandlers.php');

$servers = new manageServers();
$serverlink = new serverLink();

function auth_cb($accountname,$password)
{
	global $servers;
	if($servers->loginServer($accountname,$password) == 1)
		return true;
	return false;
};

function cmd_cb($accountname,$cmd,$params)
{
	switch($cmd)
	{
		case "GET_STATS": return requestHandlerGetStats($accountname,$params);
		case "GET_STATS_LIST": return requestHandlerGetStatsList($accountname,$params);
		case "REGISTER_STATS": return requestHandlerRegisterStats($accountname,$params);
		case "REGISTER_GAME": return requestHandlerRegisterGame($accountname,$params);
		default: echo "Unknown request from server \"$accountname\": $cmd\n";
	}
};

if($argc<3)
{
	echo "Usage: php serverlink.php <ip> <port>\n";
	exit;
}

$ip_address = $argv[1];
$port = (int)$argv[2];
$serverlink->run($ip_address, $port, 'auth_cb', 'cmd_cb');

?>
