# -*- coding: utf-8 -*-
# require 'simplecov'
# SimpleCov.start do
#   add_filter "/test/"
#   add_filter "/vendor/"
# end

ENV['SUNSUN_ENV'] ||= 'test'

require 'test/unit'
require 'sequel'
require 'sequel/extensions/migration'
require 'active_support/core_ext/array/extract_options'
require 'fabrication'
require 'sunsun_forecast'

Sequel::Migrator.apply(SunsunForecast::DB, "db/migrate", 0)
Sequel::Migrator.apply(SunsunForecast::DB, "db/migrate")

class Test::Unit::TestCase
  def run(*args, &block)
    Sequel::Model.db.transaction(:rollback => :always) { super }
  end
end

%w(カレー ラーメン 和食 洋食 中華).each do |gname|
  SunsunForecast::DB[:genres].insert :name => gname
end
