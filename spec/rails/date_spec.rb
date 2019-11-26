# frozen_string_literal: true

require 'spec_helper'

describe Date do
  let(:date) { Date.parse('2010-01-01') }

  before { Time.zone = ActiveSupport::TimeZone['Adelaide'] }

  subject(:converted) { date.to_time_in_time_zone }

  it 'should convert to time in time zone' do
    expect(converted.year).to eq date.year
    expect(converted.month).to eq date.month
    expect(converted.day).to eq date.day
    expect(converted.time_zone).to eq Time.zone
  end
end
