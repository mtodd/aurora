require 'rack/mock'
require 'aurora/server'

$test = true

# Testing inheriting the Aurora server
class Specr < Aurora::Server
  def authenticate(user, pass)
    # if pass isn't pass then it fails... get it?
    pass == 'pass'
  end
end

# Testing modifying the aurora server's authenticate method directly
class Aurora::Server
  def authenticate(user, pass)
    # if pass isn't pass then it fails... get it?
    pass == 'pass'
  end
end
