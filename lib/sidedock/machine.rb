module Sidedock
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
end
