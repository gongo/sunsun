# Sunsun

[![Build Status](https://secure.travis-ci.org/gongo/sunsun.png?branch=master)](http://travis-ci.org/gongo/sunsun)


## Requirements

- Ruby 1.9.2+, 1.9.3+
- Rack ServerSinatra 1.3.2+
- ORM
    - Sequel
- Database
    - SQLite3

## Installation

Sunsun used bundler

    $ gem install bundler

Install required by Sunsun.

    $ bundle install --without development test

Create the database structure.

    $ bundle exec rake db:migrate                         # To "db/development.sqlite3"
    $ SUNSUN_ENV="production" bundle exec rake db:migrate # To "db/production.sqlite3"
    $ SUNSUN_ENV="test" bundle exec rake db:migrate       # To "db/test.sqlite3"

Load the [seed data](https://github.com/gongo/sunsun/wiki/Demo-Data). (Default: "development" environment)

    $ bundle exec rake db:seed

Running web server. (Default: "development" environment)

    $ bundle exec rackup config.ru -p 8080        # Use Webrick
    $ bundle exec unicorn -c unicorn.conf -p 8080 # Use Unicorn

[http://localhost:8080](http://localhost:8080), You should now see Sunsun WebPage.


