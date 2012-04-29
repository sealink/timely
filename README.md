Timely
======

# DESCRIPTION

Various helpers to work with times, dates and weekdays, etc.

It includes the following (see end for full descriptions)
* Core extensions to Date and Time
* DateChooser, a class to help select a subset of dates within any range, e.g. All 2nd Sundays, Every 15th of the month, All Tuesdays and Wednesdays
* WeekDays, a class to manage the selection of weekdays, outputs a integer representing which days as a number between 0 and 127 (e.g. a 7 bit integer)
* DateRange: A subclass of Range for dates with various helpers and aliases
* TrackableDateSet: Recording set of dates processed/processing
* TemporalPatterns: Various other classes related to time, e.g. Frequency

# INSTALLATION

gem install timely

or add to your Gemfile:
gem 'timely'

# SYNOPSIS

require 'timely'

For examples on most usage see the tests in the spec directory.
As these contain many basic examples with expected output.

## Core Extensions

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
