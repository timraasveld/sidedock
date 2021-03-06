module Sidedock
  class Ports < Base
    include Enumerable

    def initialize(container_id, port_mapping)
      @port_mapping = port_mapping
      @container_id = container_id
      define_port_accessors if @port_mapping.present?
    end

    def define_port_accessors
      @port_mapping.each do |name, port_number|
        raise MethodInUse.new(self.class) if respond_to? name

        port = find do |port|
          port.internal == port_number
        end

        raise "Port #{port_number} not exposed by Dockerfile, " \
              "change or remove it in the `port_mapping` option. "\
              "Available: #{each.to_h}" unless port.present?

        define_singleton_method name do
          port.external
        end
      end
    end

    def each(&block)
      ports.each &block
    end

    def ports
      @ports ||= raw_configuration_lines.map do |raw_configuration|
        PortConfiguration.new raw_configuration
      end
    end

    def raw_configuration_lines
      @raw_configuration_lines ||= cli.execute("port #{@container_id}").strip.split("\n")
    end
  end
end
