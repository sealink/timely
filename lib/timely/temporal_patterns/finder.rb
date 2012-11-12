module Timely
  module TemporalPatterns
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
