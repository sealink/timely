module Timely
  module TimeField
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def time_fields(*attributes)
        attributes.each do |attribute|
          method_name = if attribute.to_s.ends_with?('time')
            attribute.to_s + '_of_day'
          else
            attribute.to_s + '_time_of_day'
          end
          self.send :define_method, method_name, -> { TimeOfDay.from_time(self.read_attribute attribute) }
        end
      end
    end
  end
end
