class PortConfiguration < Base
  attr_accessor :internal, :external, :protocol
  CLI_FORMAT = /(?<internal>\d*)\/(?<protocol>tcp|udp) -> .*\:(?<external>\d*)/

  def initialize(raw_configuration)
    match = CLI_FORMAT.match raw_configuration
    @internal = match[:internal].to_i
    @external = match[:external].to_i
    @protocol = match[:protocol]
  end
end
