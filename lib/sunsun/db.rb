require 'sequel'

module Sunsun
  private

  #
  # Sunsun::DB         # => "db/development.sqlite3"
  #
  # ENV['SUNSUN_ENV'] = 'production'
  # Sunsun::DB         # => "db/production.sqlite3"
  #
  def self.db_schema
    env = ENV['SUNSUN_ENV'] || "development"
    "sqlite://db/#{env}.sqlite3"
  end

  public

  DB = Sequel.connect(db_schema)
end
