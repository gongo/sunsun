# -*- coding: utf-8 -*-
require 'sequel'

class Genre < Sequel::Model
  one_to_many :menus

  #
  # 自身の次に出たことのあるジャンルを、割合を含めて返す
  #
  # @example
  #   # menu1(genre_id=0) の次にくるもの
  #   #   genre1 (50%), genre2,genre3 (25%)
  #   menu1.chain(menu2) # genre_id = 1
  #   menu1.chain(menu3) # genre_id = 2
  #   menu1.chain(menu4) # genre_id = 3
  #   menu1.chain(menu5) # genre_id = 1
  #
  #   menu1.chain_ranking
  #   #=> [ #<MenusChain genre_id=1, frequency=2, probability=0.5> ,
  #         #<MenusChain genre_id=2, frequency=1, probability=0.25> ,
  #         #<MenusChain genre_id=3, frequency=1, probability=0.25> ]
  #
  def chain_ranking
    MenusChain.genre_ranking self.id
  end

  #
  # 自身の次に出たことのあるジャンル名と出現確率(0..100 %(の組を返す
  #
  # オプションで指定した閾値以下は「その他」データとして取得することができる
  #
  # @example
  #
  #   menu1.chain_ranking_chart
  #   #=> [ ["ジャンル1", 50 ] ,
  #         ["ジャンル2", 25 ] ,
  #         ["ジャンル3", 25 ] ]
  #
  #   menu1.chain_ranking_chart(:threshold => 30)
  #   #=> [ ["ジャンル1", 50 ] ,
  #         ["その他", 50 ] ]
  #
  # @param [Hash] opts
  # @option opts [String] :othername ("その他") 閾値以下のグループ名
  # @option opts [Integer] :threshold (10) 閾値
  #
  def chain_ranking_chart(opts = {})
    opts = {
      :othername  => "その他",
      :threshold  => 10,
    }.merge(opts)

    ranking, other = MenusChain.genre_ranking(self.id).map { |c|
      [c.genre.name, (c.probability * 100).to_i]
    }.partition { |r| r[1].to_i > opts[:threshold] }

    unless other.empty?
      ranking.push [ opts[:othername], other.inject(0) { |sum, o|sum += o[1] } ]
    end

    ranking
  end

  #
  # 自身が登録されている曜日を
  # その出現回数、出現頻度(0..1) とともに、多い順に返す
  #
  # @example
  #
  #   Genre.first.encounter
  #   #=> [ #<MenusDay day=0, frequency=2, probability=0.5> ,
  #         #<MenusDay day=2. frequency=1, probability=0.25> ,
  #         #<MenusDay day=3, frequency=1, probability=0.25> ]
  #
  def encounter
    MenusDay.genre_encounter self.id
  end

  #
  # 自身が登録されている曜日を
  # その出現回数、出現頻度(0..1) とともに、曜日順に返す
  #
  # {Genre#encounter} と違い、出現しない曜日も含める
  #
  # @example
  #
  #   Genre.first.encounter_all
  #   #=> [ #<MenusDay day=0, frequency=2, probability=0.5> ,
  #         #<MenusDay day=1, frequency=0, probability=0.0> ,
  #         #<MenusDay day=2, frequency=1, probability=0.25> ,
  #         #<MenusDay day=3, frequency=1, probability=0.25> ,
  #         #<MenusDay day=4, frequency=0, probability=0.0> ,
  #         #<MenusDay day=5, frequency=0, probability=0.0> ,
  #         #<MenusDay day=6, frequency=0, probability=0.0> ]
  #
  def encounter_all
    encs = (0..6).map do |d|
      md = MenusDay.new :day => d
      md[:frequency] = 0
      md[:probability] = 0.0
      md
    end

    MenusDay.genre_encounter(self.id).each do |md|
      encs[md.day] = md
    end

    encs
  end

end

