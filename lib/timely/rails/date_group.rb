module Timely
class DateGroup < ActiveRecord::Base
  
#  acts_as_audited

  belongs_to :season

  weekdays_field :weekdays

  validates_presence_of :start_date, :end_date
  validate :validate_date_range!

  def includes_date?(date)
    date >= start_date && date <= end_date && weekdays.applies_for_date?(date)
  end

  
  def applicable_for_duration?(date_range)
    date_range.any?{|d| includes_date?(d)}
  end
  
  
  def dates
    start_date.upto(end_date).select { |d| weekdays.applies_for_date?(d) }
  end

  
  def to_s
    str = start_date && end_date ? (start_date..end_date).to_date_range.to_s : (start_date || end_date).to_s
    
    unless weekdays.all_days?
      str += " on #{weekdays}"
    end
    str
  end
  
  alias_method :audit_name, :to_s
  
  
  
  ################################################################
  #---------------- Date intervals and patterns -----------------#
  ################################################################
  
    
  def pattern
    ranges = dates.group_by(&:wday).values.map { |weekdates| (weekdates.min..weekdates.max) }
    TemporalPatterns::Pattern.new(ranges, 1.week)
  end
  
  
  def self.from_patterns(patterns)
    date_groups = []
    Array.wrap(patterns).each do |pattern|
      if pattern.frequency.unit == :weeks
        weekdays = pattern.intervals.map { |i| i.first_datetime.wday }.inject({}) do |hash, wday|
          hash[wday] = 1
          hash
        end
        date_groups << DateGroup.new(
          :start_date => pattern.first_datetime.to_date,
          :end_date => pattern.last_datetime.to_date,
          :weekdays => weekdays)
      elsif pattern.frequency.unit == :days && pattern.frequency.duration == 1.day
        date_groups << DateGroup.new(
          :start_date => pattern.first_datetime.to_date,
          :end_date => pattern.last_datetime.to_date,
          :weekdays => 127)
      else
        pattern.datetimes.each do |datetimes|
          datetimes.group_by(&:week).values.each do |dates|
            weekdays = dates.map(&:wday).inject({}) do |hash, wday|
              hash[wday] = 1
              hash
            end
            date_groups << DateGroup.new(
              :start_date => dates.min.to_date.beginning_of_week,
              :end_date => dates.max.to_date.end_of_week,
              :weekdays => weekdays)
          end
        end
      end
    end
    date_groups
  end
    
  
  private
  
  def validate_date_range!
    raise InvalidInputException, "Incorrect date range" if start_date && end_date && (start_date > end_date)
  end

end
end

# == Schema Information
#
# Table name: date_groups
#
#  id                 :integer(4)      not null, primary key
#  season_id          :integer(4)
#  start_date         :date
#  end_date           :date
#  created_at         :datetime
#  updated_at         :datetime
#  weekdays_bit_array :integer(4)
#

