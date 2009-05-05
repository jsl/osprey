module Osprey
  module Backend
    
    # Class exists for cases where you don't want Feedzirra to remember what 
    # it has fetched.  If this backend is selected, user needs to pass arguments
    # in the form of a Feed object to the Reader class to help Feedzirra know when
    # a page hasn't changed, and which feed entries have been updated.
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