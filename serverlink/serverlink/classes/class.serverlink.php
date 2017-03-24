<?php

	include_once(__DIR__.'/../include/utils.php');

	class serverLinkUser
	{
		var $handshake;
		var $accountname;
		var $socket;
	}
	
	class serverLink
	{
		protected $master;
		protected $sockets;
		protected $users;
		protected $inBuffer;

		protected function console($msg)
		{
			echo $msg."\n";
		}

		protected function getuserbysocket($socket)
		{
			foreach($this->users as $user)
				if($user->socket==$socket)
					return $user;
			return null;
		}

		protected function process($user,$line,$cmd_cb)
		{
			$params = strtokarray($line," ");
			if(count($params)==0)
			{
				$this->console("Unknown command ".$line);
				return;
			}

			$cmd = $params[0];

			if($cmd == "LOGOUT")
			{
				$this->disconnect($user->socket);
				return;
			}

			$params = array_slice($params, 1);

			$result = $cmd_cb($user->accountname,$cmd,$params);
			if($result != false)
			{
				if(is_array($result))
				{
					foreach($result as $line)
					{
						$this->send($user->socket,$line);
					}
				}
				else
				{
					$this->send($user->socket,$result);
				}
			}
		}

		protected function dohandshake($user,$buffer,$auth_cb)
		{
			$tokens = strtokarray($buffer," \r\n");
			if(count($tokens) !== 3) {
				$this->console("Invalid parameters for handshake");
				return false;
			}

			if($tokens[0] !== "LOGIN")
				return false;

			$accountname = $tokens[1];
			$password = $tokens[2];

			if($auth_cb($accountname,$password) == false)
			{
				$this->console("Invalid authentication for server ".$accountname);
				return false;
			}

			$this->console("Server ".$accountname." authenticated");
			$this->send($user->socket,"WELCOME!\n");
			$user->handshake=true;
			$user->accountname = $accountname;
			return true;
		}

		protected function send($socket,$msg)
		{
			socket_write($socket,$msg,strlen($msg));
		}

		protected function connect($socket)
		{
			  $user = new serverLinkUser();
			  $user->socket = $socket;
			  array_push($this->users,$user);
			  array_push($this->sockets,$socket);

			  $peername = "Unknown";
			  $port = 0;
			  socket_getpeername($socket,$peername,$port);
			  $this->console($socket." CONNECTED! IP:".$peername." PORT:".$port);
		}

		protected function disconnect($socket)
		{
			$found=null;
			$n=count($this->users);
			for($i=0;$i<$n;$i++)
			{
				if($this->users[$i]->socket==$socket)
				{
					$found=$i;
					break;
				}
			}
			if(!is_null($found))
			{
				array_splice($this->users,$found,1);
			}
			$index = array_search($socket,$this->sockets);
			socket_close($socket);
			$this->console($socket." DISCONNECTED!");
			if($index>=0)
			{
				array_splice($this->sockets,$index,1);
			}
		}

		protected function listen($address,$port)
		{
			$socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
			if($socket === false)
				return false;
			if(socket_set_option($socket, SOL_SOCKET, SO_REUSEADDR, 1) === false)
				return false;
			if(socket_bind($socket, $address, $port) === false)
				return false;
			if(socket_listen($socket, 20) === false)
				return false;
			$this->console("Server Started : ".date('Y-m-d H:i:s'));
			$this->console("Master socket  : ".$socket);
			$this->console("Listening on   : ".$address." port ".$port."\n");
			return $socket;
		}

		// auth_cb($accountname,$password) => returns true / false
		// cmd_cb($accountname,$cmd,$params) => returns the reply msg or false
		function run($address,$port,$auth_cb,$cmd_cb)
		{
			error_reporting(E_ALL);
			set_time_limit(0);
			ob_implicit_flush();

  			$this->master = $this->listen($address,$port);
  			if($this->master == false)
  				return false;

  			$this->sockets = array($this->master);
  			$this->users = array();

			while(true)
			{
				usleep(10000); // rate limit in case of errors

				$e = NULL;
				$changed = $this->sockets;
				$result = socket_select($changed,$e,$e,0);
				if($result === false)
					break;

				foreach($changed as $socket)
				{
					if($socket==$this->master)
					{
						$client = socket_accept($this->master);
						if($client<0)
							continue;

						$this->connect($client);
					}
					else
					{
						$bytes = @socket_recv($socket,$buffer,2048,0);
						if($bytes==false)
						{
							$this->console($socket." ERROR: ".socket_strerror(socket_last_error($socket)));
							$this->disconnect($socket);
							continue;
						}

						$this->inBuffer .= $buffer;

						while(($lineEnd = strpos($this->inBuffer, "\n")) !== false)
						{
							$line = substr($this->inBuffer, 0, $lineEnd);
							$this->inBuffer = substr($this->inBuffer, $lineEnd+1);

							if(strlen($line)>0)
							{
								$user = $this->getuserbysocket($socket);
								if(!$user->handshake)
								{
									if(!$this->dohandshake($user,$line,$auth_cb))
									{
										$this->console($socket." HANDSHAKE FAILED!");
										$this->disconnect($socket);
										break;
									}
								}
								else
								{
									$this->process($user,$line,$cmd_cb);
								}
							}
						}
					}
				}
			}

			foreach($this->sockets as $socket)
				socket_close($socket);

			if($this->master !== false)
				socket_close($this->master);		
		}
	}

?>
