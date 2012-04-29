require 'spec_helper'

describe Timely::TrackableDateSet, ' tracking 7 days' do
  before do
    @range = Date.today..(Date.today + 6)
    @trackable_date_set = Timely::TrackableDateSet.new(@range)
  end

  it "should start on the first date" do
    @trackable_date_set.start_date.should == Date.today
  end

  it "should end on the last date" do
    @trackable_date_set.end_date.should == Date.today + 6
  end

  it "should have the 7 days set" do
    get_dates.should == @range.to_a
    @trackable_date_set.duration.should == 7
    @trackable_date_set.number_of_nights.should == 7
  end

  it "should have all the 7 days to do" do
    get_dates_to_do.should == @range.to_a
    should_not_have_done(@range.to_a)
  end

  it "should have only the last 6 days to do when we set_done! the first one" do
    @trackable_date_set.set_date_done!(Date.today)
    get_dates_to_do.should == ((Date.today + 1)..(Date.today + 6)).to_a

    should_not_have_done(@range.to_a - [Date.today])
    should_have_done([Date.today])
  end

  it "should have the first, and last three left to do if we set 2nd, 3rd & 4th to be done" do
    dates_to_be_done = [Date.today + 1, Date.today + 2, Date.today + 3]
    @trackable_date_set.set_dates_done!(dates_to_be_done)

    get_dates_to_do.should == [Date.today, Date.today + 4, Date.today + 5, Date.today + 6]
    should_not_have_done(@range.to_a - dates_to_be_done)
    should_have_done(dates_to_be_done)
  end

  it "should have none left to do when set_all_done!" do
    @trackable_date_set.set_all_done!
    get_dates_to_do.should == []
    should_have_done(@range.to_a)
  end

  it 'should have no actions applied' do
    @trackable_date_set.action_applied?(:some_action).should == false
  end

  it 'should remember if we apply an action' do
    @trackable_date_set.apply_action(:some_action)
    @trackable_date_set.action_applied?(:some_action).should == true
    @trackable_date_set.action_applied?(:some_other_action).should == false
  end

  def should_have_done(dates)
    dates.each{|date| @trackable_date_set.has_done?(date).should == true }
  end

  def should_not_have_done(dates)
    dates.each{|date| @trackable_date_set.has_done?(date).should == false }
  end

  def get_dates
    contained_dates = []
    @trackable_date_set.each_date{|date| contained_dates << date}
    contained_dates
  end

  def get_dates_to_do
    contained_dates = []
    @trackable_date_set.each_date_to_do{|date| contained_dates << date}
    contained_dates
  end
end
