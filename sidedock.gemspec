Gem::Specification.new do |s|
  s.name        = 'sidedock'
  s.version     = '2.0.0-beta2'
  s.date        = '2016-06-23'
  s.summary     = 'Sidedock'
  s.description = 'Simplify working with Docker by running Dockerfiles from your Rails app'
  s.authors     = ['Tim Raasveld']
  s.email       = 'ttimitri@gmail.com'
  s.files       = `git ls-files -- lib/*`.split("\n")
  s.homepage    = 'https://github.com/timraasveld/sidedock'
  s.license     = 'MIT'
  s.post_install_message = "Make sure Docker is installed before using sidedock.\n" \
                           "For example, try: brew cask install docker && open -a 'docker' (Mac)\n" \
                           "                  apt-get install -y docker (Debian / Ubuntu)"

  s.add_runtime_dependency 'tty-command', '~> 0.1.0'
  s.add_runtime_dependency 'uber', '~> 0.0.15'
  s.add_runtime_dependency 'activesupport'

  s.add_development_dependency 'rake', '~> 10.0'
end
