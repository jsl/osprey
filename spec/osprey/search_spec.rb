require File.join(File.dirname(__FILE__),  %w[ .. spec_helper ])

describe Osprey::Search do
  describe "initialization" do
    it "should initialize without error" do
      Osprey::Search.new('bar')
    end
    
    it "should create a new instance of the default backend" do
      Osprey::Search.new('bar').instance_variable_get(:@backend).should be_a(Osprey::Backend::Memory)
    end
  end

  it "should set the attr accessor for the term" do 
    tr = Osprey::Search.new('foo')
    tr.term.should == 'foo'
  end

  describe "#fetch" do
    before do
      @tr = Osprey::Search.new('swine flu')
      @curl = mock('curl')
      @curl.expects(:response_code).returns(200)
      @swine_flu_json = File.read(File.join(File.dirname(__FILE__), %w[.. fixtures swine_flu1.json]))
      @curl.expects(:body_str).returns(@swine_flu_json)
      Curl::Easy.expects(:perform).with('http://search.twitter.com/search.json?q=swine+flu').returns(@curl)
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

      it "should have all results respond affirmatively to new_record?" do
        @results.each{|t| t.new_record?.should be_true}
      end
    end

    describe "when there are existing results for a term" do
      before do
        @curl.expects(:response_code).returns(200)
        
        @swine_flu_json = File.read(File.join(File.dirname(__FILE__), %w[.. fixtures swine_flu2.json]))
        @curl.expects(:body_str).returns(@swine_flu_json)
        Curl::Easy.expects(:perform).with('http://search.twitter.com/search.json?q=swine+flu').returns(@curl)        
        @results = @tr.fetch
      end
      
      it "should have 4 records that are not marked as new" do
        @results.select{|r| r.new_record? }.size.should == 4
      end
    end
  end
end