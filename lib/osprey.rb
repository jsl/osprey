require 'rubygems'
require 'singleton'
require 'curb'
require 'hashback'
require 'json'
require 'memcache'
require 'ostruct'
require 'cgi'

lib_dirs =  [ 'core_ext', 'osprey' ].map do |d|
  File.join(File.dirname(__FILE__), d)
end

lib_dirs.each do |d|
  Dir[File.join(d, "*.rb")].each {|file| require file }
end
