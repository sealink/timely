module Timely
  class DateGroup < ActiveRecord::Base
    belongs_to :season, :class_name => 'Timely::Season'

    weekdays_field :weekdays

    validates_presence_of :start_date, :end_date
    validate :validate_date_range!

    def includes_date?(date)
      date >= start_date && date <= end_date && weekdays.applies_for_date?(date)
    end

    def applicable_for_duration?(date_range)
      if date_range.first > end_date || date_range.last < start_date
        false
      elsif weekdays.all_days?
        true
      else
        date_range.intersecting_dates(start_date..end_date).any?{|d| weekdays.applies_for_date?(d)}
      end
    end

    def dates
      start_date.upto(end_date).select { |d| weekdays.applies_for_date?(d) }
    end

    def to_s
      str = start_date && end_date ? (start_date..end_date).to_date_range.to_s : (start_date || end_date).to_s
      str += " on #{weekdays}" unless weekdays.all_days?
      str
    end

    ################################################################
    #---------------- Date intervals and patterns -----------------#
    ################################################################

    def pattern
      ranges = dates.group_by(&:wday).values.map { |weekdates| (weekdates.min..weekdates.max) }
      TemporalPatterns::Pattern.new(ranges, 1.week)
    end

    def self.from_patterns(patterns)
      date_groups = []
      Array.wrap(patterns).each do |pattern|
        if pattern.frequency.unit == :weeks
          weekdays = pattern.intervals.map { |i| i.first_datetime.wday }.inject({}) do |hash, wday|
            hash[wday] = 1
            hash
          end
          date_groups << DateGroup.new(
            :start_date => pattern.first_datetime.to_date,
            :end_date => pattern.last_datetime.to_date,
            :weekdays => weekdays)
        elsif pattern.frequency.unit == :days && pattern.frequency.duration == 1.day
          date_groups << DateGroup.new(
            :start_date => pattern.first_datetime.to_date,
            :end_date => pattern.last_datetime.to_date,
            :weekdays => 127)
        else
          pattern.datetimes.each do |datetimes|
            datetimes.group_by(&:week).values.each do |dates|
              weekdays = dates.map(&:wday).inject({}) do |hash, wday|
                hash[wday] = 1
                hash
              end
              date_groups << DateGroup.new(
                :start_date => dates.min.to_date.beginning_of_week,
                :end_date => dates.max.to_date.end_of_week,
                :weekdays => weekdays)
            end
          end
        end
      end
      date_groups
    end

    private

    def validate_date_range!
      if start_date && end_date && (start_date > end_date)
        raise ArgumentError, "Incorrect date range #{start_date} is before #{end_date}"
      end
    end
  end
end
