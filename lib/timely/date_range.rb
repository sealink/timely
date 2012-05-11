module Timely
  class DateRange < ::Range
    def initialize(*args)
      if args.first.is_a?(Range)
        super(args.first.first, args.first.last)
      elsif args.size == 1 && args.first.is_a?(Date)
        super(args.first, args.first)
      else
        super(*args)
      end
    end
    alias_method :start_date, :first
    alias_method :end_date, :last

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

    def to_s(fmt = '%b %Y')
      if first == last
        first.to_s(:short)
      elsif first == first.at_beginning_of_month && last == last.at_end_of_month
        if first.month == last.month
          first.strftime(fmt)
        else
          "#{first.strftime(fmt)} to #{last.strftime(fmt)}"
        end
      else
        "#{first.to_s(:short)} to #{last.to_s(:short)}"
      end
    end
  end
end
