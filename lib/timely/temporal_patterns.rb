module Timely
  module TemporalPatterns
    class Frequency
      UNITS = [:second, :minute, :hour, :day, :week, :fortnight, :month, :year]

      attr_accessor :duration

      def initialize(duration)
        self.duration = duration
      end

      def duration=(duration)
        raise ArgumentError, "Frequency (#{duration}) must be a duration" unless duration.is_a?(ActiveSupport::Duration)
        raise ArgumentError, "Frequency (#{duration}) must be positive" unless duration > 0
        @duration = self.class.parse(duration)
      end

      def <=>(other)
        self.duration <=> other.duration
      end

      def to_s
        "every #{duration.inspect}"
      end

      def unit
        parts = self.class.decompose(duration)
        parts.size == 1 && parts.first.last == 1? parts.first.first : nil
      end

      def min_unit
        parts = self.class.decompose(duration)
        {parts.last.first => parts.last.last}
      end

      def max_unit
        parts = self.class.decompose(duration)
        {parts.first.first => parts.first.last}
      end

      def units
        self.class.decompose_to_hash(duration)
      end

      class << self
        def singular_units
          UNITS.dup
        end

        def plural_units
          UNITS.map { |unit| unit.to_s.pluralize.to_sym }
        end

        def unit_durations
          UNITS.map { |unit| 1.call(unit) }
        end

        def valid_units
          singular_units + plural_units
        end

        def valid_unit?(unit)
          valid_units.include?(unit.to_s.to_sym)
        end

        def parse(duration)
          parsed = 0.seconds
          decompose(duration).each do |part|
            parsed += part.last.send(part.first)
          end
          parsed
        end

        def decompose(duration)
          whole = duration
          parts = []
          plural_units.reverse_each do |unit|
            if whole >= (one_unit = 1.send(unit))
              current_unit_value = ((whole / one_unit).floor)
              if current_unit_value > 0
                parts << [unit, current_unit_value]
                whole -= current_unit_value.send(unit)
              end
            end
          end
          parts
        end

        def decompose_to_hash(duration)
          decompose(duration).inject({}) do |hash, unit|
            hash[unit.first] = unit.last
            hash
          end
        end
      end

      private

      def method_missing(method, *args, &block) #:nodoc:
        duration.send(method, *args, &block)
      end
    end

    class Interval
      attr_accessor :first_datetime, :last_datetime

      def initialize(first_datetime, last_datetime = nil)
        self.first_datetime = first_datetime
        self.last_datetime = last_datetime || first_datetime
      end

      def first_datetime=(first_datetime)
        @first_datetime = first_datetime.to_datetime
      end

      def last_datetime=(last_datetime)
        @last_datetime = last_datetime.to_datetime
      end

      def range
        (first_datetime..last_datetime)
      end

      def datetimes
        range.to_a
      end

      def ==(other)
        self.range == other.range
      end

      def to_s
        if first_datetime == last_datetime
          "on #{first_datetime}#{first_datetime == first_datetime.beginning_of_day ? "" : " at #{first_datetime.strftime("%I:%M %p")}"}"
        elsif first_datetime == first_datetime.beginning_of_month && last_datetime == last_datetime.end_of_month
          if first_datetime.month == last_datetime.month
            "during #{first_datetime.strftime('%b %Y')}"
          else
            "from #{first_datetime.strftime('%b %Y')} to #{last_datetime.strftime('%b %Y')}"
          end
        else
          "from #{first_datetime}#{first_datetime == first_datetime.beginning_of_day ? "" : " at #{first_datetime.strftime("%I:%M %p")}"} "+
          "to #{last_datetime}#{last_datetime == last_datetime.beginning_of_day ? "" : " at #{last_datetime.strftime("%I:%M %p")}"}"
        end
      end

      def date_time_to_s(datetime)
        datetime.strftime("%I:%M %p")
      end

      private

      def method_missing(method, *args, &block) #:nodoc:
        range.send(method, *args, &block)
      end
    end

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

    class Finder
      class << self
        def patterns(datetimes, options = nil)
          return [] if datetimes.blank?
          options ||= {}

          datetimes = Array.wrap(datetimes).uniq.map(&:to_datetime).sort

          if options[:split].is_a?(ActiveSupport::Duration)
            find_patterns_split_by_duration(datetimes, options)
          elsif options[:split].is_a?(Numeric)
            find_patterns_split_by_size(datetimes, options)
          else
            find_patterns(datetimes, options)
          end
        end

        private

        def find_patterns(datetimes, options = {})
          frequency_patterns = []

          return [] if datetimes.blank?

          if frequencies = options[:frequency] || options[:frequencies]
            Array.wrap(frequencies).each do |frequency|
              unmatched_datetimes = nil
              if pattern = frequency_pattern(datetimes, frequency)
                frequency_patterns << pattern
                unmatched_datetimes = datetimes - pattern[:intervals].flatten
              end
              break if unmatched_datetimes && unmatched_datetimes.empty?
            end
          end

          if options[:all] || !frequencies
            frequency_patterns.concat(frequency_patterns(datetimes))
          end

          if best_fit = best_pattern(frequency_patterns)
            ranges = best_fit[:ranges].map { |r| (r[0]..r[1]) }
            frequency = best_fit[:frequency]
            unmatched_datetimes = datetimes - best_fit[:intervals].flatten
            pattern = Pattern.new(ranges, frequency)
            ([pattern] + find_patterns(unmatched_datetimes, options)).sort_by(&:first_datetime)
          else
            datetimes.map { |d| Pattern.new((d..d), 1.day) }.sort_by(&:first_datetime)
          end
        end

        def find_patterns_split_by_duration(datetimes, options = {})
          slice_size = options[:split]
          slices = []
          slice_start = 0
          while slice_start < datetimes.size
            slice_end = datetimes.index(datetimes[slice_start] + slice_size) || (datetimes.size - 1)
            slices << datetimes[slice_start..slice_end]
            slice_start = slice_end + 1
          end
          split_patterns = []
          slices.each do |slice|
            split_patterns.concat(find_patterns(slice, options))
          end
          join_patterns(split_patterns)
        end

        def find_patterns_split_by_size(datetimes, options = {})
          slice_size = options[:split]
          split_patterns = []
          datetimes.each_slice(slice_size) do |slice|
            split_patterns.concat(find_patterns(slice, options))
          end
          join_patterns(split_patterns)
        end

        def join_patterns(patterns)
          split_patterns = patterns.sort_by(&:first_datetime)
          joint_patterns = []
          while pattern = split_patterns.pop
            joint_pattern = pattern
            while (next_pattern = split_patterns.pop) && (pattern = joint_pattern.join(next_pattern))
              joint_pattern = pattern
            end
            joint_patterns << joint_pattern
          end
          joint_patterns.sort_by(&:first_datetime)
        end

        def frequency_pattern(datetimes, frequency)
          return nil if datetimes.blank? || frequency.to_f < 1 || ((datetimes.first + frequency) > datetimes.last)
          pattern_intervals = []
          pattern_ranges = []
          intervals = condition_intervals(datetimes) do |current_date, next_date|
            if (current_date + frequency) == next_date
              pattern_intervals << [current_date, next_date]
              true
            else
              false
            end
          end
          pattern_ranges = intervals.map { |r| [r.first,r.last] }
          {:frequency => frequency, :ranges => pattern_ranges, :intervals => pattern_intervals} unless intervals.blank?
        end

        def condition_intervals(datetimes, &block)
          return [] if datetimes.blank? || !block_given?
          datetimes = datetimes.clone
          current_datetime = first_datetime = datetimes.shift
          last_datetime = nil
          while next_datetime = datetimes.delete(datetimes.find { |datetime| block.call(current_datetime, datetime) })
            current_datetime = last_datetime = next_datetime
          end
          (last_datetime ? [(first_datetime..current_datetime)] : []) + condition_intervals(datetimes, &block)
        end

        def frequency_patterns(datetimes)
          return [] if datetimes.blank?
          datetimes = datetimes.clone
          patterns = {}
          while (current_datetime = datetimes.pop)
            datetimes.reverse_each do |compared_datetime|
              frequency = current_datetime - compared_datetime
              patterns[frequency] ||= {:frequency => frequency.days, :ranges => [], :intervals => []}
              patterns[frequency][:intervals] << [compared_datetime, current_datetime]
              if interval = patterns[frequency][:ranges].find { |i| i[0] == current_datetime }
                interval[0] = compared_datetime
              else
                patterns[frequency][:ranges] << [compared_datetime, current_datetime]
              end
            end
          end
          patterns.values
        end

        def best_pattern(frequency_patterns)
          best_fit = nil
          frequency_patterns.each do |pattern_hash|
            if best_fit.nil? ||
                (best_fit[:intervals].count < pattern_hash[:intervals].count) ||
                (best_fit[:intervals].count == pattern_hash[:intervals].count && (best_fit[:ranges].count > pattern_hash[:ranges].count ||
                (best_fit[:ranges].count == pattern_hash[:ranges].count && best_fit[:frequency] < pattern_hash[:frequency])))
              best_fit = pattern_hash
            end
          end
          best_fit
        end
      end
    end
  end
end
