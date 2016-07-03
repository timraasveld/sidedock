require 'bundler/setup'
Bundler.setup

require 'your_gem_name' # and any other gems you need

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  Kernel.srand config.seed
  config.order = 'random'
  config.infer_rake_task_specs_from_file_location!
end
