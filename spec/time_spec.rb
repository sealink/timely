require File.dirname(__FILE__) + '/spec_helper.rb'

describe Time do
  before :each do
    @time = Time.now - 12345
    
    @year  = 2005
    @month = 3
    @day   = 15
  end
  
  it 'should give that time on a date' do
    @time.should respond_to(:on_date)
  end
  
  describe 'giving that time on a date' do
    it 'should accept year, month and day' do
      lambda { @time.on_date(@year, @month, @day) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require year, month, and day' do
      lambda { @time.on_date(@year, @month) }.should raise_error(ArgumentError)
    end
    
    it 'should return the same time on the specified year, month, and day' do
      expected = Time.local(@year, @month, @day, @time.hour, @time.min, @time.sec)
      @time.on_date(@year, @month, @day).should == expected
    end
  end
  
  it "should provide 'on' as an alias" do
    expected = Time.local(@year, @month, @day, @time.hour, @time.min, @time.sec)
    @time.on(@year, @month, @day).should == expected
  end
end
