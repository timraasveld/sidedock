**NOTE: The current code is quite buggy and definitely not production-ready. In its current state, it's only suitable for testing (which I built it for originally)**

# Sidedock
Sidedock simplifies working with Docker by allowing you to include a Dockerfile in your Rails app and run it *on the side* when your `rails server` spawns, abstracting away everything Docker requires you to do in between.

## The problem
Docker is supposed to make it easy to, I quote, *Build, Ship, and Run Any App, Anywhere*. While it may live up to this promise in big enterprises who have lots of manpower, in small teams using Docker can be quite problematic because:

- In a microservices set-up, when one of your services is updated, your main app also often needs to be updated. Most teams simply don't have time for API versioning and backwards compatibility.
- You have to think of a build workflow and set up a deployment system. When are images updated, built, and started?
- How to ensure Docker is up when your Rails app is, when your server reboots or a new version of your Rails app is deploying

Docker's concepts of images and containers are designed for big enterprises who have to scale, and not for the 95% of small companies companies whose main concern is growing their user base.

## The solution
Sidedock assumes the server you run Rails on is powerful enough to also run the Docker services you need, allowing you define a Dockerfile under `app/docker` (or `spec/docker` for testing purposes), and automagically bring it up and down within a `with_dockerfile 'my_dockerfile' do`-block

# Usage
## Rspec
Example:
```docker
# spec/dockerfiles/ftp_server/Dockerfile
FROM odiobill/vsftpd
RUN bash -c 'useradd test -p $1$2f712aa7$bP1dXBeOEUoeTdnUeNLGQ/'
```
Then, to run it alongside your Rspec tests, simply do:
```ruby
before do
  with_dockerfile 'ftp_server', port_mapping: { ftp: 21 } do |ftp_server|
    puts ftp_server.ports.ftp # => '21'
    puts ftp_server.ip # => '10.5.2.100'
    puts ftp_server.bash 'cat /etc/hosts' # => '127.0.0.1	localhost
                                          #     ...'
  end
end
end
```
