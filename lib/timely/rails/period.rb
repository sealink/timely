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
  end
end
