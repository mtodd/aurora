class Application < Halcyon::Controller
  
  # The default unauthorized action which raises an Unauthorized exception
  def unauthorized
    raise Unauthorized.new
  end
  
  #--
  # Utility methods
  #++
  
  # Removes expired tokens.
  def expire_tokens
    @db[:tokens].filter('expires_at < ?',Time.now).delete
  end
  
  # Sets up a given user's permissions. Overwrite this method to specify more
  # specific or dynamic default permissions, for instance connecting to LDAP
  # to determine department and granting permissions that way.
  def initialize_permissions(username)
  	# by default, no permissions are setup
  	# the returned value is JSON-ized
  	{}
  end
  
  # Generates a new time to expire from the minutes given, defaulting to the
  # number of minutes given as a token lifetime in the configuration file.
  def generate_expiration(lifetime=@config[:tokens][:lifetime])
  	(Time.now + (lifetime.to_i*60))
  end
  
end
