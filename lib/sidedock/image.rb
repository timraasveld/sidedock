module Sidedock
  class Image < Base
    attr_accessor :id

    def initialize(id)
      @id = id
    end

    def remove
      remove_containers_using_it
      machine.execute "rmi -f #{@id}"
    end

    def remove_containers_using_it
      Container.using_image(self).each(&:remove)
    end

    def self.build(dockerfile_path)
      built_id = machine.execute "build -q #{dockerfile_path}"
      Rails.logger.info "Built #{dockerfile_path}, image ID: #{built_id}"
      new built_id
    end
  end
end