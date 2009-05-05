require File.join(File.dirname(__FILE__),  %w[ .. spec_helper ])

describe Osprey::ResultSet do
  before do
    @rs = YAML.load_file(File.join(File.dirname(__FILE__), %w[.. fixtures result_set.yml]))
  end
  
  it "should return 4 results for #new_records" do
    @rs.new_records.size.should == 4
  end
  
  it "should return 15 results for #records" do
    @rs.records.size.should == 15
  end
end