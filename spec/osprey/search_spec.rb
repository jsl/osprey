require File.join(File.dirname(__FILE__),  %w[ .. spec_helper ])

describe Osprey::Search do
  describe "initialization" do
    it "should initialize without error" do
      Osprey::Search.new('bar')
    end
    
    it "should create a new instance of the default backend" do
      Osprey::Search.new('bar').instance_variable_get(:@backend).should be_a(HashBack::Backend)
    end
  end

  it "should set the attr accessor for the term" do 
    tr = Osprey::Search.new('foo')
    tr.term.should == 'foo'
  end

  describe "#fetch" do
    before do
      @tr = Osprey::Search.new('swine flu')
    end
    
    describe "when the backend does not contain a previous result set" do
      before do  
        @curl = mock('curl')
        @curl.expects(:response_code).returns(200)
        @swine_flu_json = File.read(File.join(File.dirname(__FILE__), %w[.. fixtures swine_flu1.json]))
        @curl.expects(:body_str).returns(@swine_flu_json)
        Curl::Easy.expects(:perform).with('http://search.twitter.com/search.json?rpp=50&q=swine+flu').returns(@curl)
        @results = @tr.fetch
      end

      describe "on the initial request of a term" do
        it "should return a Osprey::ResultSet" do
          @results.should be_a(Osprey::ResultSet)
        end

        it "should contain 15 results" do
          @results.size.should == 15
        end

        it "should contain all Osprey::Tweet items" do
          @results.each{|t| t.should be_a(Osprey::Tweet) }      
        end

        it "should have all results respond affirmatively to new_record" do
          @results.each{|t| t.new_record.should be_true}
        end
      end
    end
    
    describe "when the backend does contain a previous result set" do
      before do
        @curl.expects(:response_code).returns(200)
        @backend = mock('backend')
        @backend.expects(:[]).with('twitter-id-pool').twice
        @backend.expects(:[]).with(@tr.__send__(:url_key)).returns(YAML.load_file(File.join(File.dirname(__FILE__), %w[.. fixtures swine_flu_result_set1.yml])))
        @backend.expects(:[]=).twice
        @tr.instance_variable_set(:@backend, @backend)
        @swine_flu_json = File.read(File.join(File.dirname(__FILE__), %w[.. fixtures swine_flu2.json]))
        @curl.expects(:body_str).returns(@swine_flu_json)
        Curl::Easy.expects(:perform).with('http://search.twitter.com/search.json?rpp=50&q=swine+flu&since_id=1701715308').returns(@curl)        
        @results = @tr.fetch
      end
      
      it "should have 4 records that are not marked as new" do
        @results.select{|r| r.new_record }.size.should == 4
      end
    end

    describe "when feed ids are listed in the pool" do
      before do
        @curl.expects(:response_code).returns(200)
        @backend = mock('backend')
        @backend.expects(:[]).with('twitter-id-pool').twice.returns([1701715308, 1701714956])
        @backend.expects(:[]).with(@tr.__send__(:url_key)).returns(nil)
        @backend.expects(:[]=).twice
        @tr.instance_variable_set(:@backend, @backend)
        @swine_flu_json = File.read(File.join(File.dirname(__FILE__), %w[.. fixtures swine_flu1.json]))
        @curl.expects(:body_str).returns(@swine_flu_json)
        Curl::Easy.expects(:perform).with('http://search.twitter.com/search.json?rpp=50&q=swine+flu').returns(@curl)        
        @results = @tr.fetch
      end
      
      it "should return 13 elements in new_records" do
        @results.new_records.size.should == 13
      end
    end
  end
  
  describe "#url_key" do
    it "should create a key with the MD5 hexdigest of the term" do
      term = 'swine flu'
      @tr = Osprey::Search.new(term)
      @tr.__send__(:url_key).should == "term-#{MD5.hexdigest(term)}"
    end
  end
  
  describe "#url" do
    before do
      @tr = Osprey::Search.new('swine flu')
      @results = YAML.load_file(File.join(File.dirname(__FILE__), %w[.. fixtures swine_flu_result_set1.yml]))
    end
    
    it "should include the greatest ID in since_if of the given set if results are present" do 
      url = @tr.__send__(:url, @results)
      url.should =~ /since_id=1701715308/
    end
    
    it "should not contain since_id if the previous results are nil" do
      url = @tr.__send__(:url, nil)
      url.should_not =~ /since_id/      
    end
    
    it "should not contain since_id if the previous results contain no records" do
      url = @tr.__send__(:url, [])
      url.should_not =~ /since_id/      
    end
    
    it "should contain an option rpp (results per page) that is set to the @options[:rpp] value" do
      url = @tr.__send__(:url, [])
      url.should =~ /rpp=50/      
    end
  end
end