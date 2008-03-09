require 'digest/md5'

module Aurora
  module Authenticator
    
    # A simple authenticator
    class Simple # < Aurora::Authenticator::Base # needed?
      
      CREDENTIALS = {
        # USERNAME => PASSWORD
        'test' => 'secret',
        'rupert' => 'swazey',
        'awesome' => 'foo',
        'user' => 'pass'
      }.inject({}) do |result, (user, pass)|
        result[user] = Digest::MD5.hexdigest(pass)
        result
      end
      
      # Simply authenticates against a pair in the CREDENTIALS constant.
      def authenticate(user, pass)
        Digest::MD5.hexdigest(pass) == CREDENTIALS[user]
      end
      
    end
  end
end
