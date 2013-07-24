require 'active_support/core_ext/integer/inflections' # ordinalize

module Timely
  module TemporalPatterns
    class Pattern
      attr_reader :intervals, :frequency

      def initialize(ranges, frequency)
        @intervals = Array.wrap(ranges).map { |r| Interval.new(r.first, r.last) }.sort_by(&:first_datetime)
        @frequency = Frequency.new(frequency)
        fix_frequency
      end

      def datetimes
        intervals.map do |interval|
          datetimes = []
          datetime = interval.first_datetime
          while datetime <= interval.last_datetime
            datetimes << datetime
            datetime = datetime + frequency.duration
          end
          datetimes
        end
      end

      def ranges
        intervals.map { |i| (i.first_datetime..i.last_datetime) }
      end

      def first_datetime
        interval.first_datetime
      end

      def last_datetime
        interval.last_datetime
      end

      def interval
        first_datetime = nil
        last_datetime = nil
        intervals.each do |i|
          first_datetime = i.first_datetime if first_datetime.nil? || i.first_datetime < first_datetime
          last_datetime = i.last_datetime if last_datetime.nil? || i.last_datetime > last_datetime
        end
        Interval.new(first_datetime, last_datetime)
      end

      def match?(datetimes)
        datetimes = Array.wrap(datetimes).map(&:to_datetime)
        intervals.each do |interval|
          current_datetime = interval.first_datetime
          while current_datetime <= interval.last_datetime
            datetimes.delete_if { |datetime| datetime == current_datetime }
            return true if datetimes.empty?
            current_datetime = current_datetime + frequency.duration
          end
        end
        false
      end

      def <=>(other)
        self.intervals.count <=> other.intervals.count
      end

      def join(other)
        if self.frequency == other.frequency
          expanded_datetimes = self.datetimes.map do |datetimes|
            datetimes.unshift(datetimes.first - frequency.duration)
            datetimes << (datetimes.last + frequency.duration)
          end
          joint_ranges = []
          other.datetimes.each do |datetimes|
            if joinable_datetimes = expanded_datetimes.find { |ed| datetimes.any? { |d| ed.include?(d) } }
              joint_datetimes = (datetimes + joinable_datetimes[1...-1]).sort
              joint_ranges << (joint_datetimes.first..joint_datetimes.last)
            else
              break
            end
          end
          unless joint_ranges.size != self.intervals.size
            Pattern.new(joint_ranges, frequency.duration)
          end
        end
      end

      def to_s
        single_date_intervals, multiple_dates_intervals = intervals.partition { |i| i.first_datetime == i.last_datetime}
        patterns_strings = if multiple_dates_intervals.empty?
          single_date_intervals.map(&:to_s)
        else
          multiple_dates_intervals_first_datetime = nil
          multiple_dates_intervals_last_datetime = nil
          multiple_dates_intervals.each do |i|
            multiple_dates_intervals_first_datetime = i.first_datetime if multiple_dates_intervals_first_datetime.nil? || i.first_datetime < multiple_dates_intervals_first_datetime
            multiple_dates_intervals_last_datetime = i.last_datetime if multiple_dates_intervals_last_datetime.nil? || i.last_datetime > multiple_dates_intervals_last_datetime
          end
          multiple_dates_interval = Interval.new(multiple_dates_intervals_first_datetime, multiple_dates_intervals_last_datetime)
          multiple_dates_intervals_string = case frequency.unit
          when :years
            "every #{multiple_dates_intervals.map { |i| "#{i.first_datetime.day.ordinalize} of #{i.first_datetime.strftime('%B')}" }.uniq.to_sentence} #{multiple_dates_interval}"
          when :months
            "every #{multiple_dates_intervals.map { |i| i.first_datetime.day.ordinalize }.uniq.to_sentence} of the month #{multiple_dates_interval}"
          when :weeks
            weekdays = multiple_dates_intervals.map { |i| i.first_datetime.strftime('%A') }.uniq
            if weekdays.count == 7
              "every day #{multiple_dates_interval}"
            else
              "every #{weekdays.to_sentence} #{multiple_dates_interval}"
            end
          when :days
            if multiple_dates_intervals.any? { |i| i.first_datetime != i.first_datetime.beginning_of_day }
              "every day at #{multiple_dates_intervals.map { |i| i.first_datetime.strftime("%I:%M %p") }.to_sentence} #{multiple_dates_interval}"
            else
              "every day #{multiple_dates_interval}"
            end
          else
            "#{frequency} #{multiple_dates_intervals.map(&:to_s).to_sentence}"
          end
          [multiple_dates_intervals_string] + single_date_intervals.map(&:to_s)
        end
        patterns_strings.to_sentence
      end

      private

      # Fix the time units inconsistency problem
      # e.g.: a year isn't exactly 12 months, it's a little bit more, but it is commonly considered to be equal to 12 months
      def fix_frequency
        if frequency.duration > 12.months
          if intervals.all? { |i| i.first_datetime.month == i.last_datetime.month && i.first_datetime.day == i.last_datetime.day }
            frequency.duration = (frequency.duration / 12.months).floor.years
          end
        elsif frequency.duration > 1.month && frequency.duration < 12.months
          if intervals.all? { |i| i.first_datetime.day == i.last_datetime.day }
            frequency.duration = frequency.units[:months].months
          end
        end
      end
    end
  end
end
