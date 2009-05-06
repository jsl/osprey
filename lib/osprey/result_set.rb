module Osprey
  
  # Container for sets of tweets.
  class ResultSet < Array
    attr_accessor :etag
    
    # Returns all records.
    def records
      self
    end
    
    # Returns only records that are new in the most recent fetch.
    def new_records
      self.select{|r| r.new_record == true}
    end
  end
end