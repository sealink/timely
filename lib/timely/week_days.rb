module Timely
  class WeekDays
    WEEKDAY_KEYS = %i[sun mon tue wed thu fri sat]

    def self.from_range(date_range)
      dates = Array(date_range)
      return ALL_WEEKDAYS if dates.count >= WEEKDAY_KEYS.count

      new(dates.each_with_object({}) { |date, result|
        # e.g. {3: true, 5: true}
        result[date.to_date.wday] = true
      })
    end

    # Create a new Weekdays object
    # weekdays can be in three formats
    # integer representing binary string
    #   e.g. 1 = Sun, 2 = Mon, 3 = Sun + Mon, etc.
    # hash with symbol keys for :sun, :mon, ... with true/false values
    #   e.g. {:sun => true, :tue => true} is Sunday and Tuesday
    #   Not passing in values is the same as setting them explicitly to true
    # array with true/false values from sun to sat
    #   e.g. [1, 0, 1, 0, 0, 0, 0] is Sunday and Tuesday
    def initialize(weekdays)
      @weekdays = {
        sun: false,
        mon: false,
        tue: false,
        wed: false,
        thu: false,
        fri: false,
        sat: false
      }

      case weekdays
      when Integer
        # 4 -> 0000100 (binary) -> "0010000" (reversed string) -> {:tue => true}
        weekdays.to_s(2).reverse.each_char.with_index do |char, index|
          set_day(index, char == "1")
        end
      when Hash
        weekdays.each_pair do |day, value|
          set_day(day, value)
        end
      when Array
        weekdays.each.with_index do |value, index|
          set_day(index, value)
        end
      when NilClass
        @weekdays = {
          sun: true,
          mon: true,
          tue: true,
          wed: true,
          thu: true,
          fri: true,
          sat: true
        }
      else
        raise ArgumentError,
              "You must initialize with an Integer, Hash or Array"
      end
    end

    # Set the weekday on or off
    # weekdays[:mon] = true
    # weekdays[:tue] = false
    # set ideally will be true, but 'true', 1 and '1' are accepted
    # All other values will be treated as false
    def []=(day, set)
      set_day(day, set)
    end

    def set_day(day, set)
      key = day_to_index(day)
      unless WEEKDAY_KEYS.include?(key)
        raise ArgumentError, "Invalid week day index #{key}"
      end
      @weekdays[key] = [true, "true", 1, "1"].include?(set)
    end

    def applies_for_date?(date)
      has_day?(date.wday)
    end

    # Determine if weekdays has day selected
    # Accepts either symbol or integer
    # e.g. :sun or 0 = Sunday, :sat or 6 = Saturday
    def has_day?(weekday)
      weekday = WEEKDAY_KEYS[weekday] if weekday.is_a?(Integer)
      @weekdays[weekday]
    end

    def number_of_occurances_in(range)
      range.inject(0) do |count, date|
        applies_for_date?(date) ? count + 1 : count
      end
    end

    # Returns true if all days are selected
    def all_days?
      @weekdays.all? { |_day, day_selected| day_selected }
    end

    # Returns array of weekday selected
    # e.g. [:sun, :sat]
    def weekdays
      selected = @weekdays.select { |_day, day_selected| day_selected }
      # Ruby 1.8 returns an array for Hash#select and loses order
      return selected.keys if selected.is_a?(Hash)
      selected.map(&:first).sort_by { |v| WEEKDAY_KEYS.index(v) }
    end

    # Returns comma separated and capitalized in Sun-Sat order
    # e.g. 'Mon, Tue, Wed' or 'Sat' or 'Sun, Sat'
    def to_s
      days = weekdays.map { |day| day.to_s.capitalize }
      last_day = days.pop

      days.empty? ? last_day : days.join(", ") + ", and " + last_day
    end

    # 7 bits encoded in decimal number
    # 0th bit = Sunday, 6th bit = Saturday
    # Value of 127 => all days are on
    def weekdays_int
      int = 0
      WEEKDAY_KEYS.each.with_index do |day, index|
        int += 2 ** index if @weekdays[day]
      end
      int
    end

    private

    def day_to_index(day)
      if day.is_a?(Integer)
        WEEKDAY_KEYS[day]
      elsif day.is_a?(String)
        day.to_sym
      else
        day
      end
    end

    ALL_WEEKDAYS = WeekDays.new(%w[1 1 1 1 1 1 1])
  end
end
