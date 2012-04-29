module Timely
  module Date
    def at_time(hour = nil, minute = nil, second = nil)
      if hour.is_a?(Time)
        time = hour
        hour, minute, second = time.hour, time.min, time.sec
      end

      ::Time.local(year, month, day, hour, minute, second)
    end

    alias_method :at, :at_time
  end
end

class Date
  include Timely::Date
end
