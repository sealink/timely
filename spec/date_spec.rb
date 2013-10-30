require 'spec_helper'

describe Date do
  it 'should determine if date between' do
    Date.today.between?(nil, nil).should == true
    Date.today.between?(Date.today - 1, Date.today - 1).should == false
    Date.today.between?(Date.today - 1, nil).should == true
  end
end

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
      expect { @date.at_time(@hour, @minute, @second) }.to_not raise_error
    end

    it 'should accept hour and minute' do
      expect { @date.at_time(@hour, @minute) }.to_not raise_error
    end

    it 'should accept hour' do
      expect { @date.at_time(@hour) }.to_not raise_error
    end

    it 'should accept no arguments' do
      expect { @date.at_time }.to_not raise_error
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

    it 'should accept a time' do
      expect { @date.at_time(Time.now) }.to_not raise_error
    end

    it 'should return the passed-in time on the date' do
      @time = Time.now - 12345
      expected = Time.local(@date.year, @date.month, @date.day, @time.hour, @time.min, @time.sec)
      @date.at_time(@time).should == expected
    end
  end

  it "should provide 'at' as an alias" do
    expected = Time.local(@date.year, @date.month, @date.day, @hour, @minute, @second)
    @date.at(@hour, @minute, @second).should == expected
  end
end
