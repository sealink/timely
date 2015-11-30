module Timely
  module TimeField
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def time_fields(*attributes)
        attributes.each { |attribute| time_field(attribute) }
      end

      def time_field(attribute)
        method_name = attribute.to_s
        method_name += '_time' unless attribute.to_s.ends_with?('time')
        method_name += '_of_day'
        define_method method_name, -> {
          TimeOfDay.from_time(self.read_attribute attribute)
        }
      end
    end
  end
end
