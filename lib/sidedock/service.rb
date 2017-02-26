require 'active_support/all'

module Sidedock
  class Service
    attr_reader :container

    delegate :ip, :sh, :ports, to: :container

    def self.use(options = {})
      options[:port_mapping] ||= {}
      options[:port_mapping].merge! port_mapping

      Sidedock.with_docker_image image.id, options do |container|
        yield new(container)
      end

      remove_image if options[:keep_image] == false
    end

    protected

    def self.cli_method(*commands)
      commands.each do |command|
        raise MethodInUse.new self, command if method_defined? command

        define_method command do |args|
          container.sh "#{command} #{args}"
        end
      end
    end

    cattr_accessor :port_mapping
    self.port_mapping = {}

    def self.port(name, internal_port)
      port_mapping[name] = internal_port
    end

    def self.dockerfile_path
      "#{directory}/#{to_s.underscore}/#{dockerfile}"
    end

    def self.dockerfile
      'Dockerfile'
    end

    cattr_accessor :directory
    def self.inherited(k)
      k.directory = caller.first.match(/^([^:]+)\/.+\.rb/)[1]
    end

    def self.image
      raise DockerfileNotFound.new(dockerfile_path) unless File.exist? dockerfile_path
      @@image ||= Image.build directory, dockerfile_path
    end

    private

    def initialize(container)
      @container = container
    end

    def self.remove_image
      image.remove
      @@image = nil
    end
  end
end
