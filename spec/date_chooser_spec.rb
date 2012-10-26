require 'spec_helper'

describe Timely::DateChooser do
  before(:all) do
    @from = "01-01-2011".to_date
    @to = "01-03-2011".to_date
  end

  #Validation
  it "rejects blank FROM dates" do
    lambda { Timely::DateChooser.new({:from=>""}) }.should raise_error(Timely::DateChooserException)
  end

  it "rejects TO dates later than FROM dates" do
    lambda {Timely::DateChooser.new(
      :multiple_dates => true, :from => @from + 10, :to => @from
    )}.should raise_error(Timely::DateChooserException)
  end

  #Operation
  it "returns today if client only wants single date" do
    Timely::DateChooser.new(
      :multiple_dates => false, :from => @from
    ).choose_dates.should == [@from]
  end

  #Test specific date of month
  it "returns from and to as same (one) day in the case that only from date is given" do
    Timely::DateChooser.new(
      :multiple_dates => true, :from => @from, :to => ''
    ).choose_dates.should == [@from]
  end

  it "returns all days between from and to days in the basic case" do
    Timely::DateChooser.new(
      :multiple_dates => true, :from => @from, :to => @to
    ).choose_dates.should == (@from..@to).to_a
  end

  it "returns the recurring dates within the range if this option is picked" do
    Timely::DateChooser.new(
      :multiple_dates => true, :select => 'days', :dates => '1,11,3', :from => @from, :to => @to
    ).choose_dates.should == [
      "1-01-2011", "3-01-2011", "11-01-2011", "1-02-2011",
      "3-02-2011", "11-02-2011", "1-03-2011"
    ].map(&:to_date)
  end

  it "returns the specific dates, within or outside of the range, if this option is picked" do
    Timely::DateChooser.new(
      :multiple_dates => true, :select => 'specific_days', :specific_dates => '11-01-2011, 18-02-2011, 22-06-2011', :from => @from, :to => @to
    ).choose_dates.should == [
      "11-01-2011", "18-02-2011", "22-06-2011"
    ].map(&:to_date)
  end

  #Test days of week, every X weeks
  it "returns every sunday correctly" do
    Timely::DateChooser.new(
      :multiple_dates => true, :select => 'weekdays', :from => @from, :to => @to,
      :interval => {:level => "1", :unit => "w"}, :weekdays => {:sun => true}
    ).choose_dates.should == [
      "2-01-2011", "9-01-2011", "16-01-2011", "23-01-2011", "30-01-2011",
      "06-02-2011", "13-02-2011", "20-02-2011", "27-02-2011"
    ].map(&:to_date)
  end

  it "returns every thursday and sunday correctly" do
    Timely::DateChooser.new(
      :multiple_dates => true, :select => 'weekdays',
      :interval => {:level => "1", :unit => "w"},
      :weekdays => {:sun => true, :thu => true}, :from => @from, :to => @to
    ).choose_dates.should == [
      "2-01-2011", "6-01-2011", "9-01-2011", "13-01-2011", "16-01-2011",
      "20-01-2011", "23-01-2011", "27-01-2011", "30-01-2011", "3-02-2011",
      "06-02-2011", "10-02-2011", "13-02-2011", "17-02-2011", "20-02-2011",
      "24-02-2011", "27-02-2011"
    ].map(&:to_date)
  end

  it "returns every 2nd thursday and sunday correctly" do
    Timely::DateChooser.new(
      :multiple_dates => true, :select => 'weekdays',
      :interval => {:level => "2", :unit => "w"},
      :weekdays => {:sun => "1", :thu => "1"}, :from => @from, :to => @to
    ).choose_dates.should == [
      "2-01-2011", "6-01-2011", "16-01-2011", "20-01-2011", "30-01-2011",
      "3-02-2011", "13-02-2011", "17-02-2011", "27-02-2011"
    ].map(&:to_date)
  end

  #Test correct results for every Nth week of month
  it "returns every 1st Tuesday" do
    Timely::DateChooser.new(
      :multiple_dates => true, :select => 'weekdays', :from => @from, :to => @to,
      :interval => {:level => "1", :unit => "wom"}, :weekdays => {:tue => true}
    ).choose_dates.should == ["4-01-2011", "1-02-2011", "1-03-2011"].map(&:to_date)
  end

  it "returns every 3st Monday and Friday" do
    Timely::DateChooser.new(
      :multiple_dates => true, :select => 'weekdays',
      :interval => {:level => "3", :unit => "wom"},
      :weekdays => {:mon => true, :fri => true}, :from => @from, :to => @to
    ).choose_dates.should == [
      "17-01-2011", "21-01-2011", "18-02-2011", "21-02-2011"
    ].map(&:to_date)
  end
end
