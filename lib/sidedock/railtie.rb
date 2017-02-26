module Sidedock
  class Railtie < ::Rails::Railtie
    initializer 'sidedock.autoload', :before => :set_autoload_paths do |app|
      return unless Rails.env.test?

      %w( spec test ).map { |d| Rails.root.join d }.each do |tests_directory|
        app.config.autoload_paths << File.join(tests_directory, 'docker') if File.directory? tests_directory
      end
    end
  end
end
