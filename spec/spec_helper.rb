require 'bundler/setup'
Bundler.require

require 'byebug'
require 'sidedock'
include Sidedock # Don't require specifying module in every spec

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  # Add focus: true to a context to run only that test
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  Kernel.srand config.seed
  config.order = 'random'
end
