# -*- coding: utf-8 -*-
require 'sequel'

class MenusDay < Sequel::Model
  many_to_one :menu

  include Ranking

  many_to_one :genre

  #
  # 指定された曜日に登録されているメニューを
  # その出現回数、出現頻度(0..1) と共に返す
  #
  # @example
  #
  #   menus_days テーブル
  #   | menu_id | day |
  #   |---------+-----|
  #   |       1 |   1 |
  #   |       2 |   1 |
  #   |       3 |   1 |
  #   |       2 |   1 |
  #
  #   MenusDay.menu_ranking(:monday)
  #   #=> [ #<MenusDay menu_id=2, frequency=2, probability=0.5> ,
  #         #<MenusDay menu_id=1, frequency=1, probability=0.25> ,
  #         #<MenusDay menu_id=3, frequency=1, probability=0.25> ]
  #
  # @param [symbol] day_sym 曜日 (:sunday, :monday, :tuesday, :wednesday,:thursday, :friday, :saturday)
  #
  def self.menu_ranking(day_sym)
    day = SunsunForecast::DAYS_INTO_WEEK[day_sym.to_sym]
    count = filter(:day => day).count.to_f

    with_sql(<<-EOS).all
      SELECT
          menu_id
        , count(*) as frequency
        , round(count(*) / #{count}, 2) AS probability
      FROM
        #{table_name}
      WHERE
        day = #{day}
      GROUP BY
        menu_id
      ORDER BY
        frequency DESC
    EOS
  end

  #
  # 指定された曜日に登録されているジャンルを
  # その出現回数、出現頻度(0..1) と共に返す
  #
  # @example
  #
  #   MenusDay.genre_ranking(:monday)
  #   #=> [ #<MenusDay genre_id=2, frequency=2, probability=0.5> ,
  #         #<MenusDay genre_id=3, frequency=1, probability=0.25> ,
  #         #<MenusDay genre_id=4, frequency=1, probability=0.25> ]
  #
  # @param [symbol] day_sym 曜日 (:sunday, :monday, :tuesday, :wednesday,:thursday, :friday, :saturday)
  #
  def self.genre_ranking(day_sym)
    day = SunsunForecast::DAYS_INTO_WEEK[day_sym.to_sym]
    count = filter(:day => day).count.to_f

    with_sql(<<-EOS).all
      SELECT
          m.genre_id AS genre_id
        , COUNT(*) AS frequency
        , round(count(*) / #{count}, 2) AS probability
      FROM
        #{table_name} AS md
        LEFT OUTER JOIN menus AS m ON m.id = md.menu_id
      WHERE
        md.day = #{day}
      GROUP BY
        m.genre_id
      ORDER BY
        frequency DESC;
    EOS
  end

  #
  # 指定した曜日に登録されているジャンル名と出現確率(0..100 %)の組を返す
  #
  # オプションで指定した閾値以下は「その他」データとして取得することができる
  #
  # @example
  #
  #   MenusDay.genre_ranking_chart(:monday)
  #   #=> [ [ジャンル2, 50.0] ,
  #         [ジャンル3, 25.0] ,
  #         [ジャンル4, 25.0] ]
  #
  #   MenusDay.genre_ranking_chart(:monday, :threshold => 30)
  #   #=> [ ["ジャンル2", 50.0] ,
  #         ["その他", 50.0] ]
  #
  # @param [symbol] day_sym 曜日 (:sunday, :monday, :tuesday, :wednesday,:thursday, :friday, :saturday)
  # @param [Hash] opts
  # @option opts [String] :othername ("その他") 閾値以下のグループ名
  # @option opts [Integer] :threshold (10) 閾値
  #
  def self.genre_ranking_chart(day_sym, opts = {})
    opts = {
      :othername  => "その他",
      :threshold  => 10,
    }.merge(opts)

    ranking, other = genre_ranking(day_sym).map { |g|
      [g.genre.name, (g.probability * 100).to_i]
    }.partition { |r| r[1].to_i > opts[:threshold] }

    unless other.empty?
      ranking.push [ opts[:othername], other.inject(0) { |sum, o|sum += o[1] } ]
    end

    ranking
  end


  #
  # 指定されたジャンルが登録されている曜日を
  # その出現回数、出現頻度(0..1) とともに、多い順に返す
  #
  # @example
  #
  #   MenusDay.genre_encounter(genre_id)
  #   #=> [ #<MenusDay day=0, frequency=2, probability=0.5> ,
  #         #<MenusDay day=2, frequency=1, probability=0.25> ,
  #         #<MenusDay day=3, frequency=1, probability=0.25> ]
  #
  # @param [int] genre_id ジャンルID
  #
  def self.genre_encounter(genre_id)
    count = with_sql(<<-EOS, genre_id).count.to_f
      SELECT
        *
      FROM
        #{table_name} AS md
        LEFT OUTER JOIN menus AS m ON m.id = md.menu_id
      WHERE
        m.genre_id = ?
    EOS

    with_sql(<<-EOS, genre_id).all
      SELECT
          md.day
        , COUNT(*) AS frequency
        , round(count(*) / #{count}, 2) AS probability
      FROM
        #{table_name} AS md
        LEFT OUTER JOIN menus AS m ON m.id = md.menu_id
      WHERE
        m.genre_id = ?
      GROUP BY
        md.day
      ORDER BY
        frequency DESC, day;
    EOS
  end

  protected

  def before_create
    self.day = self.date.wday
    super
  end

  private

end
