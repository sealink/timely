module Timely
  class TimeOfDay
    VALID_FORMATS = [:time12, :time24]

    attr_reader :hour
    attr_reader :minute

    def self.from_time(datetime)
      new(datetime.hour, datetime.min)
    end

    def initialize(hour, minute)
      @hour = hour
      @minute = minute
    end

    def on_date(date)
      sec = 0
      ::Time.zone.local(date.year, date.month, date.day, hour, minute, sec)
    end

    def to_s(format = :time12)
      on_date(Date.current).to_s(format)
    end

    def ==(other)
      other.hour == hour && other.minute == minute
    end
  end
end
