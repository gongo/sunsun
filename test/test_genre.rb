# -*- coding: utf-8 -*-
require 'helper'

class GenreTest < Test::Unit::TestCase
  def test_chain_ranking
    menu1 = Fabricate(:menu_curry)
    menu2 = Fabricate(:menu_curry)
    menu3 = Fabricate(:menu_japanese)
    menu4 = Fabricate(:menu_china)

    # | current genre | next genre (Probability)                 |
    # |---------------+------------------------------------------|
    # | curry         | curry (40%), china (40%), japanese (20%) |
    # | japanese      | 'none'                                   |
    # | china         | curry (67%), japanese (33%)              |
    [menu2, menu3, menu4].each do |m| ; menu1.chain m ; end
    [menu2, menu4].each        do |m| ; menu2.chain m ; end
    [menu1, menu2, menu3].each do |m| ; menu4.chain m ; end

    # curry
    ranking = menu1.genre.chain_ranking
    assert_equal [0.4, 0.4, 0.2], ranking.map(&:probability)

    # japanese
    assert_equal 0, menu3.genre.chain_ranking.count

    # china
    ranking = menu4.genre.chain_ranking
    assert_equal [0.67, 0.33], ranking.map(&:probability)
    assert_equal [menu1.genre_id, menu3.genre_id], ranking.map(&:genre_id)
  end

  def test_chain_ranking_chart
    menu1 = Fabricate(:menu_curry)
    menu2 = Fabricate(:menu_curry)
    menu3 = Fabricate(:menu_japanese)
    menu4 = Fabricate(:menu_china)

    # china => curry (67%), japanese (33%)
    [menu1, menu2, menu3].each do |m| ; menu4.chain m ; end

    curry = menu1.genre.name
    japanese = menu3.genre.name

    ranking = menu4.genre.chain_ranking_chart
    assert_equal [[curry, 67], [japanese, 33]], ranking

    ranking = menu4.genre.chain_ranking_chart :threshold => 40
    assert_equal [[curry, 67], ["その他", 33]], ranking

    ranking = menu4.genre.chain_ranking_chart :threshold => 40, :othername => 'other'
    assert_equal [[curry, 67], ["other", 33]], ranking
  end

  def test_encounter
    curry    = Fabricate(:menu_curry)
    japanese = Fabricate(:menu_japanese)
    china    = Fabricate(:menu_china)

    [ :md_sun, :md_sun, :md_sun, # sun : 3/7 => 43%
      :md_mon,                   # mon : 1/7 => 14%
      :md_wed, :md_wed,          # web : 2/7 => 29%
      :md_fri,                   # fri : 1/7 => 14%
    ].each do |d|
      Fabricate(d, :menu => curry)
    end

    [:md_tue, :md_tue, :md_tue].each do |d| # tue : 3/3 => 100%
      Fabricate(d, :menu => japanese)
    end

    days = curry.genre.encounter
    assert_equal [0.43, 0.29, 0.14, 0.14], days.map(&:probability)

    days = japanese.genre.encounter
    assert_equal [1.0], days.map(&:probability)

    days = china.genre.encounter
    assert_equal [], days.map(&:probability)
  end

  def test_encounter_all
    curry    = Fabricate(:menu_curry)
    japanese = Fabricate(:menu_japanese)
    china    = Fabricate(:menu_china)

    [ :md_sun, :md_sun, :md_sun,
      :md_mon,
      :md_wed, :md_wed,
      :md_fri,
    ].each do |d|
      Fabricate(d, :menu => curry)
    end

    [:md_tue, :md_tue, :md_tue].each do |d|
      Fabricate(d, :menu => japanese)
    end

    days = curry.genre.encounter_all
    assert_equal [0.43, 0.14, 0.0, 0.29, 0.0, 0.14, 0.0], days.map(&:probability)

    days = japanese.genre.encounter_all
    assert_equal [0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0], days.map(&:probability)

    days = china.genre.encounter_all
    assert_equal [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], days.map(&:probability)
  end
end
