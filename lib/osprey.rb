require 'rubygems'
require 'singleton'
require 'curb'
require 'json'
require 'sequel'
require 'memcache'
require 'ostruct'

# Workaround for an issue where a Rails hack seems to try and redefine this class.
# We assume that if a Rails CGI class is loaded, we're good to go and don't need
# this dependency.
unless defined?(CGI::Cookie)
  require 'CGI'
end

lib_dirs =  [ 'core_ext', File.join('osprey', 'backend'), 'osprey' ].map do |d|
  File.join(File.dirname(__FILE__), d)
end

lib_dirs.each do |d|
  Dir[File.join(d, "*.rb")].each {|file| require file }
end
