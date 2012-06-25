# -*- coding: utf-8 -*-

Fabricator(:menu) do
  genre { Genre.all.sample }
  name { sequence(:menu, 1) { |i| "メニュー#{i}" } }

  #
  # build 時に選ばれた genre.name を付加する
  #
  # e.g.
  #   メニュー1_洋食
  #   メニュー2_カレー
  #   メニュー3_和食
  #
  after_build { |menu|
    menu.name += "_#{menu.genre.name}"
  }
end

#
# helper.rb のジャンルマスタを参照
#

Fabricator(:menu_curry, from: :menu) do
  genre { Genre.find(:name => "カレー") }
end

Fabricator(:menu_ramen, from: :menu) do
  genre { Genre.find(:name => "ラーメン") }
end

Fabricator(:menu_japanese, from: :menu) do
  genre { Genre.find(:name => "和食") }
end

Fabricator(:menu_western, from: :menu) do
  genre { Genre.find(:name => "洋食") }
end

Fabricator(:menu_china, from: :menu) do
  genre { Genre.find(:name => "中華") }
end
