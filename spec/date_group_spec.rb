require "spec_helper"
describe Timely::DateGroup do
  before do
    @date_group = Timely::DateGroup.create!(
      :start_date => '2000-01-01', :end_date => '2000-01-03', :weekdays => %w(1 1 1 1 1 1 1)
    )
  end

  it 'should detect overlaps' do
    @date_group.applicable_for_duration?(Timely::DateRange.new('2000-01-01'.to_date, '2000-01-01'.to_date)).should be_true
    @date_group.applicable_for_duration?(Timely::DateRange.new('2000-01-01'.to_date, '2000-01-06'.to_date)).should be_true
    @date_group.applicable_for_duration?(Timely::DateRange.new('2001-01-01'.to_date, '2001-01-01'.to_date)).should be_false
    @date_group.applicable_for_duration?(Timely::DateRange.new('1999-12-29'.to_date, '2000-01-05'.to_date)).should be_true 
  end

  it "should detect overlaps when certain weekdays aren't selected" do
    @date_group = Timely::DateGroup.create!(
      :start_date => '2012-01-01', :end_date => '2012-01-07', :weekdays => %w(1 0 1 0 1 0 1)
    )
    # Note: 2012-01-1 is a Sunday
    @date_group.applicable_for_duration?(Timely::DateRange.new('2012-01-01'.to_date, '2012-01-01'.to_date)).should be_true
    @date_group.applicable_for_duration?(Timely::DateRange.new('2012-01-02'.to_date, '2012-01-02'.to_date)).should be_false
    @date_group.applicable_for_duration?(Timely::DateRange.new('2012-01-03'.to_date, '2012-01-03'.to_date)).should be_true
    @date_group.applicable_for_duration?(Timely::DateRange.new('2012-01-01'.to_date, '2012-01-03'.to_date)).should be_true
  end
end
