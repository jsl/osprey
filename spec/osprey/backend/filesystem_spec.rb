require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

describe Osprey::Backend::Filesystem do
  before do
    @backend = Osprey::Backend::Filesystem.new({:path => '/tmp'})
  end
  
  it_should_behave_like "all backends"
  
  it "should accept a Hash of options for inialization" do
    Osprey::Backend::Filesystem.new({:path => '/tmp'})
  end
  
  describe "#filename_for" do
    it "should default to the users' home path plus the MD5 of the normalized URL" do
      MD5.expects(:hexdigest).returns('bah')
      uri = mock('uri')
      uri.expects(:normalize).returns('foo')
      URI.expects(:parse).returns(uri)
      Osprey::Backend::Filesystem.new({:path => '/tmp'}).__send__(:filename_for, 'hey').should == '/tmp/bah'
    end
  end
end