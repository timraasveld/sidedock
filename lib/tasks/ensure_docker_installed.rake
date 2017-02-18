class DockerCommandMissingError < StandardError; end

task :ensure_docker_installed do
  if system 'type -p docker > /dev/null'
    'Docker installed'
  else
    raise DockerCommandMissingError.new "Make sure Docker is installed before installing sidedock.\n" \
                                        "For example, try: brew cask install docker (Mac)\n" \
                                        "                  apt-get install -y docker (Debian / Ubuntu)"
  end
end
