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
    
    def self.version
      VERSION.join('.')
    end
    
    # Performs an authentication action against the current Aurora server.
    # 
    # Expects a Hash with either a <tt>:username</tt> and <tt>:password</tt>
    # pair or a single <tt>:token</tt> option. The server authentication
    # method is called accordingly.
    def authenticate(options = {})
      if (user, pass = options[:username], options[:password])
        post("/user/auth/#{user}", :password => pass)[:body] rescue false
      elsif (token = options[:token])
        get("/token/auth/#{token}") rescue false 
      else
        false
      end
    end
    
  end
  
end
