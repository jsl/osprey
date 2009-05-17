module Osprey
  
  # Container for sets of tweets.
  class ResultSet < Array
    attr_accessor :etag
    
    # Returns all records.  In most cases, this will be the same as the results
    # in #new_records, since we add the id of the last tweet fetched to the query 
    # string automatically.  If Twitter somehow sends us a Tweet that we saw in a
    # previous fetch, however, this result will return all records indiscriminately
    # while the method #new_records will be populated with tweets that are really
    # ones that we haven't seen before.
    def records
      self
    end
    
    # Returns only records that are new in the most recent fetch.
    def new_records
      self.select{|r| r.new_record == true}
    end
  end
end