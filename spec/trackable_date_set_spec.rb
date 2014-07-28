require 'spec_helper'

describe Timely::TrackableDateSet, ' tracking 7 days' do
  before do
    @range = Date.today..(Date.today + 6)
    @trackable_date_set = Timely::TrackableDateSet.new(@range)
  end

  it "should start on the first date" do
    expect(@trackable_date_set.start_date).to eq Date.today
  end

  it "should end on the last date" do
    expect(@trackable_date_set.end_date).to eq Date.today + 6
  end

  it "should have the 7 days set" do
    expect(get_dates).to eq @range.to_a
    expect(@trackable_date_set.duration).to eq 7
    expect(@trackable_date_set.number_of_nights).to eq 7
  end

  it "should have all the 7 days to do" do
    expect(get_dates_to_do).to eq @range.to_a
    should_not_have_done(@range.to_a)
  end

  it "should have only the last 6 days to do when we set_done! the first one" do
    @trackable_date_set.set_date_done!(Date.today)
    expect(get_dates_to_do).to eq ((Date.today + 1)..(Date.today + 6)).to_a

    should_not_have_done(@range.to_a - [Date.today])
    should_have_done([Date.today])
  end

  it "should have the first, and last three left to do if we set 2nd, 3rd & 4th to be done" do
    dates_to_be_done = [Date.today + 1, Date.today + 2, Date.today + 3]
    @trackable_date_set.set_dates_done!(dates_to_be_done)

    expect(get_dates_to_do).to eq [Date.today, Date.today + 4, Date.today + 5, Date.today + 6]
    should_not_have_done(@range.to_a - dates_to_be_done)
    should_have_done(dates_to_be_done)
  end

  it "should have none left to do when set_all_done!" do
    @trackable_date_set.set_all_done!
    expect(get_dates_to_do).to eq []
    should_have_done(@range.to_a)
  end

  it 'should have no actions applied' do
    expect(@trackable_date_set.action_applied?(:some_action)).to be false
  end

  it 'should remember if we apply an action' do
    @trackable_date_set.apply_action(:some_action)
    expect(@trackable_date_set.action_applied?(:some_action)).to be true
    expect(@trackable_date_set.action_applied?(:some_other_action)).to be false
  end

  def should_have_done(dates)
    dates.each{|date| expect(@trackable_date_set.has_done?(date)).to be true }
  end

  def should_not_have_done(dates)
    dates.each{|date| expect(@trackable_date_set.has_done?(date)).to be false }
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
