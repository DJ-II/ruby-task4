#!/usr/bin/env bash
set -e
bundle install
bundle exec rails assets:precompile
bundle exec rails db:migrate
if [ "${IMPORT_USERS:-0}" = "1" ]; then
  bundle exec rails db:seed
fi
