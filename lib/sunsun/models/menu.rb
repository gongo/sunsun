# -*- coding: utf-8 -*-
require 'sequel'

class Menu < Sequel::Model
  many_to_one :genre

  #
  # 自身が出た日付を登録する
  #
  # 前日にメニューが存在する場合、{Menu#chain} でつなげる
  #
  # @see Menu#chain
  # @param [Date] date メニューが出た日付
  #
  def register(date = Date.today)
    MenusDay.create(:menu_id => self.id, :date => date)

    MenusDay.filter(:date => date - 1).each do |yesterday|
      yesterday.menu.chain(self)
    end
  end

  #
  # 自身の次に出たメニューを登録する
  #
  # @param [Menu] next_menu
  #
  def chain(next_menu)
    MenusChain.create(:menu_id => self.id, :next_menu_id => next_menu.id)
  end

  #
  # 自身の次に出たことのあるメニューを、割合を含めて返す
  #
  # @example
  #   # menu1 の次にくるもの
  #   #   menu2 (50%), menu3 (25%), menu4 (25%)
  #   menu1.chain(menu2)
  #   menu1.chain(menu2)
  #   menu1.chain(menu3)
  #   menu1.chain(menu4)
  #
  #   menu1.chain_ranking
  #   #=> [ #<MenusChain menu_id=2, frequency=2, probability=0.5> ,
  #         #<MenusChain menu_id=3, frequency=1, probability=0.25> ,
  #         #<MenusChain menu_id=4, frequency=1, probability=0.25> ]
  #
  def chain_ranking
    MenusChain.menu_ranking self.id
  end
end
