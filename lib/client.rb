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
    
    attr_accessor :app
    
    def self.version
      VERSION.join('.')
    end
    
    # Initialies the Aurora client, expecting the Aurora server to connect to
    # and the application to represent itself as to query permissions and such
    # against. The App ID can also be used to configure default permissions for
    # newly created user accounts (from fresh LDAP auths, for instance).
    def initialize(uri, app)
      @app = app
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
    
    def permit?(user, permission)
      get("/user/#{user}/#{@app}/permit/#{permission}")[:body]
    end
    
    def permit!(user, permission, value)
      post("/user/#{user}/#{@app}/permit/#{permission}", :value => value)[:body]
    end
    
  end
  
end

require 'net/https'

module Halcyon
  class Client
    
    class Base
      
    private
      
      def request(req, headers={})
        # define essential headers for Halcyon::Server's picky requirements
        req["Content-Type"] = CONTENT_TYPE
        req["User-Agent"] = USER_AGENT
        
        # apply provided headers
        headers.each do |pair|
          header, value = pair
          req[header] = value
        end
        
        # provide hook for modifying the headers
        req = headers(req) if respond_to? :headers
        
        # prepare and send HTTP request
        serv = Net::HTTP.new(@uri.host, @uri.port)
        serv.use_ssl = true if @uri.scheme == 'https'
        res = serv.start {|http|http.request(req)}
        
        # parse response
        body = JSON.parse(res.body)
        body.symbolize_keys!
        
        # handle non-successes
        raise Halcyon::Client::Base::Exceptions.lookup(body[:status]).new unless res.kind_of? Net::HTTPSuccess
        
        # return response
        body
      rescue Halcyon::Exceptions::Base => e
        # log exception if logger is in place
        raise
      end
      
    end
    
  end
end