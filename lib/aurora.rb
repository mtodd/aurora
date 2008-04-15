# Contains various utility methods and data storage references.
# 
# Constants
#   +DB+ contains the reference to the Database
# 
# Utility Methods
#   +version+ returns the current Aurora iteration version string
module Aurora
  
  VERSION = [0,3,0]
  
  class << self
    
    # Returns String:VERSION.join('.')
    def version
      VERSION.join('.')
    end
    
  end
  
  module Authenticator; end
  
end
