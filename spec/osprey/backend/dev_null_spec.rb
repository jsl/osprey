require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

describe Osprey::Backend::DevNull do
  before do
    @backend = Osprey::Backend::DevNull.new
  end
  
  it_should_behave_like "all backends"
  
  it "should initialize properly" do
    Osprey::Backend::DevNull.new
  end
  
  describe "#set" do
    it "should accept two arguments" do
      lambda {
        @backend.set('foo', 'nothing') 
      }.should_not raise_error
    end
  end
  
  describe "#get" do
    it "should accept one argument" do
      lambda {
        @backend.get('foo') 
      }.should_not raise_error
    end
    
    it "should return nil even after something is set" do
      @backend.set('junk', 'something')
      @backend.get('junk').should be_nil
    end
  end
  
end