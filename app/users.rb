# = User Module
# 
# User actions, including authentication, permissions testing and
# management, and data querying.
class Users < Application
  
  #--
  # Authentication
  #++
  
  # Calls the supplied authentication method. Creates a token on success,
  # returning that token, and raises Unauthorized on failure.
  def auth
    username, password = params[:username], post[:password]
    if authenticate(username, password)
      # authenticated
      
      # generate token and expiration date
      token = Digest::MD5.hexdigest("#{username}:#{password}:#{Time.now.to_s}")
      expiration = generate_expiration
      
      # save to the DB
      self.db[:tokens].filter(:username => username).delete # removes previous tokens
      self.db[:tokens] << {:username => username, :token => token, :expires_at => expiration}
      
      # create the user if not already in the DB
      if self.db[:users].filter(:username => username).all.empty?
      	# retrieve the new user permissions
      	permissions = initialize_permissions(username)
      	
      	# create a new user
      	self.db[:users] << {:username => username, :password => Digest::MD5.hexdigest(password), :permissions => permissions.to_json}
      	self.logger.info "#{username} cached."
      else
      	# or just cache the password so the user's profile is up-to-date
      	# if the authentication source is not available
      	self.db[:users].filter(:username => username).update(:password => Digest::MD5.hexdigest(password))
      	self.logger.debug "#{username} updated."
      end
      
      # return success with token for client
      ok(token)
    else
      # failed authentication
      raise Unauthorized.new
    end
  end
  
  #--
  # General
  #++
  
  # Show user data.
  def show
    # TODO: consider removing as potentially unsafe
  end
  
  #--
  # Permissions
  #++
  
  # Request the full permissions of a given user
  def permissions
    # TODO: consider removing as potentially unsafe
    # (in the event a malicious user wants to model a super user with a real
    # super user's permissions)
  end
  
  # Handles action branching depending on the method for permission setting
  # or getting. Defers to +permit?+ and +permit!+.
  def permit
    case method
    when :get
      permit?
    when :post
      permit!
    end
  end
  
  # Does the user have permission?
  def permit?
    username, app, permission = params[:username], params[:app], params[:permission]
    
    # pull the permissions for the user
    perms = JSON.parse(@db[:users][:username => username][:permissions])
    
    # test the permissions
    unless perms[app].nil?
      ok(perms[app][permission])
    else
      # no permissions were found for the given app
      ok(false)
    end
  end
  
  # Give permissions to user
  def permit!
    username, app, permission, value = params[:username], params[:app], params[:permission], post[:value]
    
    # pull the permissions for the user
    perms = JSON.parse(@db[:users][:username => username][:permissions])
    
    # test the permissions
    unless perms[app].nil?
      if perms[app][permission] == value
        ok(true)
      else
        raise Unauthorized.new
      end
    else
      # no permissions were found for the given app
      raise Unauthorized.new
    end
  end
  
end
