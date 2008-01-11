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
  class Client
    
    def self.version
      VERSION.join('.')
    end
    
  end
  
end
