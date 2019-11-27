# Changelog

## 0.6.0

* [TT-6402] Require date group weekdays bit field to be not null/nil
            IMPORTANT: Rails projects must add a migration to make this field not null!
* [TT-6401] Remove Rails 3 support, unused methods

## 0.5.0

* [TT-6193] Date group scopes for more efficient searches/restrictions

## 0.4.2

* [TT-5794] Fix belongs_to associations are not explicitly marked optional

## 0.4.1

* [TT-5674] Make multi year date format friendlier

## 0.4.0

* [TT-5648] Fix date_range to string when a single month covers a year period

## 0.3.4

* [TT-4812] Remove bootstrap class from calender tag

## 0.3.3

* Skipped due to mis-tagged version

## 0.3.2

* [TT-4716] Better exception message when a range is invalid

## 0.3.1

* Using Fixnum is deprecated

## 0.3.0

* Add time zone awareness for Time#on (e.g. Rails)
* Required Timely.load to load overrides

## 0.2.0

* Rails 5 support

## 0.1.0

* Initial release
