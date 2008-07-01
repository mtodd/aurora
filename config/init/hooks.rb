# = Hooks
Halcyon::Application.startup do |config|
  
  # Connect to the DB
  Aurora::DB = Sequel.connect(Halcyon.db)
  Aurora::DB.logger = self.logger if $DEBUG
  self.logger.info 'Connected to Database.'
  
  # Clean expired sessions/tokens
  Aurora::DB[:tokens].filter('expires_at < ?',Time.now).delete
  self.logger.info 'Expired sessions/tokens removed.'
  
  # Hook up the Authenticator
  authenticator = config[:authenticator]
  require Halcyon.root/'lib'/'authenticator'/authenticator
  ::Users.__send__ :include, Aurora::Authenticator.const_get(authenticator.camel_case.to_sym)
  self.logger.info "#{authenticator.camel_case} Authenticator loaded."
  
  # Process default permission rules
  Aurora.process_rules!
  
end
