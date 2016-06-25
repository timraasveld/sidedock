module Sidedock
  class Container < Base
    attr_accessor :ports, :id

    def initialize(image_name_or_id, port_mapping: {})
      raise "No image name given" unless image_name_or_id.present?
      @image_name_or_id = image_name_or_id
      @port_mapping = port_mapping
    end

    def start
      raise "already started" if running?
      @id = machine.execute "run -P -d #{@image_name_or_id}"
    end

    def stop
      raise "not running" unless running?
      machine.execute "stop #{@id}"
    end

    def remove
      machine.execute "rm -f #{@id}"
    end

    def ports
      Ports.new(@id, @port_mapping) if @port_mapping.present?
    end

    def running?
      @id.present?
    end

    def bash(command)
      machine.execute "exec -t #{@id} bash -c '#{command}'"
    end

    def ip
      machine.ip
    end

    def self.using_image(image)
      ps_output = machine.execute "ps -a -q --filter ancestor=#{image.id}"
      ps_output.each_line.map do |id|
        new id
      end
    end
  end
end
