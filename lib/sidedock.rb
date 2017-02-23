require 'active_support/core_ext/object/blank'
%w( service configuration cli base image container ports port_configuration errors
).each { |file| require "sidedock/#{file}" }

module Sidedock
  class << self
    def with_docker_image(image, options = {}, &block)
      container = Sidedock::Container.create image, options
      container.start
      yield container
      container.stop
      container.remove
    end
  end
end
