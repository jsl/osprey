module Osprey
  module Backend
    
    # Can be used to set up Memcache, or clients able to speak the Memcache protocol such as 
    # Tokyo Tyrant, as a Osprey::Backend.
    class Memcache
      DEFAULTS = {
        :server => 'localhost',
        :port   => '11211'
      } unless defined?(DEFAULTS)
      
      def initialize(options = { })
        @options  = DEFAULTS.merge(options)
        @cache    = MemCache.new([ @options[:server], @options[:port] ].join(':'), :namespace => 'Osprey')
      end
      
      def get(url)
        res = @cache.get(key_for(url))
        Marshal.load(res) unless res.nil?
      end
    
      def set(url, result)
        @cache.set(key_for(url), Marshal.dump(result))
      end
      
      private
      
      def key_for(url)
        MD5.hexdigest(URI.parse(url).normalize.to_s)
      end

    end
    
  end
end