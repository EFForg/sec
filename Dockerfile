FROM ruby:2.3-slim

RUN mkdir /opt/trainers-hub
WORKDIR /opt/trainers-hub

RUN usermod -u 1000 www-data

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libpq-dev \
    postgresql-client \
    imagemagick \
    libmagickcore-dev \
    libmagickwand-dev \
    wkhtmltopdf

RUN set -x; \
  curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh \
  && chmod +x nodesource_setup.sh \
  && ./nodesource_setup.sh \
  && apt-get install -y --no-install-recommends \
    nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD Gemfile* ./

RUN bundle install

ADD bin/ ./bin
ADD config/ ./config
ADD config.ru ./
ADD Rakefile ./
ADD db/ ./db
ADD lib/ ./lib
ADD public/ ./public
ADD app/ ./app
ADD vendor/ ./vendor
ADD entrypoint.sh ./entrypoint.sh

RUN bundle exec rake assets:precompile \
  RAILS_ENV=production \
  SECRET_KEY_BASE=noop \
  DATABASE_URL=postgres://noop

RUN mkdir -p /var/www
RUN chown -R www-data /opt/trainers-hub /var/www /usr/local/bundle
USER www-data

CMD ["rails", "s", "-b", "0.0.0.0"]
ENTRYPOINT ["/opt/trainers-hub/entrypoint.sh"]
