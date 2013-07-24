require 'spec_helper'

describe Timely::TemporalPatterns do

  before(:all) do
    @from = Date.new(2012, 1, 1)
    @to   = Date.new(2013, 4, 1)
  end

  it "should be able to create a basic 1st-of-the-month recurrence pattern" do
    pattern = Timely::TemporalPatterns::Pattern.new([@from..@to], 1.month)
    pattern.to_s.should == "every 1st of the month from 2012-01-01T00:00:00+00:00 to 2013-04-01T00:00:00+00:00"

    pattern.match?('01-05-2012'.to_date).should == true
    pattern.match?('01-08-2012'.to_date).should == true
    pattern.match?('01-04-2013'.to_date).should == true

    pattern.match?('03-05-2012'.to_date).should == false
    pattern.match?('01-06-2013'.to_date).should == false
  end

  it "should only allow a positive duration to be set as the frequency of the pattern" do
    lambda { Timely::TemporalPatterns::Frequency.new(2) }.should raise_error(ArgumentError)
    lambda { Timely::TemporalPatterns::Frequency.new(-5.months) }.should raise_error(ArgumentError)
    Timely::TemporalPatterns::Frequency.new(3.months).to_s.should == "every 3 months"
  end

end
