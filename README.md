Sidedock lets you easily run a supporting application(= service) in your testsuite by leverage the power of Docker. It tries to abstract away as many of Dockers complexities as possible to make it team-friendly.

You can create a class around the service to query internal state.

**NOTE: The current code has been tested in a small variety of setups and you may experience problems. Please create an issue describing your OS and `docker --version` and I'll try my best to fix your problem. Or create a PR if you're feeling generous :-)**

# Do I need it?
If you integrate against a well-documented, versioned service such as Twitter's API it's probably better to just record responses using a gem like [VCR](https://github.com/vcr/vcr).

Testing against the real service may be useful if:
- it is an internal API (à la microservices) that is not versioned because you're the only consumer. Sidedock helps you to quickly make changes and see which tests break without updating recorded responses.
- it uses a stateful protocol such as FTP, which is difficult to mock and dependent on server configuration
- it uses an uncommon protocol for which no easy mocking tools are available

# Installation
```ruby
gem 'sidedock', '~> 2.0.0-beta2'
```

# Usage
## Basic example
```dockerfile
# spec/docker/ftp_server/Dockerfile

# spec/docker/ftp_server is Docker's build directory, put any files you reference in the Dockerfile here
FROM odiobill/vsftpd
RUN bash -c 'useradd test -p $1$2f712aa7$bP1dXBeOEUoeTdnUeNLGQ/'
```

```ruby
# spec/docker/ftp_server.rb
class FtpServer < SideDock::Service
  port :ftp, 21        # Allows you to access auto-assigned FTP port as ftp_seerver.ports.ftp
  cli_method :cat, :ls # defines method ftp_server.cat and ftp_server.ls, wrapping arround the system commands.
                       # sh is provided by default.

  # Example internal state accessor. This one could be used to assert that a
  # file uploaded by your app is actually on the server.
  def files(directory = '/')
    ls(directory).split
  end
end
```

Then, to use the service in your test:
```ruby
describe 'connecting to a FTP server' do
  FtpServer.use do |ftp_server|
    ftp_server.files # => ["bin", "boot", "dev", ...]

    ftp_client = Net::FTP.new
    ftp_client.connect Net::FTP.connect ftp_server.ip, ftp_server.ports.ftp
  end
end
```

## `Sidedock::Service#use` options
```ruby
FtpServer.use {
  port_mapping: { https: 443 },  # Provide additional port accessors
  keep_image: false              # Don't remove image after build, allowing Docker to cache.
                                 # On by default to provide a fast development feedback cycle.
                                 # If your knowledge of Dockers caching mechanisms is limited,
                                 # switch this off for a more predictable experience
} do
  something
end
```

## Non-Rails projects
If your project doesn't use Rails, you have to manually require services before use, example:
```ruby
# spec/lib/foo_spec.rb
require_relative '../docker/foo_service'

FooService.use do |foo_service|
  ...
```

# Configuration
```ruby
# Intializer-style syntax
Sidedock.configure do |config|
  config.debug = true # Print each executed docker command
end

# Shorthand syntax
Sidedock.configuration.debug = true
```
