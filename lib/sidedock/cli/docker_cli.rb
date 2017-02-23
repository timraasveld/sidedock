module Sidedock
  class DockerCLI < CLI
    self.program = 'docker'

    command_wrapper :create

    def ip
      '127.0.0.1'
    end
  end
end
