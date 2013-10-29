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


describe Timely::Season, 'when asked to build season for given dates' do
  subject(:season) { Timely::Season.build_season_for(dates) }

  context 'when three dates' do
    let(:dates) { [Date.current + 1, Date.current + 4, Date.current + 5] }
    its(:class) { should == Timely::Season }
    it { should have(3).date_groups }

    it "should generate proper date groups" do
      season.date_groups.first.start_date.should == (Date.current + 1)
      season.date_groups.last.start_date.should == (Date.current + 5)
      season.date_groups.last.end_date.should == (Date.current + 5)
    end
  end

  context 'when dates are empty' do
    let(:dates) { [] }
    its(:date_groups) { should be_empty }
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

