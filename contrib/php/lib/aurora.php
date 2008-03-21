<?php

// The locaton of the Halcyon PHP client (a dependency) is
// http://github.com/mtodd/halcyon.
if(!defined(Halcyon)) require_once(dirname(__FILE__).'/lib/halcyon.php');

class Aurora extends Halcyon {
  
  const VERSION = "0.1.0";
  
  private $app = null;
  
  public function __construct($uri, $app, $headers = array()) {
    $this->app = $app;
    parent::__construct($uri, $headers);
  }
  
  // def authenticate(options = {})
  //   user, pass = options[:username], options[:password]
  //   token = options[:token]
  //   if user && pass
  //     post("/user/auth/#{user}", :password => pass)[:body] rescue false
  //   elsif token
  //     get("/token/auth/#{token}") rescue false 
  //   else
  //     false
  //   end
  // end
  public function authenticate($options = array()) {
    if(isset($options['username']) && isset($options['password'])) {
      $response = $this->post("/user/auth/{$options['username']}", array('password' => $options['password']));
      if($response->status == 200) {
        $response = $response->body;
      } elseif($response->status == 401) {
        $response = false;
      } else {
        throw new HalcyonError("[{$response->status}] {$response->body}");
      }
      return $response;
    } elseif(isset($options['token'])) {
      $response = $this->get("/token/auth/{$options['token']}");
      if($response->status == 200) {
        $response = $response->body;
      } elseif($response->status == 401) {
        $response = false;
      } else {
        throw new HalcyonError("[{$response->status}] {$response->body}");
      }
      return $response;
    } else {
      return false;
    }
  }
  
  // def permit?(user, permission)
  //   get("/user/#{user}/#{@app}/permit/#{permission}")[:body]
  // end
  public function check_permission($user, $permission) {
    return $this->get("/user/{$user}/{$this->app}/permit/{$permission}")->body;
  }
  
  // def permit!(user, permission, value)
  //   post("/user/#{user}/#{@app}/permit/#{permission}", :value => value)[:body]
  // end
  public function ensure_permission($user, $permission, $value) {
    return $this->post("/user/{$user}/{$this->app}/permit/{$permission}", array('value' => $value))->body;
  }
  
}

?>