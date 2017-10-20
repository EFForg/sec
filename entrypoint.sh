#!/bin/sh

# Install any missing gems without rebuilding
bundle install --quiet

exec "$@"
