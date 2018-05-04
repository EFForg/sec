# Security Education Companion [![build Status](https://travis-ci.org/EFForg/sec.svg?branch=master)](https://travis-ci.org/EFForg/sec)

## Development with Docker

    $ cp .env.example .env
    $ cp docker-compose.yml.example docker-compose.yml
    $ docker-compose up --build -d
    $ docker-compose exec app rake db:setup

After running `rake db:setup` you can navigate to `http://localhost:3000/admin` and log in using:

- **User**: admin@example.com
- **Password**: password

Running browser tests from within Docker is not currently supported. See [#477](https://github.com/EFForg/sec/pull/447) for more information.

## Development without Docker

* Install Ruby, Rails, and other gems the usual way.
* [install Yarn](https://yarnpkg.com/lang/en/docs/install/) and run `yarn install` to install Javascript dependencies.
* If you don't already have it, install or Chrome or Chromium for browser tests, eg `sudo apt install chromium-browser`.

## Local Testing
It is sometimes useful to test the production environment locally.  You
can do this by setting `DISABLE_SSL = true` in .env, and then using
RAILS_ENV=production:

    $ RAILS_ENV=production bundle exec rspec
    $ RAILS_ENV=production bundle exec rails c
    $ RAILS_ENV=production bundle exec rails s
