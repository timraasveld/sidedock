module Sidedock
  class Base
    def machine
      self.class.machine
    end

    def self.machine
      @@machine ||= Machine.new 'sidedock'
    end
  end
end
