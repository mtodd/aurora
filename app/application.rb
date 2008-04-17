class Application < Halcyon::Controller
  
  # The default unauthorized action which raises an Unauthorized exception
  def unauthorized
    raise Unauthorized.new
  end
  
  #--
  # Utility methods
  #++
  
  # Sets up a given user's permissions. Overwrite this method to specify more
  # specific or dynamic default permissions, for instance connecting to LDAP
  # to determine department and granting permissions that way.
  def initialize_permissions(username)
  	Aurora.initialize_permissions(username)
  end
  
  # Generates a new time to expire from the minutes given, defaulting to the
  # number of minutes given as a token lifetime in the configuration file.
  def generate_expiration(lifetime = Halcyon.config[:tokens][:lifetime])
  	(Time.now + (lifetime.to_i*60))
  end
  
end
