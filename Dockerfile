FROM ruby:2.5-alpine

RUN mkdir -p /opt/trainers-hub
WORKDIR /opt/trainers-hub

ARG BUILD_ENV=production

RUN if [ "$BUILD_ENV" = "development" ]; then \
      adduser -Du 1000 -h /opt/trainers-hub www-data; \
    else \
      adduser -DS -h /opt/trainers-hub www-data; \
    fi

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >>/etc/apk/repositories \
  && echo "@edgetesting http://nl.alpinelinux.org/alpine/edge/testing" >>/etc/apk/repositories \
  && apk upgrade --update-cache \
  && apk add \
    build-base \
    git \
    postgresql-dev \
    postgresql-client \
    imagemagick \
    ghostscript \
    xvfb \
    wkhtmltopdf@edgetesting \
    nodejs \
    yarn \

    # Needed for wkhtmltopdf
    dbus \

    # Needed for capybara-webkit
    qt-dev@edge \

  # Set up crontab.
  && echo "*/15 * * * * su -s/bin/sh www-data -c \
    'cd /opt/trainers-hub && bundle exec rake blog:update' >>/proc/1/fd/1 2>&1" >>/etc/crontabs/root

ENV DISPLAY=:99

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

RUN mkdir -p /var/www /opt/trainers-hub/files \
  && touch /opt/trainers-hub/flipper.pstore \
  && chown -R www-data /opt/trainers-hub/public \
                       /opt/trainers-hub/files \
                       /opt/trainers-hub/tmp \
                       /opt/trainers-hub/flipper.pstore \
                       /var/www \
                       /usr/local/bundle
USER www-data

CMD ["rails", "s", "-b", "0.0.0.0"]
ENTRYPOINT ["/opt/trainers-hub/entrypoint.sh"]
