FROM ruby:2.3-slim

RUN mkdir /opt/trainers-hub
WORKDIR /opt/trainers-hub

ARG BUILD_ENV=production

RUN if [ "$BUILD_ENV" = "development" ]; then usermod -u 1000 www-data; fi

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libpq-dev \
    postgresql-client \
    imagemagick \
    ghostscript \
    xvfb \
    wkhtmltopdf \
  # xvfb-run "needs" xauth but not really.
  && ln -s /bin/true /bin/xauth \
  # Install node.
  && set -x; \
    curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh \
    && chmod +x nodesource_setup.sh \
    && ./nodesource_setup.sh \
    && apt-get install -y --no-install-recommends \
      nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD Gemfile* ./

RUN bundle install

COPY . .

RUN if [ "$BUILD_ENV" = "production" ]; \
  then bundle exec rake assets:precompile \
  RAILS_ENV=production \
  SECRET_KEY_BASE=noop \
  DATABASE_URL=postgres://noop; fi

RUN mkdir -p /var/www && chown -R www-data /opt/trainers-hub/public \
                                           /opt/trainers-hub/tmp \
                                           /opt/trainers-hub/flipper.pstore \
                                           /var/www \
                                           /usr/local/bundle
USER www-data

CMD ["rails", "s", "-b", "0.0.0.0"]
ENTRYPOINT ["/opt/trainers-hub/entrypoint.sh"]
