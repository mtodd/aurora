#!/usr/bin/env ruby
#--
#  Created by Matt Todd on 2007-12-14.
#  Copyright (c) 2007. All rights reserved.
#++

$:.unshift File.dirname(__FILE__)

#--
# dependencies
#++

%w(aurora/support/hashext).each {|dep|require dep}

class Hash
  include HashExt::Keys
end

#--
# module
#++

module Aurora
  VERSION = [0,1,1]
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
  # For documentation on using Aurora, check out the Halcyon::Server and
  # Halcyon::Client classes which contain much more usage documentation.
  def introduction
    abort "READ THE DAMNED RDOCS!"
  end
  
end

# %w(aurora/exceptions).each {|dep|require dep}
