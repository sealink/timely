# frozen_string_literal: true

module Timely
  # Uses Date.current to be more accurate for Rails applications
  def self.current_date
    ::Date.respond_to?(:current) ? ::Date.current : ::Date.today
  end

  module ActionViewHelpers
    module FormTagHelper
      def calendar_tag(name, value = Timely.current_date, *args)
        options = args.extract_options!

        if value.respond_to?(:day)
          value = value.respond_to?(:to_fs) ? value.to_fs(:calendar) : value.to_s(:calendar)
        end

        name = name.to_s if name.is_a?(Symbol)

        options[:id] = options[:id] || name.gsub(/\]$/, '').gsub(/\]\[/, '[').gsub(/[\[\]]/, '_')

        options[:class] = options[:class].split(' ') if options[:class].is_a?(String)
        options[:class] ||= []
        options[:class] << 'datepicker'
        options[:class] = options[:class].join(' ') # Rails 2 requires string values

        options[:size] ||= 10
        options[:maxlength] ||= 10

        tag(:input, options.merge(name: name, type: 'text', value: value)).html_safe
      end
    end

    module DateHelper
      def calendar(object_name, method, options = {})
        value = options[:object] || Timely.current_date
        calendar_tag("#{object_name}[#{method}]", value, options)
      end
    end

    module FormBuilder
      def calendar(method, options = {})
        options[:object] = @object.send(method) unless options.key?(:object)
        @template.calendar(@object_name, method, options)
      end
    end
  end
end

if defined?(ActionView)
  ActionView::Base.send :include, Timely::ActionViewHelpers::FormTagHelper
  ActionView::Base.send :include, Timely::ActionViewHelpers::DateHelper
  ActionView::Helpers::FormBuilder.send :include, Timely::ActionViewHelpers::FormBuilder
end
