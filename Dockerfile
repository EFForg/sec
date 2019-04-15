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
  && echo "@edgecommunity http://nl.alpinelinux.org/alpine/edge/community" >>/etc/apk/repositories \
  && apk upgrade --update-cache \
  && apk add \
    build-base \
    postgresql-dev \
    postgresql-client \
    graphicsmagick \
    ghostscript \
    nodejs \
    yarn \

  # Use Bundler 2.
  && gem install bundler \

  # Set up crontab.
  && echo "*/15 * * * * su -s/bin/sh www-data -c \
    'cd /opt/trainers-hub && bundle exec rake blog:update' >>/proc/1/fd/1 2>&1" >>/etc/crontabs/root \

  && echo "*/15 * * * * root su -s/bin/sh www-data -c \
    'cd /opt/trainers-hub && bundle exec rake glossary:update' >>/proc/1/fd/1 2>&1" >>/etc/crontab

ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/

COPY Gemfile* ./
COPY ./vendor/active_material ./vendor/active_material
RUN bundle install

COPY package.json ./
COPY yarn.lock ./
RUN yarn install

COPY . .

RUN cp ./app/assets/fonts/* /usr/share/fonts

RUN if [ "$BUILD_ENV" = "production" ]; \
  then bundle exec rake assets:precompile \
  RAILS_ENV=production \
  SECRET_KEY_BASE=noop \
  DATABASE_URL=postgres://noop; fi

RUN mkdir -p /var/www /opt/trainers-hub/files \
  && chown -R www-data /opt/trainers-hub/public \
                       /opt/trainers-hub/files \
                       /opt/trainers-hub/tmp \
                       /var/www \
                       /usr/local/bundle
USER www-data

CMD ["rails", "s", "-b", "0.0.0.0"]
ENTRYPOINT ["/opt/trainers-hub/entrypoint.sh"]
