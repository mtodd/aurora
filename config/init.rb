# 
# = Application Configuration
# 
Halcyon.config.use do |c|
  
  # = Environment
  c[:environment] = :production
  
  # = Framework Configuration
  c[:allow_from] = 'all'
  
  # = Logging Configuration
  c[:logging] = {
    :type => 'Logger',
    :file => 'log/production.log', # unset is STDOUT
    :level => 'info',
  }
  
  # = Application Configuration
  c[:authenticator] = 'simple'
  c[:tokens] = {
    # lifetime in minutes
    :lifetime => 5
  }
  
end

# 
# = Configuration Attributes
# 
Halcyon.configurable_attr :rules
