module Timely
  module Range
    def to_date_range
      DateRange.new(self.first, self.last)
    end

    def days_from(date = Date.today)
      (date + self.first)..(date + self.last)
    end
  end
end

class Range
  include Timely::Range
end
