class Railtie < Rails::Railtie
  initializer 'timely.initialize' do
    ActiveSupport.on_load(:active_record) do
      require 'timely/rails'
    end
  end
end
