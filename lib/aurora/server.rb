#!/usr/bin/env ruby
#--
#  Created by Matt Todd on 2008-01-11.
#  Copyright (c) 2008. All rights reserved.
#++

$:.unshift File.dirname(File.join('..', __FILE__))
$:.unshift File.dirname(__FILE__)

#--
# dependencies
#++

%w(rubygems aurora halcyon/server sequel digest/md5).each {|dep|require dep}

#--
# module
#++

module Aurora
  
  # = Aurora Server
  # 
  # The Aurora Server handles user authentication requests, token creation and
  # management, and permissions querying and verification.
  # 
  # == Usage
  # 
  #   class Aurora::Server
  #     def authenticate(username, password)
  #       username == 'test' && password == 'secret'
  #     end
  #   end
  # 
  # This will define an authentication processor for verifying users'
  # authenticity. This method is only defaulted to when token authentication
  # is not able to be used (such as for creating sessions), so its use should
  # be minimized by token authentication.
  class Server < Halcyon::Server::Base
    
    def self.version
      VERSION.join('.')
    end
    
    route do |r|
      # authentication routes
      r.match('/user/auth/:username').to(:module => 'user', :action => 'auth')
      r.match('/token/auth/:token').to(:module => 'token', :action => 'auth')
      
      # user routes
      r.match('/user/show/:username').to(:module => 'user', :action => 'show')
      
      # token routes
      r.match('/token/destroy/:token').to(:module => 'token', :action => 'destroy')
      
      # permission routes
      r.match('/user/:username/permissions').to(:module => 'user', :action => 'permisisons')
      r.match('/user/:username/permit/:permission').to(:module => 'user', :action => 'permit')
      
      # failover
      {:action => 'unauthorized'}
    end
    
    # Makes sure the Database server connection is created, tables migrated,
    # and other tasks.
    def startup
      # TODO: setup startup tasks
      
      # connect to database
      @db = Sequel("#{@config[:db][:adapter]}://#{@config[:db][:username]}:#{@config[:db][:password]}@#{@config[:db][:host]}/#{@config[:db][:database]}")
      @logger.info 'Connected to Database.'
      
      # run migrations if version is outdated
      current_version = Sequel::Migrator.get_current_migration_version(@db)
      latest_version = Sequel::Migrator.apply(@db, File.join(File.dirname(__FILE__),'migrations'))
      @logger.info 'Migrations loaded!' if current_version < latest_version
      
      # clean expired sessions/tokens
      expire_tokens
      @logger.info 'Expired sessions/tokens removed.'
    end
    
    # = User Module
    # 
    # User actions, including authentication, permissions testing and
    # management, and data querying.
    user do
      
      #--
      # Authentication
      #++
      
      # Calls the supplied authentication method. Creates a token on success,
      # returning that token, and raises Unauthorized on failure.
      def auth(params)
        username, password = params[:username], @req.POST['password']
        if authenticate(username, password)
          # authenticated
          token = Digest::MD5.hexdigest("#{username}:#{password}:#{Time.now.to_s}")
          expiration = (Time.now + (@config[:tokens][:lifetime].to_i*60))
          @db[:tokens].filter(:username => username).delete # removes previous tokens
          @db[:tokens] << {:username => username, :token => token, :expires_at => expiration}
          ok(token)
        else
          # failed authentication
          raise Exceptions::Unauthorized.new
        end
      end
      
      #--
      # General
      #++
      
      # Show user data.
      def show(params)
        # TODO: consider removing as potentially unsafe
      end
      
      #--
      # Permissions
      #++
      
      # Request the full permissions of a given user
      def permissions(params)
        # TODO: consider removing as potentially unsafe
        # (in the event a malicious user wants to model a super user with a real
        # super user's permissions)
      end
      
      # Handles action branching depending on the method for permission setting
      # or getting. Defers to +permit?+ and +permit!+.
      def permit(params)
        case method
        when :get
          permit?(params)
        when :post
          permit!(params)
        end
      end
      
      # Does the user have permission?
      def permit?(params)
        # TODO: implement permission checking
      end
      
      # Give permissions to user
      def permit!(params)
        # TODO: implement permission management
      end
      
    end
    
    # = Token Module
    # 
    # Token actions, including authentication and destroying tokens. Tokens
    # represent authenticated sessions allowing for faster repeated
    # authentication requests in a short period of time (such as each page load
    # in a larger web application).
    token do
      
      # Authenticates the token.
      def auth(params)
        expire_tokens
        unless @db[:tokens].filter('token = ?', params[:token]).empty?
          # authenticated
          ok(params[:token])
        else
          # failed authentication
          raise Exceptions::Unauthorized.new
        end
      end
      
      def destroy(params)
        # TODO: destroy token forcefully
      end
      
    end
    
    # The default unauthorized action which raises an Unauthorized exception
    def unauthorized(params)
      raise Exceptions::Unauthorized.new
    end
    
    #--
    # Utility methods
    #++
    
    # Removes expired tokens.
    def expire_tokens
      @db[:tokens].filter('expires_at < ?',Time.now).delete
    end
    
  end
  
end
