# frozen_string_literal: true

require 'spec_helper'

describe Timely::Season, 'in general' do
  before do
    # 1st and 3rd Quarter
    @simple_low_season = Timely::Season.new
    @simple_low_season.date_groups.build(start_date: '2009-01-01'.to_date, end_date: '2009-03-31'.to_date)
    @simple_low_season.date_groups.build(start_date: '2009-07-01'.to_date, end_date: '2009-09-30'.to_date)

    # 2nd and 4th Quarter
    @simple_high_season = Timely::Season.new
    @simple_high_season.date_groups.build(start_date: '2009-04-01'.to_date, end_date: '2009-06-30'.to_date)
    @simple_high_season.date_groups.build(start_date: '2009-10-01'.to_date, end_date: '2009-12-31'.to_date)
  end

  it 'be able to tell if a date is in or out of its season' do
    low_season_date = '2009-02-22'.to_date
    high_season_date = '2009-04-22'.to_date

    expect(@simple_low_season.includes_date?(low_season_date)).to be true
    expect(@simple_high_season.includes_date?(low_season_date)).to_not be true

    expect(@simple_low_season.includes_date?(high_season_date)).to_not be true
    expect(@simple_high_season.includes_date?(high_season_date)).to be true
  end

  it 'should be able to tell the boundary range (the range including the absolute first and last date) of itself' do
    expect(@simple_low_season.boundary_range).to eq('2009-01-01'.to_date..'2009-09-30'.to_date)
    expect(@simple_high_season.boundary_range).to eq('2009-04-01'.to_date..'2009-12-31'.to_date)
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
