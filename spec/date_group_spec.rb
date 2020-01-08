# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Timely::DateGroup do
  before do
    @date_group = Timely::DateGroup.new(
      start_date: '2000-01-01', end_date: '2000-01-03', weekdays: %w[1 1 1 1 1 1 1]
    )
  end

  it 'is not valid to set nil weekdays' do
    @date_group.weekdays_bit_array = nil
    expect(@date_group).not_to be_valid
  end

  it 'should detect overlaps' do
    expect(@date_group.applicable_for_duration?(Timely::DateRange.new('2000-01-01'.to_date, '2000-01-01'.to_date))).to be true
    expect(@date_group.applicable_for_duration?(Timely::DateRange.new('2000-01-01'.to_date, '2000-01-06'.to_date))).to be true
    expect(@date_group.applicable_for_duration?(Timely::DateRange.new('2001-01-01'.to_date, '2001-01-01'.to_date))).to be false
    expect(@date_group.applicable_for_duration?(Timely::DateRange.new('1999-12-29'.to_date, '2000-01-05'.to_date))).to be true
  end

  it "should detect overlaps when certain weekdays aren't selected" do
    @date_group = Timely::DateGroup.create!(
      start_date: '2012-01-01', end_date: '2012-01-07', weekdays: %w[1 0 1 0 1 0 1]
    )
    # Note: 2012-01-1 is a Sunday
    expect(@date_group.applicable_for_duration?(Timely::DateRange.new('2012-01-01'.to_date, '2012-01-01'.to_date))).to be true
    expect(@date_group.applicable_for_duration?(Timely::DateRange.new('2012-01-02'.to_date, '2012-01-02'.to_date))).to be false
    expect(@date_group.applicable_for_duration?(Timely::DateRange.new('2012-01-03'.to_date, '2012-01-03'.to_date))).to be true
    expect(@date_group.applicable_for_duration?(Timely::DateRange.new('2012-01-01'.to_date, '2012-01-03'.to_date))).to be true
  end
end

RSpec.describe Timely::DateGroup, 'Timely::DateGroup.applying_for_duration' do
  let!(:date_group_a) { Timely::DateGroup.create!(
    start_date: '2020-01-01', end_date: '2020-04-04', weekdays: %w[1 1 1 1 1 1 1]
  ) }

  let!(:date_group_b) { Timely::DateGroup.create!(
    start_date: '2020-04-02', end_date: '2020-04-09', weekdays: %w[1 1 1 1 1 1 1]
  ) }

  subject {
    Timely::DateGroup.applying_for_duration(Timely::DateRange.new(start_date, end_date)).to_a
  }

  context 'intersecting dates (inside first)' do
    let(:start_date) { '2020-03-29'.to_date }
    let(:end_date) { '2020-04-13'.to_date }
    it { is_expected.to eq([date_group_a, date_group_b]) }
  end

  context 'intersecting dates full range' do
    let(:start_date) { '2020-01-01'.to_date }
    let(:end_date) { '2020-04-09'.to_date }
    it { is_expected.to eq([date_group_a, date_group_b]) }
  end

  context 'touching end of range' do
    let(:start_date) { '2020-04-09'.to_date }
    let(:end_date) { '2020-04-09'.to_date }
    it { is_expected.to eq([date_group_b]) }
  end

  context 'touching start of range' do
    let(:start_date) { '2020-04-01'.to_date }
    let(:end_date) { '2020-04-01'.to_date }
    it { is_expected.to eq([date_group_a]) }
  end
end

RSpec.describe Timely::DateGroup, 'without weekdays' do
  subject { Timely::DateGroup.new(start_date: Date.current, end_date: Date.current) }
  it { is_expected.to be_valid }
end

RSpec.describe 'Timely::DateGroup.for_any_weekdays' do
  let(:date_range) { ('2019-10-17'.to_date)..('2019-10-18'.to_date) }
  let(:weekdays_int) { Timely::WeekDays.from_range(date_range).weekdays_int }

  let!(:date_groups) { [
    Timely::DateGroup.create(start_date: date_range.first, end_date: date_range.last, weekdays: { thu: true }),
    Timely::DateGroup.create(start_date: date_range.first, end_date: date_range.last, weekdays: { mon: true }),
  ] }

  RSpec.shared_examples 'finds expected date groups' do
    it 'finds expected date groups' do
      includes_date_groups.each do |date_group|
        expect(date_group.includes_date?(date_range.first)).to eq(true)
      end
      expected_groups.each do |date_group|
        expect(scoped_result).to include(date_group)
      end
      absent_groups.each do |date_group|
        expect(date_group.includes_date?(date_range.first)).to eq(false)
        expect(scoped_result).not_to include(date_group)
      end
    end
  end

  context '#within_range' do
    let(:scoped_result) { Timely::DateGroup.within_range(date_range).to_a }
    let(:expected_groups) { [date_groups[0], date_groups[1]] }
    let(:absent_groups) { [] }
    let(:includes_date_groups) { [] }
    it_behaves_like 'finds expected date groups'
  end

  let(:includes_date_groups) { expected_groups }
  let(:expected_groups) { [date_groups[0]] }
  let(:absent_groups) { [date_groups[1]] }

  context '#for_any_weekdays' do
    let(:scoped_result) { Timely::DateGroup.for_any_weekdays(weekdays_int).to_a }
    it_behaves_like 'finds expected date groups'
  end

  context '#applying_for_duration' do
    let(:scoped_result) { Timely::DateGroup.applying_for_duration(date_range).to_a }
    it_behaves_like 'finds expected date groups'
  end
end
