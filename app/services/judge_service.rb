module JudgeService
  include ErrorService

  def search_hands(cards)
    @suits = cards.scan(/[CDHS]/) # @suits=["H", "H", "H", "H", "H"]
    @nums = cards.scan(/1[0-3]|[1-9]/).map(&:to_i) # @nums=[3, 4, 5, 6, 7]
    decide_hands
  end

  def decide_hands
    if straight_flush?
      { name: 'ストレートフラッシュ', strength: 8 } # {役, 強さを表す数値}
    elsif number_card?(4)
      { name: 'フォー・オブ・ア・カインド', strength: 7 }
    elsif fullhouse?
      { name: 'フルハウス', strength: 6 }
    elsif flush?
      { name: 'フラッシュ', strength: 5 }
    elsif straight?
      { name: 'ストレート', strength: 4 }
    elsif number_card?(3)
      { name: 'スリー・オブ・ア・カインド', strength: 3 }
    elsif two_pair?
      { name: 'ツーペア', strength: 2 }
    elsif number_card?(2)
      { name: 'ワンペア', strength: 1 }
    else
      { name: 'ハイカード', strength: 0 }
    end
  end

  def straight_flush?
    true if straight? && flush?
  end

  def four_of_a_kind?
    true if number_card?(4)
  end

  def fullhouse?
    true if number_card?(3) && number_card?(2)
  end

  def flush?
    true if @suits.uniq.count == 1
  end

  def straight?
    if (@nums.sort[4] - @nums.min) == 4 && nums_all_unique?
      true
    elsif royal_straight? && nums_all_unique?
      true
    else
      false
    end
  end

  def three_of_a_kind?
    true if number_card?(3)
  end

  def two_pair?
    true if count_card_num.count(2) == 2
  end

  def one_pair?
    true if number_card?(2)
  end

  def royal_straight?
    royal_straight_array = [1, 10, 11, 12, 13]
    return true if royal_straight_array.all? { |i| @nums.include?(i) }
  end

  def nums_all_unique?
    true if @nums.uniq.count == 5
  end

  def number_card?(number)
    count_card_num.each do |count|
      return true if count == number
    end
    false
  end

  def count_card_num
    num_list = Array.new(13, 0)
    @nums.each do |num|
      num_list[num - 1] += 1
    end
    num_list
  end

  module_function :search_hands, :decide_hands, :straight_flush?, :four_of_a_kind?, :fullhouse?, :flush?, :straight?,
                  :three_of_a_kind?, :two_pair?, :one_pair?, :royal_straight?, :nums_all_unique?, :number_card?,
                  :count_card_num
end
