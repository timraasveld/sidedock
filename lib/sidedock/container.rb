module Sidedock
  class Container < Base
    attr_accessor :ports, :id

    def initialize(id, port_mapping: {}, **options)
      @id = id
      @port_mapping = port_mapping
    end

    def self.create(image_name_or_id, options)
      raise "No image name given" unless image_name_or_id.present?
      id = cli.create "-P #{image_name_or_id}"
      new id, **options
    end

    def start
      raise "already started" if running?
      cli.execute "start #{@id}"
    end

    def stop
      raise "not running" unless running?
      cli.execute "stop #{@id}"
    end

    def remove
      cli.execute "rm -f #{@id}"
    end

    def ports
      @ports ||= Ports.new @id, @port_mapping
    end

    def running?
      cli.execute('ps -q --no-trunc').include? @id
    end

    def bash(command)
      cli.execute "exec -t #{@id} bash -c '#{command}'"
    end

    def ip
      cli.ip
    end

    def self.all
      cli.execute('ps -q --no-trunc').split.map do |id|
        new id
      end
    end

    def self.using_image(image)
      ps_output = cli.execute "ps -a -q --filter ancestor=#{image.id}"

      ps_output.each_line.map do |id|
        new id
      end
    end
  end
end
