#!/bin/sh
export RAILS_ENV=production
export RAILS_SERVER=`cat tmp/pids/server.pid`
kill $RAILS_SERVER
#git pull origin master
bundle install --without test development
bundle exec rails db:migrate RAILS_ENV=production
bundle exec rails assets:precompile RAILS_ENV=production
export SECRET_KEY_BASE=bundle exec rake secret
export RAILS_ENV=production
bundle exec rails s -d -e production -p 3000 -b 0.0.0.0