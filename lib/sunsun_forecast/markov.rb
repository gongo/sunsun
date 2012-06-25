# -*- coding: utf-8 -*-
module SunsunForecast
  class Markov
    #
    # 
    #
    def calculation(options = {})
      opts = {
        :day      => SunsunForecast::DAYS_INTO_WEEK.key(Date.today.wday),
        :genre_id => nil,
        :menu_id  => nil,
      }.merge(options)

      if opts[:day]
        puts "-- #{opts[:day]} に出てきたジャンルとその確率 -------"
        MenusDay.genre_ranking(opts[:day]).each do |md|
          puts Genre.find(:id => md.genre_id).name.to_s + " " + md.probability.to_s if md.probability > 0.009
        end
      end

      if opts[:genre_id]
        puts "-- #{Genre.find(:id => opts[:genre_id]).name} の翌日に出てきたジャンルとその確率-------"
        Genre.find(:id => opts[:genre_id]).chain_ranking.each do |mc|
          puts Genre.find(:id => mc.genre_id).name.to_s + " " + mc.probability.to_s
        end
      end

      if opts[:menu_id]
        puts "-- #{Menu.find(:id => opts[:menu_id]).name} の翌日に出てきたメニューとその確率-------"
        Menu.find(:id => opts[:menu_id]).chain_ranking.each do |mc|
          puts Menu.find(:id => mc.menu_id).name.to_s + " " + mc.probability.to_s
        end
      end

      ''
    end
  end
end
