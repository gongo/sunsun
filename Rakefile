#!/usr/bin/env rake
require "bundler/gem_tasks"

namespace :db do
  require_relative 'lib/sunsun/db.rb'
  require 'sequel/extensions/migration'

  desc "Run database migrations"
  task :migrate do
    Sequel::Migrator.apply(Sunsun::DB, 'db/migrate')
  end

  desc "Rollback the database"
  task :rollback do
    version = (row = Sunsun::DB[:schema_info].first) ? row[:version] : nil
    Sequel::Migrator.apply(Sunsun::DB, "db/migrate", version - 1)
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
    require_relative 'lib/sunsun'
    require 'pry'
    Pry.start
  end
end

#task :default => ''
