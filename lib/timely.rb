module Timely
  VERSION = '0.0.2'

  require 'time'
  require 'date'

  require 'timely/string'
  require 'timely/date'
  require 'timely/time'
  require 'timely/date_time'
  require 'timely/range'
  require 'timely/date_range'
  require 'timely/date_chooser'
  require 'timely/week_days'
  require 'timely/temporal_patterns/finder'
  require 'timely/temporal_patterns/frequency'
  require 'timely/temporal_patterns/interval'
  require 'timely/temporal_patterns/pattern'
  require 'timely/trackable_date_set'

  require 'timely/railtie' if defined?(Rails::Railtie)
end
