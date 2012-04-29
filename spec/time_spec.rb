require 'spec_helper'

describe Time do
  it 'should be able to set date on a time' do
    xmas = Date.new(2012, 12, 25)
    lunch_time = Time.parse("12:00")
    xmas_lunch = lunch_time.on_date(xmas)
    xmas_lunch.year.should == 2012
    xmas_lunch.month.should == 12
    xmas_lunch.day.should == 25
    xmas_lunch.hour.should == 12
    xmas_lunch.min.should == 0
    xmas_lunch.sec.should == 0
  end

  it "should allow setting the date part given a date" do
    time = Time.parse("2010-01-01 09:30:00")
    time.on_date(Date.parse("2012-12-31")).should eql Time.parse("2012-12-31 09:30:00")
  end
end

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

    it 'should accept a date' do
      lambda { @time.on_date(Date.today) }.should_not raise_error(ArgumentError)
    end

    it 'should return the same time on the specified date' do
      @date = Date.today - 2345
      expected = Time.local(@date.year, @date.month, @date.day, @time.hour, @time.min, @time.sec)
      @time.on_date(@date).should == expected
    end
  end

  it "should provide 'on' as an alias" do
    expected = Time.local(@year, @month, @day, @time.hour, @time.min, @time.sec)
    @time.on(@year, @month, @day).should == expected
  end
end
