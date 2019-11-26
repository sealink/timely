# frozen_string_literal: true

module Timely
  class DateChooser
    # Where is this used... so far only in one place, _date_range.html.haml
    # May be good to refactor this as well, after the class behaviour is refactored.
    INTERVALS = [
      { code: 'week', name: 'week(s)', description: 'Weekdays selected will be chosen every {{n}} weeks for the date range' },
      { code: 'week_of_month', name: 'week of month', description:           'Weekdays selected will be chosen in their {{ord}} occurance every month,
          e.g. if wednesday and thursday are selected, the first wednesday and
          first thursday are selected. Note: this may mean the booking is copied
          to Thursday 1st and Wednesday 7th' }
    ].freeze

    attr_accessor :multiple_dates, :from, :to, :select, :dates, :interval, :weekdays

    def initialize(options)
      @multiple_dates = options[:multiple_dates] || false
      @from     = process_date(options[:from])
      @to       = process_date(options[:to])
      @select   = options[:select]
      @dates    = options[:dates]
      @specific_dates = options[:specific_dates]
      @interval = options[:interval]
      @weekdays = WeekDays.new(options[:weekdays]) if @select == 'weekdays'
      validate
    end

    def process_date(date)
      case date
      when Date then date
      when NilClass then nil
      when String
        date !~ /[^[:space:]]/ ? nil : date.to_date
      end
    end

    # Chooses a set of dates from a date range, based on conditions.
    # date_info   - A hash with conditions and date information
    #   :from     - The start of the date range
    #   :to       - The end of the date range
    #
    # You can either specify specific dates to be chosen each month:
    #   :dates          - A comma separated string of days of the month, e.g. 1,16
    #   :specific_dates - A comma separated string of dates, e.g. 26-10-2012, 03-11-2012, 01-01-2013
    #
    # or you can specify how to select the dates
    #   :day      - A hash of days, the index being the wday, e.g. 0 = sunday, and the value being 1 if chosen
    #   :interval - A hash of information about the interval
    #     :level  - The level/multiplier of the interval unit
    #     :unit   - The unit of the interval, e.g. w for week, mow for month of week
    #     e.g. :level => 2, :unit => w would try to select the days of the week every fortnight,
    #          so every friday and saturday each fornight
    def choose_dates
      # Not multiple dates - just return the From date.
      return [@from] unless @multiple_dates

      # Multiple dates - return the array, adjusted as per input
      all_days = (@from..@to).to_a

      case @select
      when 'days'
        days = @dates.gsub(/\s/, '').split(',')
        all_days.select { |date| days.include?(date.mday.to_s) }
      when 'specific_days'
        days = @specific_dates.gsub(/\s/, '').split(',')
        days.map(&:to_date)
      when 'weekdays'
        raise DateChooserException, 'No days of the week selected' if @weekdays.weekdays.empty?
        raise DateChooserException, 'No weekly interval selected' if @interval&.empty?

        all_days.select do |date|
          next unless @weekdays.has_day?(date.wday)

          case @interval[:unit]
          when 'week'
            # 0 = first week, 1 = second week, 2 = third week, etc.
            nth_week = (date - @from).to_i / 7
            # true every 2nd week (0, 2, 4, 6, etc.)
            (nth_week % @interval[:level].to_i).zero?
          when 'week_of_month'
            week = @interval[:level].to_i
            (date.mday > (week - 1) * 7 && date.mday <= week * 7)
          end
        end
      else
        all_days
      end
    end

    private

    def validate
      raise DateChooserException, 'A Start Date is required' unless @from
      raise DateChooserException, 'Start Date is after End Date' if @multiple_dates && @to && @from > @to

      @to ||= @from if @multiple_dates
    end
  end

  class DateChooserException < RuntimeError; end
end
