**NOTE: The current code is quite buggy and definitely not production-ready. In its current state, it's only suitable for testing (which I built it for originally)**

## The problem
Docker is supposed to make it easy to, I quote, *Build, Ship, and Run Any App, Anywhere*. While it may live up to this promise in big enterprises with lots of money and time, in small teams using Docker can be quite problematic because:

- You have to think of a build workflow and set up a deployment system. When are images updated, built, and started?
- How to ensure Docker is up when your Rails app is, when your server reboots or a new version of your Rails app is deploying
- In a microservices set-up, when one of your services is updated, your main app also needs to be updated to match the new API/schema of the service. If you have lots of time, the solution to this is to temporarily support two code paths for the old and new API.

Docker's concepts of images and containers are designed for big enterprises who have to scale, not for the 95% of small companies whose main concern is getting more people to enjoy their app.

## The solution
Sidedock assumes the server you run Rails on is powerful enough to also run the Docker services you need, allowing you define a Dockerfile under `app/docker` (or `spec/docker` for testing purposes), and automagically bring it up and down within a `with_dockerfile 'my_dockerfile' do`-block. This allows you to have the benefits of Docker without the big sysop/devops task that normally comes along with it.

## Usage
### Rspec
Example:
```docker
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
