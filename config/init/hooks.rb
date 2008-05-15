# = Hooks
Halcyon::Application.startup do |config|
  # Connect to the DB
  Aurora::DB = Sequel(Halcyon.db)
  Aurora::DB.logger = self.logger if $DEBUG
  self.logger.info 'Connected to Database.'
  
  # Run migrations (if out of date)
  current_version = Sequel::Migrator.get_current_migration_version(Aurora::DB)
  latest_version = Sequel::Migrator.apply(Aurora::DB, Halcyon.root/'lib'/'migrations')
  self.logger.info 'Migrations loaded!' if current_version < latest_version
  
  # Clean expired sessions/tokens
  Aurora::DB[:tokens].filter('expires_at < ?',Time.now).delete
  self.logger.info 'Expired sessions/tokens removed.'
  
  # Hook up the Authenticator
  authenticator = config[:authenticator]
  require Halcyon.root/'lib'/'authenticator'/authenticator
  ::Users.__send__ :include, Aurora::Authenticator.const_get(authenticator.camel_case.to_sym)
  self.logger.info "#{authenticator.camel_case} Authenticator loaded."
  
  # Process default permission rules
  Aurora::Rules = Halcyon::Runner.load_config(Halcyon.root/'config'/'default_permissions.yml')[:rules]
  Aurora.process_rules!
  self.logger.info "Default Permissions: rules loaded."
end
