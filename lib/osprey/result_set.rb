module Osprey
  class ResultSet < Array
    def records
      self
    end
    
    def new_records
      self.select{|r| r.new_record?}
    end
  end
end