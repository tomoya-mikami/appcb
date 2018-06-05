#!/bin/sh
export RAILS_ENV=production
export SECRET_KEY_BASE=bundle exec rake secret
bundle exec rails db:create RAILS_ENV=production