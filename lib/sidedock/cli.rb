require 'tty/command'
require 'uber/inheritable_attr'

module Sidedock
  # Base class for command line utilities used by sidedock.
  class CLI
    extend Uber::InheritableAttr
    inheritable_attr :program # System command name

    def initialize(default_options = '')
      @default_options = default_options
    end

    def execute(command)
      full_command = "#{program} #{@default_options} #{command}"
      stdout, stderr = command_runner.run full_command
      raise "`#{command}` failed" if stderr.present?
      stdout.strip
    end

    protected
    # Create wrapper for a CLI command of the program.
    # Mainly useful for testing purposes because you want to mock output of a given command
    def self.command_wrapper(*commands)
      commands.each do |command|
        raise "#{command} cannot be used as command wrapper because method already exists for #{self}" if respond_to? command

        define_method command do |args|
          execute "#{command} #{args}"
        end
      end
    end

    private

    def program
      self.class.program
    end

    def command_runner
      if Sidedock.configuration.debug
        debug_command_runner
      else
        quiet_command_runner
      end
    end

    def debug_command_runner
      @debug_command_runner ||= TTY::Command.new
    end

    def quiet_command_runner
      @quiet_command_runner ||= TTY::Command.new printer: :null
    end
  end
end

%w( docker ).each { |file| require "sidedock/cli/#{file}_cli" }
