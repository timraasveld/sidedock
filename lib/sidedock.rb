require 'active_support/core_ext/object/blank'
%w( configuration cli base image container ports port_configuration
).each { |file| require "sidedock/#{file}" }

module Sidedock
  class << self
    def with_docker_image(image, options = {}, &block)
      container = Sidedock::Container.create image, options
      container.start
      yield container
      container.stop
      container.remove unless options[:keep_image]
    end

    def with_dockerfile(name, options = {}, &block)
      image = Sidedock::Image.build path_to_dockerfile(name)

      with_docker_image image.id, options do |container|
        yield container
      end

      image.remove
    end

    def path_to_dockerfile(name)
      path = Rails.root.join base_directory, 'docker', name
      raise "Dockerfile path `#{path}` not found" unless File.exist? path
      path
    end

    def base_directory
      case ENV['RAILS_ENV']
      when 'test'
        'spec'
      else
        'app'
      end
    end
  end
end
