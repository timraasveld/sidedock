require 'tty/command'

module Sidedock
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
end

%w( docker machine ).each { |file| require "sidedock/cli/#{file}_cli" }
