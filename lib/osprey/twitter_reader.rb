module Osprey
  class TwitterReader
    attr_reader :term
    
    DEFAULTS = {
      :backend => {
        :klass => Osprey::Backend::Memory
      }
    } unless defined?(DEFAULTS)
    
    def initialize(term, options = { })
      @term = term
      @options = options.reverse_merge(DEFAULTS)
      @backend = initialize_backend(@options[:backend][:klass])
    end
    
    def run            
      res = Curl::Easy.perform(url)
      
      if res.response_code == 200
        parse_tweets(res.body_str)
      else
        $stderr.puts "Received invalid twitter response code of #{res.response_code}."
      end
    end
    
    private
    
    # Initializes the on-disk structure that keeps track of the Twitter ids that 
    # we've seen.  We use a sql lite data store because it handles concurrency
    # for us, which is important if there are multiple threads hitting the data
    # store.
    def initialize_backend(klass)
      klass.new
    end

    # Returns an Array of ids for the Tweets in result
    def twitter_ids_from_json_result(json)
      json['results'].map{|r| r['id'].to_i }
    end
    
    def twitter_ids_in(id_list)
      id_list
    end
    
    def parse_tweets(json_text)
      json = JSON.parse(json_text)

      res = Osprey::ResultSet.new
      
      presults = previous_results
      
      json['results'].each do |t|
        new_record = presults.detect{|rec| rec.twitter_id == t['id'] }.nil?
        res << Osprey::Tweet.new(t.merge(:new_record? => new_record, :twitter_id => t['id']))
      end

      @backend.set(url, res)
      
      res
    end

    def previous_results
      @backend.get(url) || [ ]      
    end

    # Returns the Twitter search URL for @term
    def url
      "http://search.twitter.com/search.json?q=#{CGI.escape(@term)}"
    end
    
  end
end