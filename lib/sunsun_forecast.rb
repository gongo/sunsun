require 'sunsun_forecast/db'
require 'sunsun_forecast/version'
require 'sunsun_forecast/markov'

module SunsunForecast
  require 'sunsun_forecast/models/ranking'
  require 'sunsun_forecast/models/genre'
  require 'sunsun_forecast/models/menu'
  require 'sunsun_forecast/models/menus_chain'
  require 'sunsun_forecast/models/menus_day'

  DAYS_INTO_WEEK = {
    :sunday   => 0, :monday => 1, :tuesday  => 2, :wednesday => 3,
    :thursday => 4, :friday => 5, :saturday => 6
  }
end
