module Osprey
  
  # Primary interface to the Osprey Twitter search library.
  class Search
    attr_reader :term
    
    DEFAULTS = {
      :backend => {
        :klass => Osprey::Backend::Memory
      },
      :rpp => 50,
      :preserved_tweet_ids => 10_000
    } unless defined?(DEFAULTS)

    # Initializes the Osprey::Search client.
    #
    # Usage:
    # 
    #   search = Osprey::Search.new(term, options)
    #   results = search.fetch
    #
    # Options
    # 
    # :backend -  
    #   The backend used for storing the serialized representation of the last fetch of
    #   this query.
    # 
    # :preserved_tweet_ids - 
    #   The number of Tweet ids that will be preserved.  This ensures that we're able to detect if
    #   running different queries returns the same tweet in order to not mark that tweet as a new
    #   record.  Choosing a higher number here will mean some additional processing time for each
    #   new tweet, and a small amount of increased storage.  The default should be a decent compromise
    #   between performance needs while still not seeing duplicate tweets show up as new records.
    #
    # :rpp - 
    #   Requests per page. Determines the results to fetch from Twitter.  Defaults to 50.
    #
    # :since_id -
    #   Tells twitter to only give us results with an ID greater than the given ID.  Supplied by
    #   default in URL string if previous results were found.    
    def initialize(term, options = { })
      @term    = term
      @options = options.reverse_merge(DEFAULTS)
      @backend = initialize_backend(@options[:backend][:klass])
    end
    
    def fetch
      p_results = previous_results
      
      res = Curl::Easy.perform(url(p_results))
            
      if res.response_code == 200
        parse_tweets(res, p_results)
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
      klass.new(@options[:backend])
    end

    # Returns an Array of ids for the Tweets in result
    def twitter_ids_from_json_result(json)
      json['results'].map{|r| r['id'].to_i }
    end
    
    def twitter_ids_in(id_list)
      id_list
    end

    # Determines the etag from the request headers.  Method from Paul Dix's Feedzirra.
    # 
    # === Parameters
    # [header<String>] Raw request header returned from the request
    # === Returns
    # A string of the etag or nil if it cannot be found in the headers.
    def etag_from_header(header)
      header =~ /.*ETag:\s(.*)\r/
      $1
    end
    
    def parse_tweets(curl, p_results)
      json = JSON.parse(curl.body_str)
      
      res      = Osprey::ResultSet.new
      id_pool  = twitter_id_pool
      
      json['results'].each do |t|
        new_record = p_results.detect{|rec| rec.twitter_id == t['id'] }.nil? && !id_pool.include?(t['id'])
        res << Osprey::Tweet.new(t.merge(:new_record => new_record, :twitter_id => t['id']))
      end

      add_to_twitter_id_pool(res.new_records)
      
      # Store the results from this fetch, unless this set is empty and the previous set is not empty.      
      if res.empty? && !p_results.nil?
        res = p_results
        res.each{|r| r.new_record = false}
      end
      
      @backend.set(url_key, res)
      
      res
    end

    # Returns an Array of recently-fetched Twitter IDS, or an empty Array
    # if the backend doesn't have any previous results.
    def twitter_id_pool
      @backend.get(twitter_id_pool_key) || [ ]
    end

    # Adds the given new tweet ids to the twitter id pool so that subsequent requests,
    # even if they're for other terms, won't see these tweets as new.
    def add_to_twitter_id_pool(tweets)
      @backend.set(twitter_id_pool_key, ( twitter_id_pool | tweets.map{|t| t.twitter_id} ).sort.reverse.uniq[1..@options[:preserved_tweet_ids]] )
    end

    def twitter_id_pool_key
      %w[twitter id pool].join('-')
    end

    # Returns an Array of results from the previous fetch, or an empty
    # Array if no previous results are detected.
    def previous_results
      @backend.get(url_key) || [ ]      
    end

    # Returns the backend string that will be used for the storage of this term.
    # Effectively namespaces the urls so that we can use the backend modules for 
    # storage of other things like a pool of recently read twitter ids.
    def url_key
      ['search', 'term', @term].join('-')
    end

    # Returns the Twitter search URL for @term
    def url(previous_response)
      url = "http://search.twitter.com/search.json?rpp=#{@options[:rpp]}&q=#{CGI.escape(@term)}"

      unless previous_response.nil? || previous_response.empty?
        last_response_id = previous_response.records.map{|r| r.twitter_id}.sort.last
        url += "&since_id=#{last_response_id}"
      end

      url
    end
    
  end
end