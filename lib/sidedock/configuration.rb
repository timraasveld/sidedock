# Allow gem users to do:
#
# Sidedock.configure do |config|
#   config.debug = true
# end

module Sidedock
  class << self
    attr_accessor :configuration
  end

  def self.configure
    yield configuration
  end

  class Configuration
    attr_accessor :debug

    def initialize
      @debug = false
    end
  end

  self.configuration = Configuration.new
  self.configure do |config|
    config.debug = false
  end
end

