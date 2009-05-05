require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

describe Osprey::Backend::Memcache do
  before do
    @backend = Osprey::Backend::Memcache.new({:server => 'localhost', :port => 11211})
    @cache = mock('cache')
    @backend.instance_variable_set(:@cache, @cache)
  end
  
  it_should_behave_like "all backends"  

  describe "#get" do
    it "should call #get on the cache" do
      @cache.expects(:get)
      @backend.get('foo')
    end    
  end
  
  describe "#set" do  
    it "should call #set on the cache" do
      @cache.expects(:set)
      @backend.set('foo', 'hey')
    end
  end
end