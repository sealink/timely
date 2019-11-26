# frozen_string_literal: true

module Timely
  module String
    # fmt e.g. '%d/%m/%Y'
    # By default it will try to guess the format
    # If using ActiveSupport you can pass in a symbol for the DATE_FORMATS
    def to_date(fmt = nil)
      if fmt
        fmt = Date::DATE_FORMATS[fmt] if fmt.is_a?(Symbol) && defined?(Date::DATE_FORMATS)
        parsed = ::Date._strptime(self, fmt)
        parsed[:year] = parsed[:year] + 2000 if parsed[:year] < 1000
        ::Date.new(*parsed.values_at(:year, :mon, :mday))
      else
        ::Date.new(*::Date._parse(self, false).values_at(:year, :mon, :mday))
      end
    rescue NoMethodError, ArgumentError
      raise DateFormatException, "Date #{self} is invalid or not formatted correctly."
    end
  end

  class DateFormatException < RuntimeError; end
end

class String
  include Timely::String
end
