Timely
======

[![Build Status](https://travis-ci.org/sealink/timely.png?branch=master)](https://travis-ci.org/sealink/timely)
[![Build Status](https://gemnasium.com/sealink/timely.png?travis)](https://gemnasium.com/sealink/timely)
[![Build Status](https://codeclimate.com/github/sealink/timely.png)](https://codeclimate.com/github/sealink/timely)

# DESCRIPTION

Various helpers to work with times, dates and weekdays, etc.

It includes the following (see end for full descriptions)
* Core extensions to Date and Time
* DateChooser, a class to help select a subset of dates within any range, e.g. All 2nd Sundays, Every 15th of the month, All Tuesdays and Wednesdays
* WeekDays, a class to manage the selection of weekdays, outputs a integer representing which days as a number between 0 and 127 (e.g. a 7 bit integer)
* DateRange: A subclass of Range for dates with various helpers and aliases
* TrackableDateSet: Recording set of dates processed/processing
* TemporalPatterns: Various other classes related to time, e.g. Frequency

It includes the following rails extensions (only loaded if inside rails project):
* Date Group, a date range which can also be limited to WeekDays, e.g. all weekends between March and April
* Season, a collection of Date Groups
* weekdays_field, a way to declare an integer field to store weekdays (weekdays is stored as 7 bit integer)
* acts_as_seasonal, a way to declare a season_id foreign key as well as some helper methods

# INSTALLATION

gem install timely

or add to your Gemfile:
gem 'timely'

# SYNOPSIS

require 'timely'

For examples on most usage see the tests in the spec directory.
As these contain many basic examples with expected output.

## Core Extensions

```ruby
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
```
