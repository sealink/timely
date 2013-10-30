require 'spec_helper'
require 'timely/rails/extensions'

describe Timely::Extensions do
  before do
    class TimelyExtensionsTestSeasonal < ActiveRecord::Base
      self.table_name = 'seasonals'
      acts_as_seasonal
    end
  end

  after { Object.send(:remove_const, 'TimelyExtensionsTestSeasonal') }

  it 'should cache boundary start' do
    season = Timely::Season.new
    season.date_groups.build(:start_date => Date.current, :end_date => Date.current + 2)
    season.date_groups.build(:start_date => Date.current - 1, :end_date => Date.current + 1)
    season.save!

    o = TimelyExtensionsTestSeasonal.new
    o.season = season
    o.save!
    o.boundary_start.should == Date.current - 1
    o.boundary_end.should   == Date.current + 2

    TimelyExtensionsTestSeasonal.season_on(Date.current + 3).should be_empty
    TimelyExtensionsTestSeasonal.season_on(Date.current + 2).should == [o]
    TimelyExtensionsTestSeasonal.season_on(Date.current - 1).should == [o]
    TimelyExtensionsTestSeasonal.season_on(Date.current - 2).should be_empty

  end
end
