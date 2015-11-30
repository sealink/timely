require 'spec_helper'

describe Timely::TimeField do
  let(:klass) {
    Class.new do
      include Timely::TimeField

      def initialize(attrs)
        @start_time = attrs[:start_time]
        @end = attrs[:end]
      end

      def read_attribute(attr)
        instance_variable_get("@#{attr}".to_sym)
      end

      time_fields :start_time, :end
    end
  }

  subject {
    klass.new(
      start_time: DateTime.new(2000, 1, 1, 11, 59, 0),
      end: DateTime.new(2000, 1, 1, 23, 59, 0)
    )
  }

  its(:methods) { should include :start_time_of_day }
  its(:methods) { should include :end_time_of_day }
  its(:start_time_of_day) { should eq Timely::TimeOfDay.new(11, 59) }
  its(:end_time_of_day) { should eq Timely::TimeOfDay.new(23, 59) }
end
