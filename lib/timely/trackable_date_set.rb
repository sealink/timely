# frozen_string_literal: true

require 'set'

# Track a set of dates (usually a range)
#
# Tracking means to remember whether each date has been worked on, or 'done'.
#
#   range = Date.current..(Date.current+10)
#   my_dates = TrackableDateSet.new(range)
#
#   my_dates.set_date_done!(Date.current)
#   my_dates.set_dates_done!([Date.current+1, Date.current+2])
#   my_dates.set_all_done!
#
#
#
# As well as tracking status of individual dates, you can also remember whether
# any action has been applied or not across the whole set:
#
#   my_dates = TrackableDateSet.new(Date.current..(Date.current+10))
#
#   my_dates.apply_action(:minimum_nights_surcharge)
#   my_dates.action_applied?(:minimum_nights_surcharge)   # will be true
#
module Timely
  class TrackableDateSet
    attr_reader :start_date, :end_date, :dates_to_do

    # Pass in dates as array, range or any kind of enumerable
    def initialize(dates)
      # Sort so that start/end date are correct
      sorted_dates = dates.sort

      # Have to do this, because Set doesn't respond to :last
      # ...but .sort returns an array which does
      @start_date = sorted_dates.first
      @end_date = sorted_dates.last

      @dates = Set.new(sorted_dates)
      # track dates_to_do instead of dates_done... better fits common access patterns
      @dates_to_do = @dates.dup
    end

    def self.new_for_date(date, opts = {})
      duration = opts[:duration] || 1
      TrackableDateSet.new(date..(date + duration - 1))
    end

    # TODO: remove
    # Initialize from a date + duration
    def self.from_params(date_string, duration_string = nil)
      duration = duration_string.to_i
      duration = 1 if duration.zero?
      new_for_date(date_string.to_date, duration: duration)
    end

    attr_reader :dates

    # Find the set of dates which are YET to do
    def find_to_do
      @dates_to_do
    end

    # Find which dates ARE done
    def dates_done
      @dates - @dates_to_do
    end
    alias find_done dates_done

    # Yield each date to do
    def each_date_to_do
      @dates_to_do.each { |date| yield date }
    end

    # Yield each date in the whole set
    def each_date
      @dates.each { |date| yield date }
    end

    # Set dates as done
    def set_dates_done!(date_enum)
      @dates_to_do.subtract(date_enum)
    end

    def set_date_done!(date)
      @dates_to_do.delete(date)
    end

    # Set all done!
    def set_all_done!
      @dates_to_do.clear
    end

    def done_dates?(date_or_date_range)
      if date_or_date_range.is_a?(Enumerable)
        @dates_to_do.none? { |date_to_do| date_or_date_range.include?(date_to_do) }
      else
        !@dates_to_do.include? date_or_date_range
      end
    end

    def all_done?
      @dates_to_do.empty?
    end

    # Do something once within this tracked period
    #
    # Will only consider job done when opts[:job_done] is true
    #
    #   action_name => Name to track
    #   {:job_done_when} => Block to call, passed result of yield
    def do_once(action_name, opts = {})
      return if action_applied?(action_name)

      result = yield

      job_done = opts[:job_done_when].blank? || opts[:job_done_when].call(result)
      apply_action(action_name) if job_done
    end

    # Remember an action has been applied across the whole date set
    def apply_action(action)
      actions_applied << action
    end

    # Check if an action has been applied
    def action_applied?(action)
      actions_applied.include? action
    end

    def duration
      @dates.size
    end
    alias number_of_nights duration

    # Can't say whole_period anymore... it's not necessarily sequential dates
    #  def whole_period
    #    self.dates
    #  end

    private

    def actions_applied
      @actions_applied ||= Set.new
    end
  end
end
