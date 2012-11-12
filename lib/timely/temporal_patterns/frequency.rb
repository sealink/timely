module Timely
  module TemporalPatterns
    class Frequency
      UNITS = [:second, :minute, :hour, :day, :week, :fortnight, :month, :year]

      attr_accessor :duration

      def initialize(duration)
        self.duration = duration
      end

      def duration=(duration)
        raise ArgumentError, "Frequency (#{duration}) must be a duration" unless duration.is_a?(ActiveSupport::Duration)
        raise ArgumentError, "Frequency (#{duration}) must be positive" unless duration > 0
        @duration = self.class.parse(duration)
      end

      def <=>(other)
        self.duration <=> other.duration
      end

      def to_s
        "every #{duration.inspect}"
      end

      def unit
        parts = self.class.decompose(duration)
        parts.size == 1 && parts.first.last == 1? parts.first.first : nil
      end

      def min_unit
        parts = self.class.decompose(duration)
        {parts.last.first => parts.last.last}
      end

      def max_unit
        parts = self.class.decompose(duration)
        {parts.first.first => parts.first.last}
      end

      def units
        self.class.decompose_to_hash(duration)
      end

      class << self
        def singular_units
          UNITS.dup
        end

        def plural_units
          UNITS.map { |unit| unit.to_s.pluralize.to_sym }
        end

        def unit_durations
          UNITS.map { |unit| 1.call(unit) }
        end

        def valid_units
          singular_units + plural_units
        end

        def valid_unit?(unit)
          valid_units.include?(unit.to_s.to_sym)
        end

        def parse(duration)
          parsed = 0.seconds
          decompose(duration).each do |part|
            parsed += part.last.send(part.first)
          end
          parsed
        end

        def decompose(duration)
          whole = duration
          parts = []
          plural_units.reverse_each do |unit|
            if whole >= (one_unit = 1.send(unit))
              current_unit_value = ((whole / one_unit).floor)
              if current_unit_value > 0
                parts << [unit, current_unit_value]
                whole -= current_unit_value.send(unit)
              end
            end
          end
          parts
        end

        def decompose_to_hash(duration)
          decompose(duration).inject({}) do |hash, unit|
            hash[unit.first] = unit.last
            hash
          end
        end
      end

      private

      def method_missing(method, *args, &block) #:nodoc:
        duration.send(method, *args, &block)
      end
    end
  end
end
