require 'rails/railtie'
require 'sidedock/railtie'

describe Railtie do
  it 'autoloads any class from {spec,test}/docker' do
    # Ensure class is not loaded from a previous example
    Object.send :remove_const, :FtpServer if defined? ::FtpServer
    expect(defined?(FtpServer)).to be nil

    # Run Rails app initializers
    Combustion.initialize! :action_controller

    # Found in spec/internal/spec/docker/ftp_server.rb
    FtpServer.instance_eval {} # Trigger autoload
    expect(defined?(FtpServer)).to be_truthy
  end
end
