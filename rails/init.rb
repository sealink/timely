module Timely
  module ActiveRecord
    # Add a WeekDays attribute
    #
    # By default it will use attribute_bit_array as db field, but this can
    # be overridden by specifying :db_field => 'somthing_else'
    def weekdays_field(attribute, options={})
      db_field = options[:db_field] || attribute.to_s + '_bit_array'
      self.composed_of(attribute,
        :class_name => "::Timely::WeekDays",
        :mapping    => [[db_field, 'weekdays_int']],
        :converter  => Proc.new {|field| ::Timely::WeekDays.new(field)}
      )
    end
  end
end

ActiveRecord::Base.extend Timely::ActiveRecord
