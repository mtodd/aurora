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

%w(rubygems halcyon/client).each {|dep|require dep}

#--
# module
#++

module Aurora
  
  # = Aurora Client
  # 
  # The Aurora Client makes interfacing with the Aurora server very simple and
  # easy, hiding away most of the communication details while still allowing
  # for a great deal of control in creating requests for the server.
  class Client < Halcyon::Client::Base
    
    attr_accessor :app_id
    
    def self.version
      VERSION.join('.')
    end
    
    # Initialies the Aurora client, expecting the Aurora server to connect to
    # and the application to represent itself as to query permissions and such
    # against. The App ID can also be used to configure default permissions for
    # newly created user accounts (from fresh LDAP auths, for instance).
    def initialize(uri, app)
      @app_id = app
      super uri
    end
    
    # Performs an authentication action against the current Aurora server.
    # 
    # Expects a Hash with either a <tt>:username</tt> and <tt>:password</tt>
    # pair or a single <tt>:token</tt> option. The server authentication
    # method is called accordingly.
    def authenticate(options = {})
      user, pass = options[:username], options[:password]
      token = options[:token]
      if user && pass
        post("/user/auth/#{user}", :password => pass)[:body] rescue false
      elsif token
        get("/token/auth/#{token}") rescue false 
      else
        false
      end
    end
    
    def permit?(user, app, permission)
      get("/user/#{user}/#{app}/permit/#{permission}")[:body]
    end
    
    def permit!(user, app, permission, value)
      post("/user/#{user}/#{app}/permit/#{permission}", :value => value)[:body] rescue false
    end
    
  end
  
end
