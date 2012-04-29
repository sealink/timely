module Timely
  module DateTime
    def on_date(date)
      self.change(:year => date.year, :month => date.month, :day => date.day)
    end
  end
end

class DateTime
  include Timely::DateTime
end
