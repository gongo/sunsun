# -*- coding: utf-8 -*-
require 'sequel'
require 'sunsun'

%w(ごはんもの パスタ・グラタン 麺 野菜のおかず お肉のおかず 魚介のおかず たまご・大豆加工品 サラダ シチュー・スープ・汁物 パン お菓子).each do |name|
  Genre.create(:name => name)
end

genre = Genre[1] # ごはんもの
["バターキーマカレー（鶏ひき肉・スパイス）",
  "簡単でおいしい☆ドライカレー",
  "ランチもがっつり！＊豚バラコロコロ丼＊",
  "きのこデミグラスソースオムライス",
  "べちゃつかないトロトロ卵のオムライス"].each do |name|
  Menu.create(:name => name, :genre => genre)
end

genre = Genre[2] # パスタ・グラタン
["豚キムチの★ピリ辛冷製パスタ",
  "ネギチャーシューパスタ"].each do |name|
  Menu.create(:name => name, :genre => genre)
end

genre = Genre[3] # 麺
["七夕そうめん",
  "カンタン！！手打ちうどん",
  "うまうま☆キャべ納豆そば",
  "さっぱりと♪ひじきとツナの蕎麦サラダ☆"].each do |name|
  Menu.create(:name => name, :genre => genre)
end

genre = Genre[4] # 野菜のおかず
["内緒のピーマンごはん♪",
  "農家のレシピ】ピーマンとちくわのきんぴら",
  "お家でつくる青椒肉絲",
  "菜の花のヨーグルト白和え"].each do |name|
  Menu.create(:name => name, :genre => genre)
end

genre = Genre[5] # お肉のおかず
["豚バラとかぼちゃのピリ辛炒め",
  "あと一品！豚バラのネギ巻き♫",
  "ビールに合う！鶏手羽中の唐揚げ"].each do |name|
  Menu.create(:name => name, :genre => genre)
end

genre = Genre[6] # 魚介のおかず
[
  "鯖のケチャップ焼き♡",
  "あっさり♪エビマヨ",
  "かまぼこのかば焼き"
].each do |name|
  Menu.create(:name => name, :genre => genre)
end

genre = Genre[7] # たまご・大豆加工品
[
  "厚揚げと茄子の味噌炒め",
  "納豆マーボー豆腐",
].each do |name|
  Menu.create(:name => name, :genre => genre)
end

genre = Genre[8] # サラダ
[
  "人参とうどのさわやかサラダ",
  "大根の梅サンド",
  "簡単シンプル大根サラダ",
].each do |name|
  Menu.create(:name => name, :genre => genre)
end

genre = Genre[9] # シチュー・スープ・汁物
[
  "ワンタンの皮スープ",
  "わかめと卵のスープ",
].each do |name|
  Menu.create(:name => name, :genre => genre)
end

genre = Genre[10] # パン
[
  "ふわふわとろりん❤いちじくのサンドイッチ",
  "美味！ハムと卵ときゅうりのホットサンド★",
].each do |name|
  Menu.create(:name => name, :genre => genre)
end

genre = Genre[11] # お菓子
[
  "ダイエット中のおやつ♪豆乳くず寒天",
  "いちごのムース",
  "ひんやりなめらか♪シューアイス",
].each do |name|
  Menu.create(:name => name, :genre => genre)
end

date = Date.today - 30

[Menu[10], Menu[17], Menu[29], Menu[28], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[13], Menu[7], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[19], Menu[6], Menu[20], Menu[22], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[4], Menu[28], Menu[11], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[28], Menu[17], Menu[16], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[14], Menu[20], Menu[27], Menu[11], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[6], Menu[27], Menu[22], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[7], Menu[11], Menu[1], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[24], Menu[21], Menu[2], Menu[7], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[16], Menu[2], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[20], Menu[9], Menu[33], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[8], Menu[7], Menu[12], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[8], Menu[6], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[25], Menu[13], Menu[24], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[26], Menu[14], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[30], Menu[20], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[11], Menu[2], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[30], Menu[15], Menu[3], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[30], Menu[18], Menu[16], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[9], Menu[30], Menu[6], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[20], Menu[26], Menu[28], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[25], Menu[23], Menu[22], Menu[1], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[30], Menu[10], Menu[26], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[25], Menu[15], Menu[32], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[21], Menu[13], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[20], Menu[28], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[15], Menu[31], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[31], Menu[25], Menu[16], Menu[13], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[16], Menu[17], ].each do |menu|
  menu.register date
end
date = date + 1

[Menu[13], Menu[21], Menu[22], Menu[25], ].each do |menu|
  menu.register date
end
date = date + 1


