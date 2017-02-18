require 'bundler/setup'
Bundler.require

require 'sidedock'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  Kernel.srand config.seed
  config.order = 'random'

  require 'fantaskspec'
  config.infer_rake_task_specs_from_file_location!
end

Rake.application.init
Rake.application.load_rakefile
