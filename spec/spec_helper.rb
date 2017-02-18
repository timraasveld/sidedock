require 'bundler/setup'
Bundler.require

require 'sidedock'
include Sidedock # Don't require specifying module in every spec

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  Kernel.srand config.seed
  config.order = 'random'
end
