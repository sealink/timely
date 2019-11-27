# frozen_string_literal: true

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
    season.date_groups.build(start_date: Date.current, end_date: Date.current + 2)
    season.date_groups.build(start_date: Date.current - 1, end_date: Date.current + 1)
    season.save!

    o = TimelyExtensionsTestSeasonal.new
    o.season = season
    o.save!
    expect(o.boundary_start).to eq Date.current - 1
    expect(o.boundary_end).to eq Date.current + 2
  end
end
