require 'rspec/core/rake_task'
require "bundler/gem_tasks"

task :default => :spec

Dir.glob('lib/tasks/*.rake').each { |r| load r }

task install: :ensure_docker_installed
