require 'tty/command'
require 'uber/inheritable_attr'

module Sidedock
  class CLI
    def initialize(default_options = '')
      @default_options = default_options
    end

    def execute(command)
      full_command = "#{program} #{@default_options} #{command}"
      stdout, stderr = command_runner.run full_command
      raise "`#{command}` failed" if stderr.present?
      stdout.strip
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

%w( docker machine ).each { |file| require "sidedock/cli/#{file}_cli" }
