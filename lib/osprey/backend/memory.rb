module Osprey
  module Backend
    
    # Memory store uses a ruby Hash to store the results of feed fetches.
    # It won't persist after the application exits.
    class Memory
      
      def initialize(options = { })
        @store = { }
      end
      
      def get(url)
        @store[url]
      end
    
      def set(url, result)
        @store[url] = result
      end
      
    end
  end
end