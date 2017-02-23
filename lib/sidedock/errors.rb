module Sidedock
  class Error < StandardError; end
  class DockerfileNotFound < Error
    def initialize(dockerfile)
      @dockerfile = dockerfile
    end

    def message
      "Expected Dockerfile to be defined in #{@dockerfile}"
    end
  end

  class DirectoryNotFound < Error
    def initialize(search_paths)
      @search_paths = search_paths
    end

    def message
      "Expected one of directories #{@search_paths} to exists"
    end
  end

  class MethodInUse < Error
    def initialize(klass, method)
      @klass, @method = klass, method
    end

    def message
      "Cannot define #{@klass}##{@method} because it is already implemented"
    end
  end
end
