# Security Education Companion [![build Status](https://travis-ci.org/EFForg/sec.svg?branch=master)](https://travis-ci.org/EFForg/sec)

## Development with Docker

    $ cp .env.example .env
    $ cp docker-compose.yml.example docker-compose.yml
    $ docker-compose up --build -d
    $ docker-compose exec app rake db:setup

After running `rake db:setup` you can navigate to `http://localhost:3000/admin` and log in using:

- **User**: admin@example.com
- **Password**: password

## Development without Docker

* Install Ruby, Rails, and other gems the usual way.
* [install Yarn](https://yarnpkg.com/lang/en/docs/install/) and run `yarn install` to install Javascript dependencies.
