# Contains various utility methods and data storage references.
# 
# Constants
#   +DB+ contains the reference to the Database
#   +Rules+ cached rules for determining default permissions
# 
# Utility Methods
#   +version+ returns the current Aurora iteration version string
# 
# Rules Methods
#   +process_rules!+ processes the rules to expected format
#   +initialize_permissions+ loads the user data and calls
#     +find_default_permissions_for+
#   +find_default_permissions_for!+ finds the default permissions for the user
module Aurora
  
  VERSION = [0,4,0]
  
  # The <tt>Authenticator</tt> namespace for loading authenticators.
  module Authenticator; end
  
  class << self
    
    # Returns String:VERSION.join('.')
    def version
      VERSION.join('.')
    end
    
    # Takes the rules defined in <tt>config/default_permissions.yml</tt> and
    # caches them (replacing empty rules with an empty hash).
    def process_rules!
      Halcyon.rules.collect! do |rule|
        {
          :tests => rule['tests'],
          :permissions => (rule['permissions'] || {})
        }
      end
    end
    
    # Finds the appropriate default permissions for the given username.
    # 
    # Override for loading custom user data (from ActiveDirectory, for
    # instance) to allow for greater flexibility and specificity in testing.
    def initialize_permissions(username)
      user = DB[:users][:username => username] || {:username => username, :password => nil, :permissions => nil}
      self.find_default_permissions_for(user)
    end
    
    # Finds the appropriate default permission by testing the user data against
    # the rules defined in <tt>Aurora::Rules</tt>.
    #   +Hash:user+ the user data to test against
    # 
    # Returns Hash:permissions
    def find_default_permissions_for(user)
      # make sure that the user properties are accessible with String and
      # Symbol keys
      user = user.to_mash
      
      # process the rules against the user's data
      Halcyon.rules.each do |rule|
        # use the permissions if there's no test associated
        # (for users that don't meet any of the rules before)
        return rule[:permissions] if rule[:tests].nil?
        
        rule[:tests].each do |key, value|
          # run test, skip to next rule if failure
          case value
          when String
            next unless user[key] == value
          when Regexp
            next unless user[key] =~ value
          else
            next
          end
          # passed tests, so return the permissions
          return rule[:permissions]
        end
      end
      
      # default to nothing, despite the fact that
      # there should be a rule covering all users
      {}
    end
    
  end
  
end
