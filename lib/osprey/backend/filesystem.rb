require 'md5'
require 'uri'

module Osprey
  module Backend
    class Filesystem
      
      DEFAULTS = {
        :path => File.expand_path(File.join(%w[ ~ / .osprey ]))
      } unless defined?(DEFAULTS)
      
      def initialize(options = { })
        @options = DEFAULTS.merge(options)
      end
      
      def get(url)
        f = filename_for(url)
        Marshal.load(File.read(f)) if File.exist?(f)
      end
    
      def set(url, result)
        File.open(filename_for(url), 'w') {|f| f.write(Marshal.dump(result)) }
      end
      
      private
      
      def filename_for(url)
        File.join(@options[:path], MD5.hexdigest(URI.parse(url).normalize.to_s))
      end
    end
  end
end