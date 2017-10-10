# trainers-hub [![Build Status](https://travis-ci.org/EFForg/trainers-hub.svg?branch=master)](https://travis-ci.org/EFForg/trainers-hub)

## Development with docker

    $ cp .env.example .env
    $ cp docker-compose.yml.example docker-compose.yml
    $ docker-compose up --build -d
    $ docker-compose exec app rake db:setup
