require 'spec_helper'

describe Timely::DateRange do
  
  it "should allow initialization with two dates" do
    expect { @date_range = Timely::DateRange.new(Date.today, Date.today + 3) }.to_not raise_error
    expect(@date_range.start_date).to eq Date.today
    expect(@date_range.end_date).to eq Date.today + 3
    expect(@date_range.number_of_nights).to eq 4
  end
  
  it "should allow initialization with one date" do
    expect { @date_range = Timely::DateRange.new(Date.today) }.to_not raise_error
    expect(@date_range.start_date).to eq Date.today
    expect(@date_range.end_date).to eq Date.today
    expect(@date_range.number_of_nights).to eq 1
  end
  
  it "should allow initialization with a range" do
    expect { @date_range = Timely::DateRange.new(Date.today..Date.today + 3) }.to_not raise_error
    expect(@date_range.start_date).to eq Date.today
    expect(@date_range.end_date).to eq Date.today + 3
  end

  it 'should print a readable version of time between two dates' do
    expect(Timely::DateRange.new('2000-01-04'.to_date, '2000-01-04'.to_date).to_s).to eq '2000-01-04'
    expect(Timely::DateRange.new('2000-01-04'.to_date, '2000-01-06'.to_date).to_s).to eq '2000-01-04 to 2000-01-06 (inclusive)'
    expect(Timely::DateRange.new('2000-01-01'.to_date, '2000-05-31'.to_date).to_s).to eq 'Jan 2000 to May 2000'
    expect(Timely::DateRange.new('2000-01-01'.to_date, '2000-01-31'.to_date).to_s).to eq 'Jan 2000'
    Date::DATE_FORMATS[:short] = '%Y-%m-%d'
    expect(Timely::DateRange.to_s('2000-01-01'.to_date, nil)).to eq 'on or after 2000-01-01'
    expect(Timely::DateRange.to_s(nil, '2000-01-31'.to_date)).to eq 'on or before 2000-01-31'
    expect(Timely::DateRange.to_s(nil, nil)).to eq 'no date range'
  end

  it 'should handle params' do
    today = Timely::DateRange.from_params('2000-01-04')
    expect(today.first).to eq '2000-01-04'.to_date
    expect(today.last).to eq '2000-01-04'.to_date

    today = Timely::DateRange.from_params('2000-01-04', '2')
    expect(today.first).to eq '2000-01-04'.to_date
    expect(today.last).to eq '2000-01-05'.to_date

    today = Timely::DateRange.from_params('2000-01-04', 2)
    expect(today.first).to eq '2000-01-04'.to_date
    expect(today.last).to eq '2000-01-05'.to_date
  end

  it "should correctly find the interesection between two date ranges" do
    @date_range = Timely::DateRange.new("2000-01-03".to_date, "2000-01-06".to_date)
    expect(@date_range.intersecting_dates(Timely::DateRange.new("2000-01-04".to_date, "2000-01-07".to_date))).to eq ("2000-01-04".to_date.."2000-01-06".to_date)
    expect(@date_range.intersecting_dates(Timely::DateRange.new("2000-01-01".to_date, "2000-01-02".to_date))).to eq []
    expect(@date_range.intersecting_dates(Timely::DateRange.new("2000-01-01".to_date, "2000-01-03".to_date))).to eq ("2000-01-03".to_date.."2000-01-03".to_date)
    expect(@date_range.intersecting_dates(Timely::DateRange.new("2000-01-06".to_date, "2000-01-07".to_date))).to eq ("2000-01-06".to_date.."2000-01-06".to_date)
    expect(@date_range.intersecting_dates(Timely::DateRange.new("2000-01-06".to_date, "2000-01-07".to_date))).to eq ("2000-01-06".to_date.."2000-01-06".to_date)
    expect(@date_range.intersecting_dates(Timely::DateRange.new("2000-01-04".to_date, "2000-01-05".to_date))).to eq ("2000-01-04".to_date.."2000-01-05".to_date)
    expect(@date_range.intersecting_dates(Timely::DateRange.new("2000-01-05".to_date, "2000-01-05".to_date))).to eq ("2000-01-05".to_date.."2000-01-05".to_date)

    @date_range = Timely::DateRange.new("2000-01-03".to_date, "2000-01-03".to_date)
    expect(@date_range.intersecting_dates(Timely::DateRange.new("2000-01-04".to_date, "2000-01-07".to_date))).to eq []
    expect(@date_range.intersecting_dates(Timely::DateRange.new("2000-01-01".to_date, "2000-01-03".to_date))).to eq ("2000-01-03".to_date.."2000-01-03".to_date)
    expect(@date_range.intersecting_dates(Timely::DateRange.new("2000-01-03".to_date, "2000-01-05".to_date))).to eq ("2000-01-03".to_date.."2000-01-03".to_date)
    expect(@date_range.intersecting_dates(Timely::DateRange.new("2000-01-02".to_date, "2000-01-04".to_date))).to eq ("2000-01-03".to_date.."2000-01-03".to_date)
  end
  
end
