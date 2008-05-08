module Timely
  module Date
    def at_time(hour = nil, minute = nil, second = nil)
      ::Time.local(year, month, day, hour, minute, second)
    end
    
    alias_method :at, :at_time
  end
end

class Date
  include Timely::Date
end