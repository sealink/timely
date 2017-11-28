module Timely
  module Date
    def at_time(hour = nil, minute = nil, second = nil)
      if hour.is_a?(::Time)
        time = hour
        hour, minute, second = time.hour, time.min, time.sec
      end

      ::Time.local(year, month, day, hour, minute, second)
    end

    alias_method :at, :at_time

    # returns true if date between from and to
    # however if from and/or to are nil, it ignores that query
    # e.g. date.between?(from, nil) is "date > from",
    #      date.between?(from, nil) is "date < to"
    #      date.between?(nil, nil)  is true
    def between?(from, to)
      from = from.to_date if from && !from.is_a?(Date)
      to   = to.to_date if to && !to.is_a?(Date)

      if from && to
        self >= from && self <= to
      elsif from
        self >= from
      elsif to
        self <= to
      else
        true # i.e. no restrictive range return true
      end
    end
  end
end

class Date
  include Timely::Date
end
