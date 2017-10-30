class Date
  def at_time(hour = nil, minute = nil, second = nil)
    if hour.is_a?(Time)
      time = hour
      hour, minute, second = time.hour, time.min, time.sec
    end

    ::Time.zone.local(year, month, day, hour, minute, second)
  end

  def to_time_in_time_zone
    (Time.zone || ActiveSupport::TimeZone["UTC"]).local(self.year, self.month, self.day)
  end
end
