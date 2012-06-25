require 'sunsun/db'
require 'sunsun/version'
require 'sunsun/markov'

module Sunsun
  require 'sunsun/models/ranking'
  require 'sunsun/models/genre'
  require 'sunsun/models/menu'
  require 'sunsun/models/menus_chain'
  require 'sunsun/models/menus_day'

  DAYS_INTO_WEEK = {
    :sunday   => 0, :monday => 1, :tuesday  => 2, :wednesday => 3,
    :thursday => 4, :friday => 5, :saturday => 6
  }
end
