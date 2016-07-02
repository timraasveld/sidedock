**NOTE: The current code is quite buggy and definitely not production-ready. In its current state, it's only suitable for testing (which I built it for originally)**

## The problem
Docker is supposed to make it easy to, I quote, *Build, Ship, and Run Any App, Anywhere*. While it may live up to this promise in big enterprises with lots of money and time, in small teams using Docker can be quite problematic because:

- You have to think of a build workflow and set up a deployment system. When are images updated, built, and started?
- You have to ensure required Docker services are up when your main app is, when your server reboots or a new version of your Rails app is deploying

Docker's concepts of images and containers are designed for big enterprises who have to scale, not for the 95% of small companies whose main concern is getting more people to enjoy their app.

## The solution
Sidedock assumes the server you run Rails on is powerful enough to also run the Docker services you need, allowing you define a Dockerfile under `app/docker` (or `spec/docker` for testing purposes), and automagically bring it up and down within a `with_dockerfile 'my_dockerfile' do`-block. This allows you to have the benefits of Docker without the big sysop/devops task that normally comes along with it.

## Basic usage
### RSpec
Example:
```ruby
# Gemfile
gem 'sidedock', '~> 1.0.3'
```

```dockerfile
# spec/docker/ftp_server/Dockerfile
FROM odiobill/vsftpd
RUN bash -c 'useradd test -p $1$2f712aa7$bP1dXBeOEUoeTdnUeNLGQ/'
```

Then, to run it alongside your Rspec tests, simply do:
```ruby
before do
  Sidedock.with_dockerfile 'ftp_server', port_mapping: { ftp: 21 } do |ftp_server|
    # Get Docker's automatically assigned port for the service
    puts ftp_server.ports.ftp # => '31425'

    puts ftp_server.ip # => '10.5.2.100'

    puts ftp_server.bash 'cat /etc/hosts' # => '127.0.0.1	localhost
                                          #     ...'
  end
end
```

## Configuration
```ruby
Sidedock.configure do |config|
  config.debug = true # Print each executed docker(-machine) command
end
```

### `with_dockerfile` options
```ruby
Sidedock.with_dockerfile 'gitlab', {
port_mapping: { https: 443 }, # Make port available as `gitlab.ports.https` (default: {})
  keep_image: true            # Don't remove image after build, allowing Docker to cache.
                              # Useful for a fast development feedback cycle,
                              # but you need to have knowledge about how Docker caches
                              # to use this wisely (default: false)
} do
  something
end
```
