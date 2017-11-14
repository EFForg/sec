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
    cron \
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
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  # Install yarn.
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" \
    | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y --no-install-recommends yarn \
  # Set up crontab.
  && echo "*/15 * * * * root su -s/bin/bash www-data -c \
    'cd /opt/trainers-hub && bundle exec rake blog:update' >>/proc/1/fd/1 2>&1" >>/etc/crontab


COPY Gemfile* ./
RUN bundle install

COPY package.json ./
COPY yarn.lock ./
RUN yarn install

COPY . .

RUN if [ "$BUILD_ENV" = "production" ]; \
  then bundle exec rake assets:precompile \
  RAILS_ENV=production \
  SECRET_KEY_BASE=noop \
  DATABASE_URL=postgres://noop; fi

RUN mkdir -p /var/www && touch /opt/trainers-hub/flipper.pstore \
                      && chown -R www-data /opt/trainers-hub/public \
                                           /opt/trainers-hub/tmp \
                                           /opt/trainers-hub/flipper.pstore \
                                           /var/www \
                                           /usr/local/bundle
USER www-data

CMD ["rails", "s", "-b", "0.0.0.0"]
ENTRYPOINT ["/opt/trainers-hub/entrypoint.sh"]
