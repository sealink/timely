require 'spec_helper'

describe Timely::Season, "in general" do
  before do
    # 1st and 3rd Quarter
    @simple_low_season = Timely::Season.new
    @simple_low_season.date_groups.build(:start_date => '2009-01-01'.to_date, :end_date => '2009-03-31'.to_date)
    @simple_low_season.date_groups.build(:start_date => '2009-07-01'.to_date, :end_date => '2009-09-30'.to_date)
    @simple_low_season.save!

    # 2nd and 4th Quarter
    @simple_high_season = Timely::Season.new
    @simple_high_season.date_groups.build(:start_date => '2009-04-01'.to_date, :end_date => '2009-06-30'.to_date)
    @simple_high_season.date_groups.build(:start_date => '2009-10-01'.to_date, :end_date => '2009-12-31'.to_date)
    @simple_high_season.save!
  end

  it "be able to tell if a date is in or out of its season" do
    low_season_date = '2009-02-22'.to_date
    high_season_date = '2009-04-22'.to_date

    @simple_low_season.includes_date?(low_season_date).should be_true
    @simple_high_season.includes_date?(low_season_date).should_not be_true

    @simple_low_season.includes_date?(high_season_date).should_not be_true
    @simple_high_season.includes_date?(high_season_date).should be_true
  end

  it "should be able to tell the boundary range (the range including the absolute first and last date) of itself" do
    @simple_low_season.boundary_range.should eql('2009-01-01'.to_date..'2009-09-30'.to_date)
    @simple_high_season.boundary_range.should eql('2009-04-01'.to_date..'2009-12-31'.to_date)
  end
end


describe Timely::DateGroup do
  before do
    @date_group = Timely::DateGroup.create!(
      :start_date => '2000-01-01', :end_date => '2000-01-03', :weekdays => %w(1 1 1 1 1 1 1)
    )
  end

  it 'should detect overlaps' do
    @date_group.applicable_for_duration?(Timely::DateRange.new('2000-01-01'.to_date, '2000-01-01'.to_date)).should be_true
    @date_group.applicable_for_duration?(Timely::DateRange.new('2000-01-01'.to_date, '2000-01-06'.to_date)).should be_true
    @date_group.applicable_for_duration?(Timely::DateRange.new('2001-01-01'.to_date, '2001-01-01'.to_date)).should be_false
  end
end


describe Timely::Season, 'when asked to build season for given dates' do
  before do
    @dates = [Date.current + 1, Date.current + 4, Date.current + 5]
  end

  it "should generate proper season" do
    season = Timely::Season.build_season_for(@dates)
    season.class.should == Timely::Season
    season.date_groups.size.should == 3
    season.date_groups.first.start_date.should == (Date.current + 1)
    season.date_groups.last.start_date.should == (Date.current + 5)
    season.date_groups.last.end_date.should == (Date.current + 5)
    @dates = []
    season = Timely::Season.build_season_for(@dates)
    season.class.should == Timely::Season
    season.date_groups.size.should == 0
  end



end


# == Schema Information
#
# Table name: seasons
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

