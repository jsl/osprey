module Osprey
  
  # Primary interface to the Osprey Twitter search library.
  class Search
    attr_reader :term
    
    DEFAULTS = {
      :backend => {
        :moneta_klass   => 'Moneta::Memory',
      },
      :rpp => 50,
      :preserved_tweet_ids => 10_000
    } unless defined?(DEFAULTS)

    # Initializes the Osprey::Search client.
    #
    # Usage (Basic):
    # 
    #   search = Osprey::Search.new(term, options)
    #   results = search.fetch
    #
    # Usage (Custom Backend):
    #
    #   o = Osprey::Search.new('Swine Flu', { :backend => { :moneta_klass => 'Moneta::Memcache', :server => 'localhost:1978' } })
    #   results = o.fetch
    # 
    # Options:
    #
    # The Osprey::Search library supports options for customizing the parameters that will be passed to Twitter as well
    # as to the local backend for keeping track of state.
    # 
    # - _backend_ - A hash of options which are passed directly to the Moneta class used as key-value store.  The 
    #   value for this option should be another Hash containing configuration options for the backend.  Keys supported
    #   by the backend hash:
    # 
    #   - _moneta_backend_ - The backend used for storing the serialized representation of the last fetch of
    #     this query.  Uses Moneta, a unified interface to key-value storage systems.  This value may be a String, 
    #     in which case the appropriate Moneta library will be automatically required, or a class constant.  If a 
    #     class constant is given, it is up to the calling user to require the appropriate Moneta library before referring
    #     to the constant in the initialization of Osprey::Search.
    #
    #   - _other_options_  - Any other options given to the backend hash will be passed directly to the Moneta class 
    #     used as key-value store for configuration.  Please see the documentation for the appropriate Moneta class for
    #     options supported.
    # 
    # - _preserved_tweet_ids_ - The number of Tweet ids that will be preserved.  This ensures that we're able to detect if
    #   running different queries returns the same tweet in order to not mark that tweet as a new
    #   record.  Choosing a higher number here will mean some additional processing time for each
    #   new tweet, and a small amount of increased storage.  The default should be a decent compromise
    #   between performance needs while still not seeing duplicate tweets show up as new records.
    #
    # - _rpp_ - Requests per page. Determines the results to fetch from Twitter.  Defaults to 50.
    #
    # - _since_id_ - Tells twitter to only give us results with an ID greater than the given ID.  Supplied by
    #   default in URL string if previous results were found.    
    def initialize(term, options = { })
      @term    = term
      @options = options.reverse_merge(DEFAULTS)
      @backend = initialize_backend(@options[:backend][:moneta_klass], @options[:backend].except(:moneta_klass))
    end
    
    # Returns a Osprey::ResultSet object containing Osprey::Tweet objects for the tweets found for query.
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
    
    # Initializes the structure that keeps track of the Twitter ids that we've seen.
    def initialize_backend(klass, options)
      HashBack::Backend.new('Osprey', klass, options)
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
      
      @backend[url_key] = res
      
      res
    end

    # Returns an Array of recently-fetched Twitter IDS, or an empty Array
    # if the backend doesn't have any previous results.
    def twitter_id_pool
      # This is a hack to deal with the fact that the backend seems to return an empty Hash when 
      # a Moneta::Memory store has an uninitialized value.  TODO - take a closer look at this later
      # and see if Moneta needs to be patched or if it's something screwy in the way we're using it.
      res = @backend[twitter_id_pool_key]
      res.nil? || res == { } ? [ ] : res
    end

    # Adds the given new tweet ids to the twitter id pool so that subsequent requests,
    # even if they're for other terms, won't see these tweets as new.
    def add_to_twitter_id_pool(tweets)
      pool = twitter_id_pool
      @backend[twitter_id_pool_key] = 
        ( pool | tweets.map{|t| t.twitter_id} ).sort.reverse.uniq[1..@options[:preserved_tweet_ids]]
    end

    def twitter_id_pool_key
      %w[twitter id pool].join('-')
    end

    # Returns an Array of results from the previous fetch, or an empty
    # Array if no previous results are detected.
    def previous_results
      @backend[url_key] || [ ]
    end

    # Returns the backend string that will be used for the storage of this term.
    # Effectively namespaces the urls so that we can use the backend modules for 
    # storage of other things like a pool of recently-read twitter ids.
    def url_key
      term_hash = MD5.hexdigest(@term)
      ['term', term_hash].join('-')
    end

    # Returns the Twitter search URL for @term.  Merges the last response ID into the query string
    # if we have previous results for this query.  This eliminates most duplication from previous 
    # results and decreases transfer size.
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