# frozen_string_literal: true

module RailsCoreExtensions
  module DateTime
    def advance_considering_calendar(units, num_units)
      case units
      when :seconds, :minutes, :hours, :days, :weeks, :months, :years
        advance(units => num_units)
      when :calendar_days
        advance(days: num_units - 1).end_of_day
      when :calendar_months
        advance(months: num_units - 1).end_of_month
      when :calendar_years
        advance(years: num_units - 1).end_of_year
      end
    end
  end
end

class DateTime
  include RailsCoreExtensions::DateTime
end
