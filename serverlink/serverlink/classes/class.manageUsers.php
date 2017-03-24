<?php

	include_once(__DIR__.'/class.database.php');
	include_once(__DIR__.'/../config.php');

	class manageUsers
	{
		public $link;

		function __construct()
		{
			$db_connection = new dbConnection();
			$this->link = $db_connection->connect();
			return $this->link;
		}

		function sendValidationCode($username)
		{
			global $server_url;

			$query = $this->link->prepare("SELECT * FROM users WHERE username=?");
			$query->execute(array($username));
			$rowcount = $query->rowCount();
			if($rowcount != 1)
				return false;

			$result = $query->fetchAll();
			$user = $result[0];
			if(isset($user['validation_code']) && $user['validation_code']!=0)
			{
				$code = $user['validation_code'];
			}
			else
			{
				$code = uniqid();
				$query = $this->link->prepare("UPDATE users SET validation_code=? WHERE username=?");
				$query->execute(array($code, $username));
				$rowcount = $query->rowCount();
				if($rowcount != 1)
					return false;
			}

			$to = $user['email'];
			$subject = "Please validate your account!";
			$message = "Please validate your account by clicking the following link: $server_url/validate.php?username=$username&code=$code";
			$headers = "From:ComboWhore <noreply@combowhore.com>";
			mail($to, $subject, $message, $headers);

			return true;
		}

		function validateUser($username,$code)
		{
			$query = $this->link->prepare("SELECT * FROM users WHERE username=?");
			$query->execute(array($username));
			$rowcount = $query->rowCount();
			if($rowcount != 1)
				return false;

			$result = $query->fetchAll();
			$user = $result[0];

			if($user['user_status'] == 1)
				return true;

			if(!isset($user['validation_code']) || strcmp($user['validation_code'],$code)!=0)
				return false;

			$query = $this->link->prepare("UPDATE users SET user_status=1 WHERE username=?");
			$query->execute(array($username));
			$rowcount = $query->rowCount();
			if($rowcount != 1)
				return false;

			return true;
		}

		function registerUser($username,$password,$email,$ip_address,$admin)
		{
			$query = $this->link->prepare("INSERT INTO users (username,password,email,ip_address,admin) VALUES (?,?,?,?,?)");
			$query->execute(array($username,$password,$email,$ip_address,$admin));
			$counts = $query->rowCount();
			return $counts;
		}

		function editUser($username,$values)
		{
			$result = 1;
			foreach($values as $key=>$value)
			{
				$query = $this->link->prepare("UPDATE users SET $key=? WHERE username=?");
				$query->execute(array($value,$username));
				if($query->errorCode()!=0)
					$result = 0;
				elseif($key=='username')
					$username = $value;
			}
			return $result;
		}

		function deleteUser($username)
		{
			$query = $this->link->prepare("DELETE FROM users WHERE username=? LIMIT 1");
			$query->execute(array($username));
			$counts = $query->rowCount();
			return $counts;			
		}

		function loginUser($username,$password)
		{
			$query = $this->link->prepare("SELECT * FROM users WHERE username=? AND password=?");
			$query->execute(array($username,$password));
			$rowcount = $query->rowCount();
			if($rowcount != 1)
				return false;
			$result = $query->fetchAll();
			$user = $result[0];
			if($user['user_status'] == 0)
				return false;
			return true;
		}

		function getUserInfo($username)
		{
			$query = $this->link->prepare("SELECT * FROM users WHERE username=?");
			$query->execute(array($username));
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

		function getUserInfoById($user_id)
		{
			$query = $this->link->prepare("SELECT * FROM users WHERE id=?");
			$query->execute(array($user_id));
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

		function getUserInfoByEmail($email)
		{
			$query = $this->link->prepare("SELECT * FROM users WHERE email=?");
			$query->execute(array($email));
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

		function getAllUsers()
		{
			$query = $this->link->query("SELECT id,username,timestamp FROM users");
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
