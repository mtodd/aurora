<?php

// Update the path to the Halcyon client if otherwise located.
require_once(dirname(__FILE__).'/../lib/halcyon.php');
require_once(dirname(__FILE__).'/../lib/aurora.php');

if(isset($argv[1]) && isset($argv[2])) {
  $username = $argv[1];
  $password = $argv[2];
} elseif(isset($argv[1])) {
  $token = $argv[1];
} else {
  exit(
    "Authentication failed: you must supply either a username and a password, or a token.\n" .
    "Usage: php client.php (<username> <password>|<token>)\n"
  );
}

$client = new Aurora('http://localhost:6467/', 'xyzzy');
$client->header('Authorization', 'YXV0aGVudGljYXRvcjpPY2ggZGVuIHNvbSBpbnRlIGhlbGFuIHRhck8gaGFu\nIGVqIGhlbGxlciBoYWx2YW4gZmFySw==');

if(isset($token)) {
  if($token = $client->authenticate(array('token' => $token))) {
    print("Authenticated with {$token}.\n");
  } else {
    print("Failed to authenticate.\n");
  }
} elseif(isset($username) && isset($password)) {
  if($token = $client->authenticate(array('username' => $username, 'password' => $password))) {
    print("Authenticated as {$username}.\n");
    print("Token: {$token}\n");
  } else {
    print("Failed to authenticate as {$username}.\n");
  }
}

?>
