<?php

require_once(dirname(__FILE__).'/../lib/aurora.php');

if(isset($ARGV[1]) && isset($ARGV[2])) {
  $username = $ARGV[1];
  $password = $ARGV[2];
} elseif(isset($ARGV[1])) {
  $token = $ARGV[1];
} else {
  exit("Authentication failed: you must supply either a username and a password, or a token.\nUsage: php client.php (<username> <password>|<token>)\n");
}

$client = new Aurora('http://localhost:6467/');

if(isset($token)) {
  if($token = $client->authenticate(array('token' => $token))) {
    print("Authenticated with {$token}\n");
  }
} elseif(isset($username) && isset($password)) {
  if($token = $client->authenticate(array('username' => $username, 'password' => $password))) {
    print("Authenticated as {$username}\n");
    print("Token: {$token}\n");
  }
}

?>