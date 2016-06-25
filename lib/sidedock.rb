%w( cli machine base image container ports port_configuration )
  .each { |file| require "sidedock/#{file}" }

module Sidedock
  def with_docker_image(image, options = {}, &block)
    container = Sidedock::Container.new image, options
    container.start
    yield container
    container.stop
    container.remove
  end

  def with_dockerfile(name, options = {}, &block)
    image = Sidedock::Image.build Rails.root.join('spec', 'dockerfiles', name)

    with_docker_image image.id, options do |container|
      yield container
    end

    image.remove
  end
end
