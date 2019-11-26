# frozen_string_literal: true

require 'spec_helper'

TestTime = Class.new(Time) do
  include ::Timely::Time
end

describe Time do
  it 'should be able to set date on a time' do
    xmas = Date.new(2012, 12, 25)
    lunch_time = TestTime.parse('12:00')
    xmas_lunch = lunch_time.on_date(xmas)
    expect(xmas_lunch.year).to eq 2012
    expect(xmas_lunch.month).to eq 12
    expect(xmas_lunch.day).to eq 25
    expect(xmas_lunch.hour).to eq 12
    expect(xmas_lunch.min).to eq 0
    expect(xmas_lunch.sec).to eq 0
  end

  it 'should allow setting the date part given a date' do
    time = TestTime.parse('2010-01-01 09:30:00')
    expect(time.on_date(Date.parse('2012-12-31'))).to eq Time.parse('2012-12-31 09:30:00')
  end
end

describe Time do
  before :each do
    @time = TestTime.now

    @year  = 2005
    @month = 3
    @day   = 15
  end

  it 'should give that time on a date' do
    expect(@time).to respond_to(:on_date)
  end

  describe 'giving that time on a date' do
    it 'should accept year, month and day' do
      expect { @time.on_date(@year, @month, @day) }.to_not raise_error
    end

    it 'should require year, month, and day' do
      expect { @time.on_date(@year, @month) }.to raise_error(ArgumentError)
    end

    it 'should return the same time on the specified year, month, and day' do
      expected = Time.local(@year, @month, @day, @time.hour, @time.min, @time.sec)
      expect(@time.on_date(@year, @month, @day)).to eq expected
    end

    it 'should accept a date' do
      expect { @time.on_date(Date.today) }.to_not raise_error
    end

    it 'should return the same time on the specified date' do
      @date = Date.today - 2345
      expected = Time.local(@date.year, @date.month, @date.day, @time.hour, @time.min, @time.sec)
      expect(@time.on_date(@date)).to eq expected
    end
  end

  it "should provide 'on' as an alias" do
    expected = Time.local(@year, @month, @day, @time.hour, @time.min, @time.sec)
    expect(@time.on(@year, @month, @day)).to eq expected
  end
end
