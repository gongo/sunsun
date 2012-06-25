#!/usr/bin/env rake
require "bundler/gem_tasks"

namespace :db do
  require_relative 'lib/sunsun_forecast/db.rb'
  require 'sequel/extensions/migration'

  desc "Run database migrations"
  task :migrate do
    Sequel::Migrator.apply(SunsunForecast::DB, 'db/migrate')
  end

  desc "Rollback the database"
  task :rollback do
    version = (row = SunsunForecast::DB[:schema_info].first) ? row[:version] : nil
    Sequel::Migrator.apply(SunsunForecast::DB, "db/migrate", version - 1)
  end
end

require 'rake/testtask'
desc "Run test all"
Rake::TestTask.new do |t|
  t.libs << 'test'
end

namespace :test do
  require 'active_support/core_ext/array/extract_options'
  require 'fabrication'

  desc "Start console"
  task :console do
    ENV['SUNSUN_ENV'] = 'test'
    require_relative 'lib/sunsun_forecast'
    require 'pry'
    Pry.start
  end
end

#task :default => ''
