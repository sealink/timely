require 'spec_helper'

describe DateTime do
  let(:date_time) { parse_time("2010-01-01 00:00:00") }

  it "should allow advancing by calendar days" do
    expect(date_time.advance_considering_calendar(:calendar_days, 10))
      .to eq parse_time("2010-01-10 23:59:59")
  end

  it "should allow advancing by calendar months" do
    expect(date_time.advance_considering_calendar(:calendar_months, 10))
      .to eq parse_time("2010-10-31 23:59:59")
  end

  it "should allow advancing by calendar years" do
    expect(date_time.advance_considering_calendar(:calendar_years, 10))
      .to eq parse_time("2019-12-31 23:59:59")
  end

  def parse_time(time)
    # ActiveSupport 5.1+ returns end of day differently
    # Returns with usec at 999999 vs 0
    DateTime.parse(time).end_of_day
  end
end
