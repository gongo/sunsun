# -*- coding: utf-8 -*-
require 'helper'
require 'active_support/core_ext/date/calculations'

class MenusDayTest < Test::Unit::TestCase
  def test_menu_ranking
    menu1 = Fabricate(:menu)
    menu2 = Fabricate(:menu)
    menu3 = Fabricate(:menu)
    # 日曜日に出たメニュー
    #   menu2(67%), menu1(33%)
    # 月曜日に出たメニュー
    #   menu1, menu2, menu3(33%)
    # 火曜日に出たメニュー
    #   menu1, menu3 (50%)
    # 水曜日に出たメニュー
    #   menu2 (100%)
    # 木曜日に出たメニュー
    #   なし
    menu1.register(Date.today.next_week :sunday)
    menu1.register(Date.today.next_week :monday)
    menu1.register(Date.today.next_week :tuesday)
    menu2.register(Date.today.next_week :sunday)
    menu2.register(Date.today.next_week :wednesday)
    menu2.register(Date.today.next_week :sunday)
    menu2.register(Date.today.next_week :monday)
    menu3.register(Date.today.next_week :monday)
    menu3.register(Date.today.next_week :tuesday)

    ranking = MenusDay.menu_ranking :sunday
    assert_equal [0.67, 0.33], ranking.map(&:probability)
    assert_equal menu2.id, ranking[0].menu_id
    assert_equal menu1.id, ranking[1].menu_id

    ranking = MenusDay.menu_ranking :monday
    assert_equal [0.33, 0.33, 0.33], ranking.map(&:probability)

    ranking = MenusDay.menu_ranking :tuesday
    assert_equal [0.5, 0.5], ranking.map(&:probability)
    assert_equal menu1.id, ranking[0].menu_id
    assert_equal menu3.id, ranking[1].menu_id

    ranking = MenusDay.menu_ranking :wednesday
    assert_equal [1.0], ranking.map(&:probability)
    assert_equal menu2.id, ranking[0].menu_id

    assert_equal 0, MenusDay.menu_ranking(:thursday).count
  end

  def test_genre_ranking
    menu1 = Fabricate(:menu_curry)
    menu2 = Fabricate(:menu_curry)
    menu3 = Fabricate(:menu_japanese)
    menu4 = Fabricate(:menu_china)
    # 日曜日に出たジャンル
    #   curry (100%)
    # 月曜日に出たジャンル
    #   curry (67%), japanese(33%)
    # 火曜日に出たジャンル
    #   curry, japanese, china (33%)
    # 水曜日に出たジャンル
    #   なし
    menu1.register(Date.today.next_week :sunday)
    menu1.register(Date.today.next_week :monday)
    menu1.register(Date.today.next_week :tuesday)
    menu2.register(Date.today.next_week :sunday)
    menu2.register(Date.today.next_week :sunday)
    menu2.register(Date.today.next_week :monday)
    menu3.register(Date.today.next_week :monday)
    menu3.register(Date.today.next_week :tuesday)
    menu4.register(Date.today.next_week :tuesday)

    ranking = MenusDay.genre_ranking :sunday
    assert_equal [1.0], ranking.map(&:probability)
    assert_equal menu1.genre_id, ranking[0].genre_id

    ranking = MenusDay.genre_ranking :monday
    assert_equal [0.67, 0.33], ranking.map(&:probability)
    assert_equal menu1.genre_id, ranking[0].genre_id
    assert_equal menu3.genre_id, ranking[1].genre_id

    ranking = MenusDay.genre_ranking :tuesday
    assert_equal [0.33, 0.33, 0.33], ranking.map(&:probability)

    assert_equal 0, MenusDay.genre_ranking(:wednesday).count
  end

  def test_genre_ranking_chart
    menu1 = Fabricate(:menu_curry)
    menu2 = Fabricate(:menu_curry)
    menu3 = Fabricate(:menu_japanese)
    # 月曜日に出たジャンル
    #   curry (67%), japanese(33%)
    menu1.register(Date.today.next_week :monday)
    menu2.register(Date.today.next_week :monday)
    menu3.register(Date.today.next_week :monday)

    curry = menu1.genre.name
    japanese = menu3.genre.name

    ranking = MenusDay.genre_ranking_chart :monday
    assert_equal [[curry, 67], [japanese, 33]], ranking

    ranking = MenusDay.genre_ranking_chart :monday, :threshold => 40
    assert_equal [[curry, 67], ["その他", 33]], ranking

    ranking = MenusDay.genre_ranking_chart :monday, :threshold => 40, :othername => 'other'
    assert_equal [[curry, 67], ["other", 33]], ranking
  end
end
