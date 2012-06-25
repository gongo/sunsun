# -*- coding: utf-8 -*-
require 'csv'
require_relative '../sunsun_forecast'

CSV.foreach 'import.csv' do |row|
  genre = Genre.find_or_create(:name => row[2])
  menu = Menu.find(:name => row[1])

  if menu.nil?
    menu = Menu.new(:name => row[1])
    menu.genre = genre
  else
    warn "#{row[1]} に違うジャンルが割り振られています" if menu.genre.id != genre.id
  end

  menu.save
  menu.register Date.parse(row[0])
end

MenusDay.all.each_cons(2) { |mdays|
  prev_menu = mdays[0].menu
  next_menu = mdays[1].menu
  prev_menu.chain(next_menu) if mdays[0].date - 1 === mdays[1].date
}
