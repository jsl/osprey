require 'rubygems'
require 'singleton'
require 'curb'
require 'CGI'
require 'json'
require 'sequel'
require 'memcache'
require 'ostruct'

lib_dirs =  [ 'core_ext', File.join('osprey', 'backend'), 'osprey' ].map do |d|
  File.join(File.dirname(__FILE__), d)
end

lib_dirs.each do |d|
  Dir[File.join(d, "*.rb")].each {|file| require file }
end
