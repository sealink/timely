module Timely
  module TemporalPatterns
    class Interval
      attr_accessor :first_datetime, :last_datetime

      def initialize(first_datetime, last_datetime = nil)
        self.first_datetime = first_datetime
        self.last_datetime = last_datetime || first_datetime
      end

      def first_datetime=(first_datetime)
        @first_datetime = first_datetime.to_datetime
      end

      def last_datetime=(last_datetime)
        @last_datetime = last_datetime.to_datetime
      end

      def range
        (first_datetime..last_datetime)
      end

      def datetimes
        range.to_a
      end

      def ==(other)
        self.range == other.range
      end

      def to_s
        if first_datetime == last_datetime
          "on #{first_datetime}#{first_datetime == first_datetime.beginning_of_day ? "" : " at #{first_datetime.strftime("%I:%M %p")}"}"
        elsif first_datetime == first_datetime.beginning_of_month && last_datetime == last_datetime.end_of_month
          if first_datetime.month == last_datetime.month
            "during #{first_datetime.strftime('%b %Y')}"
          else
            "from #{first_datetime.strftime('%b %Y')} to #{last_datetime.strftime('%b %Y')}"
          end
        else
          "from #{first_datetime}#{first_datetime == first_datetime.beginning_of_day ? "" : " at #{first_datetime.strftime("%I:%M %p")}"} "+
          "to #{last_datetime}#{last_datetime == last_datetime.beginning_of_day ? "" : " at #{last_datetime.strftime("%I:%M %p")}"}"
        end
      end

      def date_time_to_s(datetime)
        datetime.strftime("%I:%M %p")
      end

      private

      def method_missing(method, *args, &block) #:nodoc:
        range.send(method, *args, &block)
      end
    end
  end
end
