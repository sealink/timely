# frozen_string_literal: true

module Timely
  class Period
    attr_reader :number, :units

    UNITS = %i[
      seconds
      minutes
      hours
      days
      weeks
      months
      years
      calendar_days
      calendar_months
      calendar_years
    ].freeze

    def initialize(number, units)
      @number = number
      @units  = units.to_sym
    end

    def after(time)
      time.advance_considering_calendar(units, number)
    end

    def to_s
      "#{number} #{units.to_s.gsub('_', '')}"
    end

    def to_seconds
      case units
      when :seconds
        number
      when :minutes
        number.minute.in_seconds
      when :hours
        number.hour.in_seconds
      when :days
        number.day.in_seconds
      when :weeks
        number.week.in_seconds
      when :months
        number.month.in_seconds
      when :years
        number.year.in_seconds
      when :calendar_days
        ::Time.now.advance(days: number - 1).end_of_day - ::Time.now
      when :calendar_months
        ::Time.now.advance(months: number - 1).end_of_month - ::Time.now
      when :calendar_years
        ::Time.now.advance(years: number - 1).end_of_year - ::Time.now
      end
    end
  end
end
