# = Environment
# 
# Sets the environment unless already set.
# 
# Creates the <tt>Halcyon.environment</tt> configurable attribute. Since this
# is mapped to <tt>Halcyon.config[:environment]</tt>, environment can be set
# by setting the <tt>environment:</tt> configuration value in the
# <tt>config/config.yml</tt> file.

# Halcyon.configurable_attr(:environment)
# Do not use the <tt>Halcyon.configurable_attr</tt> method because it isn't able
# to transform the environment to a symbol when being asked for it. Also, it's
# faster this way.

module Halcyon
  class << self
    
    # Return the environment value. Defaults to the <tt>development</tt>
    # environment.
    # 
    # Returns Symbol:environment
    def environment
      (self.config[:environment] || :development).to_sym
    end
    
    # Setes the environment value.
    #   +env+ the environment value
    # 
    # Returns Symbol:environment
    def environment=(env)
      self.config[:environment] = env
    end
    
  end
end

# Set the default environment
# Halcyon.environment = :development unless Halcyon.environment
# Not needed.
