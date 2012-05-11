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

  it "should correctly find the interesection between two date ranges" do
    @date_range = Timely::DateRange.new("2000-01-03".to_date, "2000-01-06".to_date)
    @date_range.intersecting_dates(Timely::DateRange.new("2000-01-04".to_date, "2000-01-07".to_date)).should == ("2000-01-04".to_date.."2000-01-06".to_date)
    @date_range.intersecting_dates(Timely::DateRange.new("2000-01-01".to_date, "2000-01-02".to_date)).should == []
    @date_range.intersecting_dates(Timely::DateRange.new("2000-01-01".to_date, "2000-01-03".to_date)).should == ("2000-01-03".to_date.."2000-01-03".to_date)
    @date_range.intersecting_dates(Timely::DateRange.new("2000-01-06".to_date, "2000-01-07".to_date)).should == ("2000-01-06".to_date.."2000-01-06".to_date)
    @date_range.intersecting_dates(Timely::DateRange.new("2000-01-06".to_date, "2000-01-07".to_date)).should == ("2000-01-06".to_date.."2000-01-06".to_date)
    @date_range.intersecting_dates(Timely::DateRange.new("2000-01-04".to_date, "2000-01-05".to_date)).should == ("2000-01-04".to_date.."2000-01-05".to_date)
    @date_range.intersecting_dates(Timely::DateRange.new("2000-01-05".to_date, "2000-01-05".to_date)).should == ("2000-01-05".to_date.."2000-01-05".to_date)

    @date_range = Timely::DateRange.new("2000-01-03".to_date, "2000-01-03".to_date)
    @date_range.intersecting_dates(Timely::DateRange.new("2000-01-04".to_date, "2000-01-07".to_date)).should == []
    @date_range.intersecting_dates(Timely::DateRange.new("2000-01-01".to_date, "2000-01-03".to_date)).should == ("2000-01-03".to_date.."2000-01-03".to_date)
    @date_range.intersecting_dates(Timely::DateRange.new("2000-01-03".to_date, "2000-01-05".to_date)).should == ("2000-01-03".to_date.."2000-01-03".to_date)
    @date_range.intersecting_dates(Timely::DateRange.new("2000-01-02".to_date, "2000-01-04".to_date)).should == ("2000-01-03".to_date.."2000-01-03".to_date)
  end
  
end
