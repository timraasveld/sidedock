module Sidedock
  class DockerCLI < CLI
    self.program = 'docker'

    command_wrapper :create
  end
end
