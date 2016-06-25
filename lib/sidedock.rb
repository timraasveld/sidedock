def with_docker_image(image, options = {}, &block)
  container = Sidedock::Container.new image, options
  container.start
  yield container
  container.stop
  container.remove
end

def with_dockerfile(name, options = {}, &block)
  image = Sidedock::Image.build Rails.root.join('spec', 'docker', name)

  with_docker_image image.id, options do |container|
    yield container
  end

  image.remove
end

module Sidedock
  class Base
    def machine
      self.class.machine
    end

    def self.machine
      @@machine ||= Machine.new 'sidedock'
    end
  end

  class Image < Base
    attr_accessor :id

    def initialize(id)
      @id = id
    end

    def remove
      machine.execute "rmi -f #{@id}"
    end

    def self.build(dockerfile_path)
      built_id = machine.execute "build -q #{dockerfile_path}"
      Rails.logger.info "Built #{dockerfile_path}, image ID: #{built_id}"
      new built_id
    end
  end

  class Container < Base
    attr_accessor :ports, :id

    def initialize(image_name_or_id, port_mapping: {})
      raise "No image name given" unless image_name_or_id.present?
      @image_name_or_id = image_name_or_id
      @port_mapping = port_mapping
    end

    def start
      raise "already started" if running?
      @id = machine.execute "run -P -d #{@image_name_or_id}"
    end

    def stop
      raise "not running" unless running?
      machine.execute "stop #{@id}"
    end

    def remove
      machine.execute "rm -f #{@id}"
    end

    def ports
      Ports.new(@id, @port_mapping) if @port_mapping.present?
    end

    def running?
      @id.present?
    end

    def bash(command)
      machine.execute "exec -t #{@id} bash -c '#{command}'"
    end

    def ip
      machine.ip
    end
  end

  class Ports < Base
    include Enumerable

    def initialize(machine_id, port_mapping)
      @port_mapping = port_mapping
      @machine_id = machine_id
      define_port_accessors if @port_mapping.present?
    end

    def define_port_accessors
      @port_mapping.each do |name, port_number|
        raise "#{name} cannot be used as port mapping key" if respond_to? :name

        port = find do |port|
          port.internal == port_number
        end

        raise "Port #{port_number} not exposed by Dockerfile, " \
              "change or remove it in the `port_mapping` option. "\
              "Available: #{each.to_h}" unless port.present?

        define_singleton_method name do
          port.external
        end
      end
    end

    def each(&block)
      ports.each &block
    end

    def ports
      @ports ||= raw_configuration_lines.map do |raw_configuration|
        PortConfiguration.new raw_configuration
      end
    end

    def raw_configuration_lines
      @raw_configuration_lines ||= machine.execute("port #{@machine_id}").strip.split("\n")
    end
  end

  class PortConfiguration < Base
    attr_accessor :internal, :external, :protocol
    CLI_FORMAT = /(?<internal>\d*)\/(?<protocol>tcp|udp) -> .*\:(?<external>\d*)/

    def initialize(raw_configuration)
      match = CLI_FORMAT.match raw_configuration
      @internal = match[:internal].to_i
      @external = match[:external].to_i
      @protocol = match[:protocol]
    end
  end

  class Machine
    def initialize(name)
      @name = name
    end

    def ensure_exists
      create unless exists?
      raise "Could not create docker machine #{@name}" unless exists?
    end

    def ensure_running
      ensure_exists
      start unless running?
      raise "Could not start docker machine #{@name}" unless running?
    end

    def running?
      docker_machine("ls -q --filter state=Running").include? @name
    end

    def start
      docker_machine "start #{@name}"
    end

    def create
      puts "Creating docker machine `#{@name}`. This may take a while."
      docker_machine "create -d virtualbox #{@name}"
    end

    def exists?
      docker_machine("ls -q").include? @name
    end

    def ip
      docker_machine "ip #{@name}"
    end

    def execute(command)
      ensure_running
      cli.execute command
    end

    def docker_machine(command)
      @machine_cli ||= MachineCLI.new
      @machine_cli.execute command
    end

    def cli
      @cli ||= DockerCLI.new options_to_let_docker_connect_to_it
    end

    def options_to_let_docker_connect_to_it
      docker_machine("config #{@name}").gsub("\n", ' ')
    end
  end

  class CLI
    class_attribute :program

    def initialize(default_options = '')
      @default_options = default_options
      @cmd = TTY::Command.new
    end

    def execute(command)
      full_command = "#{program} #{@default_options} #{command}"
      stdout, stderr = @cmd.run full_command
      raise "`#{command}` failed" if stderr.present?
      stdout.strip
    end
  end

  class DockerCLI < CLI
    self.program = 'docker'
  end

  class MachineCLI < CLI
    self.program = 'docker-machine'
  end
end
