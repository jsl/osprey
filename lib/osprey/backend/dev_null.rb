module Osprey
  module Backend
    
    # Class exists for cases where you don't want Osprey to remember what 
    # it has fetched.
    class DevNull
      
      def initialize(options = { }) 
      end

      def get(url)
      end
    
      def set(url, result) 
      end
      
    end
  end
end