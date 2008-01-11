%w(rubygems halcyon aurora/server).each{|dep|require dep}

# A simple authentication server
class Simple < Aurora::Server
  
  # Simply authenticates that the user is 'test' and the password is 'secret'
  def authenticate(user, pass)
    user == 'test' && pass == 'secret' or true
  end
  
end
