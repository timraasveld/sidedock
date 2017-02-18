module Sidedock
  class Base
    def cli
      self.class.cli
    end

    def self.cli
      args = '--debug' if Sidedock.configuration.debug
      args ||= ''
      @@cli ||= DockerCLI.new args
    end
  end
end
