# frozen_string_literal: true

module Timely
  module TimeSince
    def seconds_since
      ::DateTime.now.to_i - to_i
    end

    def minutes_since
      seconds_since / 60
    end

    def hours_since
      minutes_since / 60
    end
  end
end

DateTime.send :include, Timely::TimeSince
