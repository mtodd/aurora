# = Required Libraries
%w(sequel digest/md5).each {|dep|require dep}

# = Initialization
class Halcyon::Application
  
  # Makes sure the Database server connection is created, tables migrated, and
  # expired tokens are cleaned.
  startup do |config|
    # connect to database
    host = credentials = ''
    host = "#{config[:db][:host]}/" unless config[:db][:host].nil?
    credentials = "#{config[:db][:username]}:#{config[:db][:password]}@" unless config[:db][:username].nil?
    @db = Sequel("#{config[:db][:adapter]}://#{credentials}#{host}#{config[:db][:database]}")
    @db.logger = self.logger if $debug
    self.logger.info 'Connected to Database.'
    
    # run migrations if version is outdated
    current_version = Sequel::Migrator.get_current_migration_version(@db)
    latest_version = Sequel::Migrator.apply(@db, File.join(File.dirname(__FILE__),'..','lib','migrations'))
    self.logger.info 'Migrations loaded!' if current_version < latest_version
    
    # clean expired sessions/tokens
    @db[:tokens].filter('expires_at < ?',Time.now).delete
    self.logger.info 'Expired sessions/tokens removed.'
    
    # Hook up the Authenticator
    authenticator = config[:authenticator]
    require Halcyon.root/'config'/authenticator
    ::Users.__send__ :include, Aurora::Authenticator.const_get(authenticator.camel_case.to_sym)
    self.logger.info "#{authenticator.camel_case} Authenticator loaded."
  end
  
  # = Routes
  route do |r|
    # authentication routes
    r.match('/user/auth/:username').to(:controller => 'users', :action => 'auth')
    r.match('/token/auth/:token').to(:controller => 'tokens', :action => 'auth')
    
    # user routes
    r.match('/user/show/:username').to(:controller => 'users', :action => 'show')
    
    # token routes
    r.match('/token/destroy/:token').to(:controller => 'tokens', :action => 'destroy')
    
    # permission routes
    r.match('/user/:username/:app/permissions').to(:controller => 'users', :action => 'permisisons')
    r.match('/user/:username/:app/permit/:permission').to(:controller => 'users', :action => 'permit')
    
    # generic
    r.match('/:controller/:action/:id').to()
    r.match('/:controller/:action').to()
    r.match('/:action/:id').to()
    r.match('/:action').to()
    
    # failover
    {:action => 'not_found'}
  end
  
end
