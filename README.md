# Trainers Hub

## Development with docker

    $ cp .env.example .env
    $ cp docker-compose.yml.example docker-compose.yml
    $ docker-compose up --build -d
    $ docker-compose exec app rake db:setup
