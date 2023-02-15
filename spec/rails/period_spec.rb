# frozen_string_literal: true

require 'spec_helper'
require 'timecop'

require 'timely/rails/period'

describe Timely::Period do
  before do
    Timecop.freeze(Time.new(2000, 1, 10, 12, 0, 0))
  end
  after { Timecop.return }

  let(:time) { DateTime.new(2000, 1, 1, 12, 0, 0) }
  let(:period_after_time) { DateTime.new(2000, 1, 1, 12, 2, 0) }
  subject(:period) { Timely::Period.new(2, :minutes) }

  let(:period_in_seconds) { Timely::Period.new(1, :seconds) }
  let(:period_in_minutes) { Timely::Period.new(1, :minutes) }
  let(:period_in_hours) { Timely::Period.new(1, :hours) }
  let(:period_in_days) { Timely::Period.new(1, :days) }
  let(:period_in_weeks) { Timely::Period.new(1, :weeks) }
  let(:period_in_months) { Timely::Period.new(1, :months) }
  let(:period_in_years) { Timely::Period.new(1, :years) }
  let(:period_in_calendar_days) { Timely::Period.new(2, :calendar_days) }
  let(:period_in_calendar_months) { Timely::Period.new(1, :calendar_months) }
  let(:period_in_calendar_years) { Timely::Period.new(1, :calendar_years) }

  it 'should work' do
    expect(period.after(time)).to eq period_after_time
    expect(period_in_seconds.to_seconds).to eq 1
    expect(period_in_minutes.to_seconds).to eq 60
    expect(period_in_hours.to_seconds).to eq 3600
    expect(period_in_days.to_seconds).to eq 86400
    expect(period_in_weeks.to_seconds).to eq 604800
    expect(period_in_months.to_seconds).to eq 2629746
    expect(period_in_years.to_seconds).to eq 31556952
    expect(period_in_calendar_days.to_seconds.round).to eq 129600
    expect(period_in_calendar_months.to_seconds.round).to eq 1857600
    expect(period_in_calendar_years.to_seconds.round).to eq 30801600
  end

  specify do
    expect(period.to_s).to eq '2 minutes'
  end
end
