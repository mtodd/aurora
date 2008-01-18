#!/usr/bin/env ruby
#--
#  Created by Matt Todd on 2007-12-14.
#  Copyright (c) 2007. All rights reserved.
#++

$:.unshift File.dirname(__FILE__)

#--
# module
#++

module Aurora
  VERSION = [0,1,7]
  def self.version
    VERSION.join('.')
  end
  
  # = Introduction
  # 
  # Aurora is a simple authentication server. Built on Halcyon, it is a JSON
  # Web Server Framework intended to be used for fast, small data transactions,
  # like for AJAX-intensive sites or for special services like authentication
  # centralized for numerous web apps in the same cluster.
  # 
  # The possibilities are pretty limitless: the goal of Aurora was simply to be
  # lightweight, fast, simple to implement and use, and able to be extended.
  # 
  # == Usage
  # 
  # For documentation on using Aurora, check out the Aurora::Server and
  # Aurora::Client classes which contain much more usage documentation.
  def introduction
    abort "READ THE DAMNED RDOCS!"
  end
  
  autoload :Server, 'aurora/server'
  autoload :Client, 'aurora/client'
  
end
