**NOTE: The current code is quite buggy and definitely not production-ready. In its current state, it's only suitable for testing (which I built it for originally)**

# Sidedock
Sidedock simplifies working with Docker by allowing you to include a Dockerfile in your Rails app and run it *on the side* when your `rails server` spawns, abstracting away everything Docker requires you to do in between.

## The problem
Docker is supposed to make it easy to, I quote, *Build, Ship, and Run Any App, Anywhere*. While it may live up to this promise in big enterprises who have lots of manpower, in small teams using Docker can be quite problematic because:

- In a microservices set-up, when one of your services is updated, often so does your Rails app.
- You have to think of a build system, when are images built, pushed and deployed?
- How to ensure Docker is up when your Rails app is, when your server reboots or a new version of your Rails app is deploying

Docker's concepts (images and containers) are designed for big, distributed set-ups, and not for small companies whose main priority is getting a bigger user base.

## The solution
Sidedock assumes the server you run Rails on is powerful enough to also run the Docker services you need, allowing you define a Dockerfile under `app/docker` (or `spec/docker` for testing purposes)

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
