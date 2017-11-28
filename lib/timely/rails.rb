require 'timely/rails/extensions'
if defined?(ActiveRecord)
  ActiveRecord::Base.extend Timely::Extensions
  require 'timely/rails/season'
  require 'timely/rails/date_group'
end
require 'timely/rails/date_range_validity_module'
require 'timely/rails/calendar_tag'
require 'timely/rails/date_time'
require 'timely/rails/date'
require 'timely/rails/period'
require 'timely/rails/time'
