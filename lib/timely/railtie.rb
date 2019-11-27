# frozen_string_literal: true

class Railtie < Rails::Railtie
  initializer 'timely.initialize' do
    ActiveSupport.on_load(:action_view) do
      require 'timely/rails'
    end
  end
end
