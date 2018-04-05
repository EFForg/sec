#!/bin/sh

# Install any missing gems without rebuilding
bundle install --quiet

# Run migrations, if desired
if [ "$DB_MIGRATE" = "true" ]; then
  bundle exec rake db:migrate
fi

if [ "$ROLE" = "web" -a "$RAILS_ENV" == "production" ]; then
    bundle exec rake static:generate
fi

rm -rf "/tmp/.X$DISPLAY-lock"
/usr/bin/Xvfb "$DISPLAY" -ac &

exec "$@"
