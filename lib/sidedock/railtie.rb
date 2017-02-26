module Sidedock
  class Railtie < ::Rails::Railtie
    initializer 'sidedock.autoload', :before => :set_autoload_paths do |app|
      %w( spec test ).each do |tests_directory|
        app.config.autoload_paths << "#{Rails.root}/#{tests_directory}/docker"
      end
    end
  end
end
