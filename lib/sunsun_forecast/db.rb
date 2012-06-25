require 'sequel'

module SunsunForecast
  private

  #
  # SunsunForecast.DB         # => "db/development.sqlite3"
  #
  # ENV['SUNSUN_ENV'] = 'production'
  # SunsunForecast.DB         # => "db/production.sqlite3"
  #
  def self.db_schema
    env = ENV['SUNSUN_ENV'] || "development"
    "sqlite://db/#{env}.sqlite3"
  end

  public

  DB = Sequel.connect(db_schema)
end
