# -*- coding: utf-8 -*-

Fabricator(:menus_chain) do
  menu {
    if Menu.count > 0 and [true, false].sample
      Menu.all.sample
    else
      Fabricate(:menu)
    end
  }
  next_menu {
    if Menu.count > 0 and [true, false].sample
      Menu.all.sample
    else
      Fabricate(:menu)
    end
  }
end
