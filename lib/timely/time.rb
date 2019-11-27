# frozen_string_literal: true

module Timely
  module Time
    def on_date(year, month = nil, day = nil)
      if year.is_a?(Date)
        date = year
        year = date.year
        month = date.month
        day = date.day
      end

      raise ArgumentError, 'Year, month, and day needed' unless [year, month, day].all?

      ::Time.local(year, month, day, hour, min, sec)
    end

    alias on on_date
  end
end
