# frozen_string_literal: true

module Timely
  module Range
    def to_date_range
      DateRange.new(first, last)
    end

    def days_from(date = Date.today)
      (date + first)..(date + last)
    end
  end
end

class Range
  include Timely::Range
end
