# frozen_string_literal: true

class Date
  def to_time_in_time_zone
    (Time.zone || ActiveSupport::TimeZone['UTC']).local(year, month, day)
  end
end
