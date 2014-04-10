module Timely
  class Season < ActiveRecord::Base

    if ::ActiveRecord::VERSION::MAJOR >= 4
      has_many :date_groups, lambda { order(:start_date) }, :dependent => :destroy, :class_name => 'Timely::DateGroup'
    else
      has_many :date_groups, :order => :start_date, :dependent => :destroy, :class_name => 'Timely::DateGroup'
    end


    accepts_nested_attributes_for :date_groups,
      :reject_if => proc {|attributes| attributes['start_date'].blank?},
      :allow_destroy => true

    validate :validate_dates_specified

    def validate_dates_specified
      errors.add(:base, "No dates specified") if date_groups.blank?
      errors.empty?
    end

    def includes_date?(date)
      date_groups.any?{|dg| dg.includes_date?(date)}
    end

    def has_gaps?
      last_date = nil
      date_groups.each do |dg|
        return true if last_date && dg.start_date != last_date + 1
      end
      false
    end

    def dates
      date_groups.map do |date_group|
        ((date_group.start_date)..(date_group.end_date)).to_a
      end.flatten
    end

    def boundary_range
      boundary_start..boundary_end
    end

    def past?
      boundary_end && boundary_end < ::Date.current
    end

    def boundary_start
      date_groups.map(&:start_date).sort.first
    end

    def boundary_end
      date_groups.map(&:end_date).sort.last
    end

    def within_boundary?(date)
      boundary_start && boundary_end && boundary_start <= date && boundary_end >= date
    end

    def deep_clone
      # Use clone until it is removed in AR 3.1, then dup is the same
      method = ActiveRecord::Base.instance_methods(false).include?(:clone) ? :clone : :dup
      cloned = self.send(method)
      date_groups.each do |dg|
        cloned.date_groups.build(dg.send(method).attributes)
      end
      cloned
    end

    def self.build_season_for(dates=[])
      season = Season.new
      date_groups = dates.map do |date|
        DateGroup.new(:start_date => date, :end_date => date)
      end
      season.date_groups = date_groups
      season
    end

    def to_s
      name.presence || Timely::DateRange.to_s(boundary_start, boundary_end)
    end

    alias_method :audit_name, :to_s

    def string_of_date_groups
      date_groups.map{|dg| "#{dg.start_date.to_s(:short)} - #{dg.end_date.to_s(:short)}"}.to_sentence
    end
  end
end
