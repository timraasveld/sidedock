module Sidedock
  class Base
    def cli
      self.class.cli
    end

    def self.cli
      @@cli ||= DockerCLI.new ''
    end
  end
end
