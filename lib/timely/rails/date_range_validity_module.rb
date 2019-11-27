# frozen_string_literal: true

module Timely
  module DateRangeValidityModule
    def self.included(base)
      base.class_eval do
        validates :from, :to, presence: true
      end
    end

    def validity_range
      (from..to)
    end

    def correctness_of_date_range
      return unless from.present? && to.present? && from > to

      errors.add(:base, 'Invalid Date Range. From date should be less than or equal to To date')
    end

    def validity_range_to_s
      "#{from.to_s(:short)} ~ #{to.to_s(:short)}"
    end

    def valid_on?(date)
      validity_range.include?(date)
    end
  end
end
