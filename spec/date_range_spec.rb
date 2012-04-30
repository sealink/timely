require 'spec_helper'

describe Timely::DateRange do
  
  it "should allow initialization with two dates" do
    lambda { @date_range = Timely::DateRange.new(Date.today, Date.today + 3) }.should_not raise_error
    @date_range.start_date.should eql Date.today
    @date_range.end_date.should eql Date.today + 3
  end
  
  it "should allow initialization with one date" do
    lambda { @date_range = Timely::DateRange.new(Date.today) }.should_not raise_error
    @date_range.start_date.should eql Date.today
    @date_range.end_date.should eql Date.today
  end
  
  it "should allow initialization with a range" do
    lambda { @date_range = Timely::DateRange.new(Date.today..Date.today + 3) }.should_not raise_error
    @date_range.start_date.should eql Date.today
    @date_range.end_date.should eql Date.today + 3
  end
  
end
