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
    self.configuration ||= Configuration.new
    yield configuration
  end

  class Configuration
    attr_accessor :debug

    def initialize
      @debug = false
    end
  end
end

