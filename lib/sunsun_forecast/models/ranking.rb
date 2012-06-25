module Ranking
  attr_reader :frequency, :probability, :menu_id, :genre_id

  def menu_id
    self[:menu_id]
  end

  def probability
    self[:probability]
  end

  def frequency
    self[:frequency]
  end

  def genre_id
    self[:genre_id]
  end
end
