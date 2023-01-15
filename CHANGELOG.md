# Changelog

## 0.12.0

- [PLAT-954] Handle additional `to_s` deprecation on Rails 7

## 0.11.0

- [PLAT-346] Handle `to_s` deprecation on Rails 7

## 0.10.0

- [PLAT-183] Publish coveralls with github actions add ruby 3.1 to test matrix

## 0.9.0

- [TT-8614] Update to build with github actions / ruby 3.0 / rails 6.1

## 0.8.0

- [TT-6441] Turns out we don't actually need time difference in QT
- [TT-6661] Fix issue when detecting intersecting date groups

## 0.7.0

- [TT-6441] Due to TimeDifference being unmaintained bring it into the timely library

## 0.6.0

- [TT-6402] Require date group weekdays bit field to be not null/nil
  IMPORTANT: Rails projects must add a migration to make this field not null!
- [TT-6401] Remove Rails 3 support, unused methods

## 0.5.0

- [TT-6193] Date group scopes for more efficient searches/restrictions

## 0.4.2

- [TT-5794] Fix belongs_to associations are not explicitly marked optional

## 0.4.1

- [TT-5674] Make multi year date format friendlier

## 0.4.0

- [TT-5648] Fix date_range to string when a single month covers a year period

## 0.3.4

- [TT-4812] Remove bootstrap class from calender tag

## 0.3.3

- Skipped due to mis-tagged version

## 0.3.2

- [TT-4716] Better exception message when a range is invalid

## 0.3.1

- Using Fixnum is deprecated

## 0.3.0

- Add time zone awareness for Time#on (e.g. Rails)
- Required Timely.load to load overrides

## 0.2.0

- Rails 5 support

## 0.1.0

- Initial release
