# = Token Module
# 
# Token actions, including authentication and destroying tokens. Tokens
# represent authenticated sessions allowing for faster repeated
# authentication requests in a short period of time (such as each page load
# in a larger web application).
class Tokens < Application
  
  # Authenticates the token.
  def auth
    # expire_tokens # TODO: investigate how much of a performance hit checking (and deleting) is
    unless @db[:tokens].filter('token = ? AND expires_at > ?', params[:token], Time.now).all.empty?
      # authenticated
      
      # update the expiration date if close to expiring
      unless @db[:tokens].filter('token = ? AND expires_at <= ?', params[:token], generate_expiration(15)).all.empty?
      	@db[:tokens].filter(:token => params[:token]).update(:expires_at => generate_expiration)
      end
      
      # return success and token for client
      ok(params[:token])
    else
      # failed authentication
      raise Exceptions::Unauthorized.new
    end
  end
  
  def destroy
    @db[:tokens].filter(:token => params[:token]).delete
    ok
  end
  
end
