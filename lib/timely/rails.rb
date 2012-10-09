require 'timely/rails/extensions'
ActiveRecord::Base.extend Timely::Extensions
require 'timely/rails/season'
require 'timely/rails/date_group'
require 'timely/rails/date_range_validity_module'
