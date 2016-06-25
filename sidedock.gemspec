Gem::Specification.new do |s|
  s.name        = 'sidedock'
  s.version     = '0.0.1'
  s.date        = '2016-06-23'
  s.summary     = 'Sidedock'
  s.description = 'Simplify working with Docker by running Dockerfiles from your Rails app'
  s.authors     = ['Tim Raasveld']
  s.email       = 'ttimitri@gmail.com'
  s.files       = `git ls-files -- lib/**/*`.split("\n")
  s.homepage    = 'https://github.com/timraasveld/sidedock'
  s.license     = 'MIT'
end
