# Security Education Companion [![build Status](https://travis-ci.org/EFForg/sec.svg?branch=master)](https://travis-ci.org/EFForg/trainers-hub)

## Development with docker

    $ cp .env.example .env
    $ cp docker-compose.yml.example docker-compose.yml
    $ docker-compose up --build -d
    $ docker-compose exec app rake db:setup

After running `rake db:setup` you can navigate to `http://localhost:3000/admin` and log in using:

- **User**: admin@example.com
- **Password**: password
