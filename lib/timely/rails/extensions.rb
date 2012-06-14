module Timely
  module Extensions
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

    def acts_as_seasonal
      belongs_to :season, :class_name => 'Timely::Season'
      accepts_nested_attributes_for :season
      validates_associated :season

      if Rails.version > '3'
        scope :season_on, lambda { |*args|
          date = args.first || ::Date.current # Can't assign in block in Ruby 1.8
          joins(:season => :date_groups).where("date_groups.start_date <= ? AND date_groups.end_date >= ?", date, date)
        }

        scope :available_from, lambda { |*args|
          date = args.first || ::Date.current # Can't assign in block in Ruby 1.8
          where("boundary_end >= ?", date)
        }
      else
        named_scope :season_on, lambda { |*args|
          date = args.first || ::Date.current # Can't assign in block in Ruby 1.8
          {
            :joins => {:season => :date_groups},
            :conditions => ["date_groups.start_date <= ? AND date_groups.end_date >= ?", date, date]
          }
        }

        named_scope :available_from, lambda { |*args|
          date = args.first || ::Date.current # Can't assign in block in Ruby 1.8
          {:conditions => ["boundary_end >= ?", date]}
        }
      end

      before_save do |object|
        if object.season
          object.boundary_start = object.season.boundary_start
          object.boundary_end   = object.season.boundary_end
        end
      end
    end
  end
end

