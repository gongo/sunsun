# -*- coding: utf-8 -*-
require 'sinatra'
require 'json'
require 'time'

get '/days' do
  erb :days
end

#
# 指定された曜日のジャンル出現ランキングを返す。
# 確率が3%以下のものは全て「その他」としてまとめる
#
get %r{/days/((?:sun|mon|tues|wednes|thurs|fri|sat)day)} do
  content_type :json
  MenusDay.plugin :json_serializer
  MenusDay.genre_ranking_chart(
    params[:captures].first.to_sym, :threshold => 3
  ).to_json
end

get '/genres' do
  @genres = Genre.order(:name).all
  erb :genres
end

#
# 指定されたジャンルが各曜日に出現する確率を返す
#
get '/genres/:id/encounter' do
  content_type :json
  MenusDay.plugin :json_serializer
  Genre.find(:id => params[:id]).encounter_all.map { |e|
    [Time::RFC2822_DAY_NAME[e.day], e.probability * 100]
  }.to_json
end

#
# 指定されたジャンルの次にくるジャンル出現ランキングを返す。
# 確率が3%以下のものは全て「その他」としてまとめる
#
get '/genres/:id/chain' do
  content_type :json
  MenusChain.plugin :json_serializer
  Genre.find(:id => params[:id]).chain_ranking_chart(:threshold => 3).map { |c|
    [c.last, c.first]
  }.to_json
end
