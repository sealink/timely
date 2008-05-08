module Timely
  module Time
    def on_date(year, month, day)
      ::Time.local(year, month, day, hour, min, sec)
    end
    
    alias_method :on, :on_date
  end
end

class Time
  include Timely::Time
end