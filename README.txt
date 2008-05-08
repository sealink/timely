= timely

== DESCRIPTION:

Timely adds some convenience methods to Date and Time to easily create times on specific dates.

== SYNOPSIS:

  require 'timely'
  
  some_date = Date.today - 5      # => 2008-05-03
  some_date.at_time(3, 5, 13)     # => Sat May 03 03:05:13 -0500 2008
  
  # arguments are optional
  some_date.at_time(13)           # => Sat May 03 13:00:00 -0500 2008
  
  some_time = Time.now - 345678   # => Sun May 04 13:40:22 -0500 2008
  some_time.on_date(2001, 6, 18)  # => Mon Jun 18 13:40:22 -0500 2001
  
  # if you have objects corresponding to the times/dates you want
  some_time.on_date(some_date)    # => Sat May 03 13:40:22 -0500 2008
  some_date.at_time(some_time)    # => Sat May 03 13:40:22 -0500 2008
  
  # if you like typing less
  some_time.on(some_date)         # => Sat May 03 13:40:22 -0500 2008
  some_date.at(some_time)         # => Sat May 03 13:40:22 -0500 2008

== INSTALL:

* sudo gem install timely

