module Timely
  class DateRange < ::Range
    def initialize(*args)
      if args.first.is_a?(Range)
        date_range = args.first
        DateRange.validate_range(date_range.first, date_range.last)
        super(date_range.first.to_date, date_range.last.to_date)
      elsif args.size == 1 && args.first.is_a?(Date)
        DateRange.validate_range(args.first, args.last)
        super(args.first.to_date, args.first.to_date)
      else
        DateRange.validate_range(args.first, args.last)
        super(args.first.to_date, args.last.to_date)
      end
    end
    alias_method :start_date, :first
    alias_method :end_date, :last

    def self.validate_range(first, last)
      raise ArgumentError, "Date range missing start date" if first.nil?
      raise ArgumentError, "Date range missing end date" if last.nil?
      raise ArgumentError, "Start date is not a date" unless first.is_a? Date
      raise ArgumentError, "End date is not a date" unless last.is_a? Date
    end

    def self.from_params(start_date, duration = nil)
      start_date = start_date.to_date
      duration   = [1, duration.to_i].max

      new(start_date..(start_date + duration - 1))
    end

    def intersecting_dates(date_range)
      start_of_intersection = [self.start_date, date_range.first].max
      end_of_intersection = [self.end_date, date_range.last].min
      intersection = if end_of_intersection >= start_of_intersection
        (start_of_intersection..end_of_intersection)
      else
        []
      end
    end

    def number_of_nights
      ((last - first) + 1).to_i
    end
    alias_method :duration, :number_of_nights

    def to_s(fmt = '%b %Y', date_fmt = '%Y-%m-%d')
      Timely::DateRange.to_s(first, last, fmt, date_fmt)
    end

    def self.to_s(first = nil, last = nil, month_fmt = '%b %Y', date_fmt = default_date_format, time_fmt = nil)
      time_fmt ||= date_fmt + ' %H:%M'
      is_date = first.is_a?(Date) || last.is_a?(Date)
      fmt = is_date ? date_fmt : time_fmt
      if first && last
        if first == last
          first.strftime(fmt)
        elsif first == first.at_beginning_of_month && last == last.at_end_of_month
          if first.year == last.year && first.month == last.month
            first.strftime(month_fmt)
          else
            "#{first.strftime(month_fmt)} to #{last.strftime(month_fmt)}"
          end
        else
          "#{first.strftime(fmt)} to #{last.strftime(fmt)}#{" (inclusive)" if is_date}"
        end
      elsif first
        "on or after #{first.strftime(fmt)}"
      elsif last
        "on or before #{last.strftime(fmt)}"
      else
        "no date range"
      end
    end


    private

    def self.default_date_format
      # ::Date as we want Ruby's Date not Timely::Date
      date_format = ::Date::DATE_FORMATS[:short] if ::Date.const_defined?('DATE_FORMATS')
      date_format || '%Y-%m-%d'
    end
  end
end
