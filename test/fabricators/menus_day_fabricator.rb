# -*- coding: utf-8 -*-
require 'active_support/core_ext/date/calculations'

Fabricator(:menus_day) do
  menu {
    if Menu.count > 0 and [true, false].sample
      Menu.all.sample
    else
      Fabricate(:menu)
    end
  }
  date { Date.today }
end

Fabricator(:md_sun, from: :menus_day) do
  date { Date.today.next_week :sunday }
end

Fabricator(:md_mon, from: :menus_day) do
  date { Date.today.next_week :monday }
end

Fabricator(:md_tue, from: :menus_day) do
  date { Date.today.next_week :tuesday }
end

Fabricator(:md_wed, from: :menus_day) do
  date { Date.today.next_week :wednesday }
end

Fabricator(:md_thu, from: :menus_day) do
  date { Date.today.next_week :thursday }
end

Fabricator(:md_fri, from: :menus_day) do
  date { Date.today.next_week :friday }
end

Fabricator(:md_sat, from: :menus_day) do
  date { Date.today.next_week :saturday }
end

