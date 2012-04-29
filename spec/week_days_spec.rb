require 'spec_helper'

describe Timely::WeekDays do
  before do
    @weekdays = Timely::WeekDays.new(:tue => true, :thu => true)
  end

  it 'should create via hash, integer and array' do
    # 0   0   1   0   1   0   0
    # Sat Fri Thu Wed Tue Mon Sun
    Timely::WeekDays.new(0b0010100).weekdays.should == [:tue, :thu]
    Timely::WeekDays.new(%w(0 0 1 0 1 0 0)).weekdays.should == [:tue, :thu]
    Timely::WeekDays.new(:tue => true, :thu => true).weekdays.should == [:tue, :thu]
  end

  it 'should be able to set/unset days' do
    @weekdays[:mon] = true
    @weekdays.weekdays.should == [:mon, :tue, :thu]
    @weekdays[:tue] = false
    @weekdays.weekdays.should == [:mon, :thu]
  end

  it 'should output days nicely' do
    @weekdays.to_s.should == 'Tue, Thu'
  end

  it 'should be able to determine if days of the week are selected' do
    # Test mon and tue in both symbol/integer forms
    @weekdays.has_day?(1).should be_false
    @weekdays.has_day?(:mon).should be_false
    @weekdays.has_day?(2).should be_true
    @weekdays.has_day?(:tue).should be_true
  end

  it 'should be able to determine if it would be applicable on a date' do
    @weekdays.applies_for_date?(Date.new(2012, 04, 22)).should be_false # Sunday
    @weekdays.applies_for_date?(Date.new(2012, 04, 24)).should be_true  # Tuesday
  end

  it 'should be able to convert to integer for use in databases, etc.' do
    @weekdays.weekdays_int.should == 4 + 16 # 4 = Tue, 16 = Thu
  end

  it 'should be able to determine if all days are selected' do
    Timely::WeekDays.new(%w(1 1 1 1 1 1 1)).all_days?.should be_true
    Timely::WeekDays.new(%w(1 1 1 1 1 0 1)).all_days?.should be_false
  end
end
