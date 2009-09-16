# -*- coding: utf-8 -*-

require 'decision_node'
#require 'SimpleJsonParser'

class Array
 def sum_i
    num = 0
    
    self.each do |d|
      num += d
    end
      
    return num
  end
end

class TreePredict

  def initialize
    @consequence = nil # 帰結項目
    @excludes = Array.new # 除外項目
  end

  def set_consequence(key)
    @consequence = key
  end

  def exclude(key)
    if key.class == Array
      @excludes.concat(key)
    else
      @excludes << key
    end
  end

  # 指定した項目に基づいて集合を分割する
  # params
  #   _rows_  データ集合(Hash Array)
  #   _key_   分割時に参考にする項目
  #   _value_ 分割時に比較する値
  # return 
  #   *set1* _key_ に対する値と _value_ の比較結果が真の集合
  #   *set2* _key_ に対する値と _value_ の比較結果が偽の集合
  def divide_set(rows, key, value)
    set1 = []
    set2 = []

    if value.class == String
      split_func = lambda { |row|
        if row[key].nil?
          false
        else
          row[key] == value
        end
      }
    else
      split_func = lambda { |row|
        if row[key].nil? || value.nil?
          false
        else
          row[key] >= value
        end
      }
    end

    rows.each do |row|
      if split_func.call(row)
        set1 << row
      else
        set2 << row
      end
    end

    return [set1, set2]
  end

  # 帰結項目の集計
  def unique_counts(rows)
    results = Hash.new
    results.default = 0

    rows.each do |row|
      r = row[@consequence]
      results[r] += 1
    end

    results
  end

  # ジニ不純度を求める
  def calc_gini_impurity(rows)
    total = rows.size
    counts = unique_counts(rows)
    imp = 0

    counts.keys.each do |k1|
      p1 = counts[k1].to_f / total
      counts.keys.each do |k2|
        next if k1 == k2
        p2 = counts[k2].to_f / total
        imp += p1*p2
      end
    end

    return imp
  end

  # エントロピーを求める
  def calc_entropy(rows)
    total = rows.size
    counts = unique_counts(rows)
    ent = 0.0

    counts.keys.each do |k|
      p = counts[k].to_f / total
      ent = ent - p*log2(p)
    end

    return ent
  end

  def hoge(rows)
    #
  end

  def score_f(key)
    case key
    when :giniimp
      lambda { |r| calc_gini_impurity(r) }
    else
      lambda { |r| calc_entropy(r) }
    end
  end

  # 決定木の生成
  def build_tree(rows, score_func_key = :entropy)
    return DecisionNode.new if rows.size == 0
    
    score_func = score_f(score_func_key)
    current_score = score_func.call(rows)

    best_gain = 0.0
    best_criteria = nil
    best_sets = nil

    # 帰結項目、除外項目は計算しない
    columns = rows[0].keys
    columns.delete(@consequence)

    @excludes.each do |e|
      columns.delete(e)
    end
    

    columns.each do |col|
      column_values = Hash.new

      rows.each do |row|
        column_values[row[col]] = 1
      end

      column_values.keys.each do |value|
        sets = divide_set(rows, col, value)
        set1 = sets[0]
        set2 = sets[1]

        p = set1.size.to_f / rows.size
        gain = current_score - p*score_func.call(set1) - (1-p)*score_func.call(set2)

        if gain > best_gain && !set1.empty? && !set2.empty?
          best_gain = gain
          best_criteria = [col, value]
          best_sets = sets
        end
      end
    end

    if best_gain > 0
      true_branch = build_tree(best_sets[0])
      false_branch = build_tree(best_sets[1])
      return DecisionNode.new(:col => best_criteria[0],
                              :value => best_criteria[1],
                              :tb => true_branch, :fb => false_branch)
    else
      return DecisionNode.new(:results => unique_counts(rows))
    end
    
  end

  def self.print_tree(tree, indent = '  ')  
    if !tree.results.nil?
      puts tree.results.to_a.join('  ')
    else
      puts "#{tree.col}:#{tree.value}?"
      
      print "#{indent}T-> "
      print_tree(tree.tb, indent + '  ')
      print "#{indent}F-> "
      print_tree(tree.fb, indent + '  ')
    end
  end

  def classify(observ, tree)
    if !tree.results.nil?
      puts tree.results.to_a.join('  ')
    else
      v = observ[tree.col]
      branch = nil

      if v.class == String
        if v == tree.value
          branch = tree.tb
        else
          branch = tree.fb
        end
      else
        if v >= tree.value
          branch = tree.tb
        else
          branch = tree.fb
        end
      end

      classify(observ, branch)  
    end
  end

  def mdclassify(observ, tree)
    if !tree.results.nil?
      tree.results
    else
      v = observ[tree.col]
      if v.nil?
        tr = mdclassify(observ, tree.tb)
        fr = mdclassify(observ, tree.fb)
        tcount = tr.values.sum_i
        fcount = fr.values.sum_i
        tw = tcount.to_f / (tcount+fcount)
        fw = fcount.to_f / (tcount+fcount)

        result = {}

        tr.each {|k, v|
          next unless k
          result[k] = 0 if !result.include?(k)
          result[k] = v*tw
        }
        fr.each {|k, v|
          next unless k
          result[k] = 0 if !result.include?(k)
          result[k] = v*fw
        }

        return result
      else
        if v.class == String
          if v == tree.value
            branch = tree.tb
          else
            branch = tree.fb
          end
        else
          if v >= tree.value
            branch = tree.tb
          else
            branch = tree.fb
          end
        end

        mdclassify(observ, branch)  
      end
    end
  end


  private

  def log2(x)
    Math.log(x) / Math.log(2)
  end

end
