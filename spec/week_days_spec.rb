require 'spec_helper'

describe Timely::WeekDays do
  before do
    @weekdays = Timely::WeekDays.new(:tue => true, :thu => true)
  end

  it 'should create via hash, integer and array' do
    # 0   0   1   0   1   0   0
    # Sat Fri Thu Wed Tue Mon Sun
    expect(Timely::WeekDays.new(0b0010100).weekdays).to eq [:tue, :thu]
    expect(Timely::WeekDays.new(%w(0 0 1 0 1 0 0)).weekdays).to eq [:tue, :thu]
    expect(Timely::WeekDays.new(:tue => true, :thu => true).weekdays).to eq [:tue, :thu]
  end

  it 'should be able to set/unset days' do
    @weekdays[:mon] = true
    expect(@weekdays.weekdays).to eq [:mon, :tue, :thu]
    @weekdays[:tue] = false
    expect(@weekdays.weekdays).to eq [:mon, :thu]
  end

  it 'should output days nicely' do 
    expect(Timely::WeekDays.new(%w(1 0 0 0 0 0 0)).to_s).to eq "Sun"
    expect(Timely::WeekDays.new(%w(1 0 1 0 0 0 0)).to_s).to eq "Sun, and Tue"
    expect(Timely::WeekDays.new(%w(1 0 1 1 0 0 0)).to_s).to eq "Sun, Tue, and Wed"
    expect(Timely::WeekDays.new(%w(1 0 1 1 0 1 0)).to_s).to eq "Sun, Tue, Wed, and Fri"    
  end

  it 'should be able to determine if days of the week are selected' do
    # Test mon and tue in both symbol/integer forms
    expect(@weekdays.has_day?(1)).to be false
    expect(@weekdays.has_day?(:mon)).to be false
    expect(@weekdays.has_day?(2)).to be true
    expect(@weekdays.has_day?(:tue)).to be true
  end

  it 'should be able to determine if it would be applicable on a date' do
    expect(@weekdays.applies_for_date?(Date.new(2012, 04, 22))).to be false # Sunday
    expect(@weekdays.applies_for_date?(Date.new(2012, 04, 24))).to be true  # Tuesday
  end

  it 'should be able to convert to integer for use in databases, etc.' do
    expect(@weekdays.weekdays_int).to eq 4 + 16 # 4 = Tue, 16 = Thu
  end

  it 'should be able to determine if all days are selected' do
    expect(Timely::WeekDays.new(%w(1 1 1 1 1 1 1)).all_days?).to be true
    expect(Timely::WeekDays.new(%w(1 1 1 1 1 0 1)).all_days?).to be false
  end
end
