# = Routes
Halcyon::Application.route do |r|
  # authentication routes
  r.match('/user/auth/:username').to(:controller => 'users', :action => 'auth')
  r.match('/token/auth/:token').to(:controller => 'tokens', :action => 'auth')
  
  # user routes
  r.match('/user/show/:username').to(:controller => 'users', :action => 'show')
  
  # token routes
  r.match('/token/destroy/:token').to(:controller => 'tokens', :action => 'destroy')
  
  # permission routes
  r.match('/user/:username/:app/permissions').to(:controller => 'users', :action => 'permissions')
  r.match('/user/:username/:app/permit/:permission').to(:controller => 'users', :action => 'permit')
  
  # generic
  r.default_routes
  
  # failover
  {:action => 'not_found'}
end
