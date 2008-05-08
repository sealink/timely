require File.dirname(__FILE__) + '/spec_helper.rb'

describe Date do
  before :each do
    @date = Date.today - 5
    
    @hour   = 1
    @minute = 2
    @second = 3
  end
  
  it 'should give a time on that date' do
    @date.should respond_to(:at_time)
  end
  
  describe 'giving a time on that date' do
    it 'should accept hour, minute, and second' do
      lambda { @date.at_time(@hour, @minute, @second) }.should_not raise_error(ArgumentError)
    end
    
    it 'should accept hour and minute' do
      lambda { @date.at_time(@hour, @minute) }.should_not raise_error(ArgumentError)
    end
    
    it 'should accept hour' do
      lambda { @date.at_time(@hour) }.should_not raise_error(ArgumentError)
    end
    
    it 'should accept no arguments' do
      lambda { @date.at_time }.should_not raise_error(ArgumentError)
    end
    
    it 'should return a time for the given hour, minute, and second if all three are specified' do
      expected = Time.local(@date.year, @date.month, @date.day, @hour, @minute, @second)
      @date.at_time(@hour, @minute, @second).should == expected
    end
    
    it 'should default second to 0 if unspecified' do
      expected = Time.local(@date.year, @date.month, @date.day, @hour, @minute, 0)
      @date.at_time(@hour, @minute).should == expected
    end
    
    it 'should default minute to 0 if unspecified' do
      expected = Time.local(@date.year, @date.month, @date.day, @hour, 0, 0)
      @date.at_time(@hour).should == expected
    end
    
    it 'should default hour to 0 if unspecified' do
      expected = Time.local(@date.year, @date.month, @date.day, 0, 0, 0)
      @date.at_time.should == expected
    end
  end
  
  it "should provide 'at' as an alias" do
    expected = expected = Time.local(@date.year, @date.month, @date.day, @hour, @minute, @second)
    @date.at(@hour, @minute, @second).should == expected
  end
end
