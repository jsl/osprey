require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

describe Osprey::Backend::Memory do
  before do
    @backend = Osprey::Backend::Memory.new
  end
  
  it_should_behave_like "all backends"  
  
  it "should initialize properly" do
    Osprey::Backend::Memory.new
  end
  
end