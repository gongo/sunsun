# -*- coding: utf-8 -*-
require 'helper'
require 'active_support/core_ext/date/calculations'

class MenuTest < Test::Unit::TestCase
  def test_register
    Fabricate(:menu).register

    assert_equal Date.today, MenusDay.first.date
  end

  def test_register_with_date
    date = Date.today - 1
    Fabricate(:menu).register date

    assert_equal date.wday, MenusDay.first.day
  end

  def test_chain
    menu1 = Fabricate(:menu)
    menu2 = Fabricate(:menu)
    menu1.chain(menu2)

    assert_equal menu1.id, MenusChain.first.menu.id
    assert_equal menu2.id, MenusChain.first.next_menu.id
  end

  #
  # Menu#register の登録日前日にデータがあれば chain させるテスト
  #
  def test_register_cont_chain
    menu1 = Fabricate(:menu)
    menu2 = Fabricate(:menu)
    menu3 = Fabricate(:menu)

    menu1.register(Date.today - 1)
    menu2.register(Date.today - 2)
    menu3.register

    assert_equal 1, MenusChain.count
    assert_equal menu1.id, MenusChain.first.menu_id
    assert_equal menu3.id, MenusChain.first.next_menu_id
  end

  def test_chain_ranking
    menu1 = Fabricate(:menu)
    menu2 = Fabricate(:menu)
    menu3 = Fabricate(:menu)
    menu4 = Fabricate(:menu)

    # | current menu | next menu (Probability)               |
    # |--------------+---------------------------------------|
    # | menu1        | menu2 (50%), menu3 (25%), menu4 (25%) |
    # | menu2        | menu4 (100%)                          |
    # | menu3        | 'none'                                |
    # | menu4        | menu1 (67%), menu2 (33%)              |
    [menu2, menu2, menu3, menu4].each do |m| ; menu1.chain m ; end
    [menu4, menu4].each               do |m| ; menu2.chain m ; end
    [menu1, menu1, menu2].each        do |m| ; menu4.chain m ; end

    # menu1
    ranking = menu1.chain_ranking
    assert_equal [0.5, 0.25, 0.25], ranking.map(&:probability)

    # menu2
    ranking = menu2.chain_ranking
    assert_equal [1.0], ranking.map(&:probability)
    assert_equal menu4.id, ranking[0].menu_id

    # menu3
    assert_equal 0, menu3.chain_ranking.count

    # menu4
    ranking = menu4.chain_ranking
    assert_equal [0.67, 0.33], ranking.map(&:probability)
    assert_equal [menu1.id, menu2.id], ranking.map(&:menu_id)
  end
end
