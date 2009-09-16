# -*- coding: utf-8 -*-
require 'tree_predict'
require 'MeCab'

#file = open('decision_tree_example.json')
#json_str = file.read
#obj = WebAPI::JsonParser.new.parse(json_str)
#data = obj["data"]

def gongo
end

def read_sunsun_csv(filename)
  data = []
  prev_data = []
  mecab = {}
  mecab.default = 0

  m = MeCab::Tagger.new
  
  open(filename) { |file|
    file.each do |row|
      arr = row.chomp.split(',')
      tmp = []

      d_tmp = { }
      d_tmp["date"] = arr[0]
      d_tmp["week"] = arr[1]

      (2...arr.size).each do |idx|
        next if arr[idx].nil?

        d = d_tmp.dup

        # 試しにカレーorカレー以外で分けて決定木を作る
        if /カレ/ =~ arr[idx]
          d["menu"] = "カレー"
        elsif /丼/ =~ arr[idx]
          d["menu"] = "丼"
        elsif /そば/ =~ arr[idx]
          d["menu"] = "そば"
        else
          d["menu"] = "それ以外"
        end
        tmp << d

        mcstr_arr = m.parse(d["menu"]).split("\n")
        mcstr_arr.each do |mcstr|
          next if mcstr == "EOS"
          
          mc = mcstr.split("\t")
          mc_main = mc[0]
          mc_info = mc[1]
          
          if mc_info =~ /名詞/ && (mc_info =~ /固有/ || mc_info =~ /一般/)
            mecab[mc_main] += 1
          end
        end
      end

      next if tmp.empty?

      tmp.each do |t|
        t1 = [t]*prev_data.size
        (0...prev_data.size).each do |pidx|
          t1[pidx]["prev"] = prev_data[pidx]["menu"]
          t1[pidx] = t1[pidx].dup
        end
        data.concat(t1)
      end

      prev_data = tmp
    end
  }

  res = mecab.to_a.sort {|a,b|
    (b[1] <=> a[1]) * 2 + (a[0] <=> b[0])
  }

#  data.each do |d|
#    res.each do |r|
#      if Regexp.new(Regexp.escape(r[0])) =~ d["menu"]
#        d["menu_abbr"] = r[0]
#        break
#      end
#    end
#
#    res.each do |r|
#      if Regexp.new(Regexp.escape(r[0])) =~ d["prev"]
#        d["prev_abbr"] = r[0]
#        break
#      end
#    end
#
#    #d["menu_abbr"] = d["menu"] unless d.include?("menu_abbr")
#    #d["prev_abbr"] = d["prev"] unless d.include?("prev_abbr")
#  end
#
  return data
end




data = read_sunsun_csv("SUNSUN.csv")

predict = TreePredict.new
predict.set_consequence("menu")
predict.exclude(["date"])

tree = predict.build_tree(data)
TreePredict.print_tree(tree)

#ob = {"week" => "火", "prev" => "丼"}
#ob = {"week" => "金", "prev" => "丼"}
#ob = {"prev" => "ミックスフライ" }
ob = {"week" => "水", "prev" => "それ以外"}

hoge = predict.mdclassify(ob, tree)

res = hoge.to_a.sort {|a,b|
  (b[1] <=> a[1]) * 2 + (a[0] <=> b[0])
}

puts res
