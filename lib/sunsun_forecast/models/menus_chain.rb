# -*- coding: utf-8 -*-
require 'sequel'

class MenusChain < Sequel::Model
  many_to_one :menu
  many_to_one :next_menu, :class => :Menu

  include Ranking

  many_to_one :genre

  #
  # 指定されたメニューの次に登録されているメニューを
  # その出現回数、出現頻度(0..1) と共に返す
  #
  # @example
  #
  #   | menu_id | next_menu_id |
  #   |---------+--------------|
  #   |       1 |            2 |
  #   |       1 |            2 |
  #   |       1 |            3 |
  #   |       1 |            4 |
  #
  #   MenusChain.ranking(1)
  #   #=> [ #<MenusChain menu_id=2, frequency=2, probability=0.5> ,
  #         #<MenusChain menu_id=3, frequency=1, probability=0.25> ,
  #         #<MenusChain menu_id=4, frequency=1, probability=0.25> ]
  #
  # @param [int] menu_id
  #
  def self.menu_ranking(menu_id)
    count = filter(:menu_id => menu_id).count.to_f

    with_sql(<<-EOS).all
      SELECT
          next_menu_id AS menu_id
        , count(*) AS frequency
        , round(count(*) / #{count}, 2) AS probability
      FROM
        #{table_name}
      WHERE
        menu_id = #{menu_id}
      GROUP BY
        next_menu_id
      ORDER BY
        frequency DESC
    EOS
  end

  #
  # 指定されたジャンルの次に登録されているジャンルを
  # その出現回数、出現頻度(0..1) と共に返す
  #
  # @example
  #
  #   MenusChain.ranking(Genre.find(:name => 'カレー').id)
  #   #=> [ #<MenusChain genre_id=2, frequency=2, probability=0.5> ,
  #         #<MenusChain genre_id=3, frequency=1, probability=0.25> ,
  #         #<MenusChain genre_id=4, frequency=1, probability=0.25> ]
  #
  # @param [int] genre_id
  #
  def self.genre_ranking(genre_id)
    count = with_sql(<<-EOS).count.to_f
      SELECT
        *
      FROM
        #{table_name} AS mc
        LEFT OUTER JOIN menus AS m ON m.id = mc.menu_id
      WHERE
        m.genre_id = #{genre_id}
    EOS

    with_sql(<<-EOS).all
      SELECT
          m2.genre_id AS genre_id
        , count(*) AS frequency
        , round(count(*) / #{count}, 2) AS probability
      FROM
        #{table_name} AS mc
        LEFT OUTER JOIN menus AS m1 ON m1.id = mc.menu_id
        LEFT OUTER JOIN menus AS m2 ON m2.id = mc.next_menu_id
      WHERE
        m1.genre_id = #{genre_id}
      GROUP BY
        m2.genre_id
      ORDER BY
        frequency DESC
    EOS
  end
end
