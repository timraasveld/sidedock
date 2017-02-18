module Sidedock
  class Image < Base
    attr_accessor :id

    def initialize(id)
      @id = id
    end

    def remove
      remove_containers_using_it
      cli.execute "rmi -f #{@id}"
    end

    def remove_containers_using_it
      Container.using_image(self).each(&:remove)
    end

    def self.build(dockerfile_path)
      built_id = cli.execute "build -q #{dockerfile_path}"
      new built_id
    end
  end
end
