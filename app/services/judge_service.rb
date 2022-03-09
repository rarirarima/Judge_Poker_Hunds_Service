module JudgeService
  # cards = "H3 H4 H5 H6 H7"
  def search_hands(cards)
    @suits = cards.scan(/[CDHS]/) # @suits=["H", "H", "H", "H", "H"]
    nums_str = cards.scan(/1[0-3]|[1-9]/)
    @nums_int = nums_str.map(&:to_i) # @nums_int=[3, 4, 5, 6, 7]
    decide_hands
  end

  def decide_hands
    if straight? && flush?
      ['ストレートフラッシュ', 8]
    elsif number_card?(4)
      ['フォー・オブ・ア・カインド', 7]
    elsif number_card?(3) && number_card?(2)
      ['フルハウス', 6]
    elsif flush?
      ['フラッシュ', 5]
    elsif straight?
      ['ストレート', 4]
    elsif number_card?(3)
      ['スリー・オブ・ア・カインド', 3]
    elsif two_pair?
      ['ツーペア', 2]
    elsif number_card?(2)
      ['ワンペア', 1]
    else
      ['ハイカード', 0]
    end
  end

  def straight?
    if (@nums_int.sort[4] - @nums_int.min) == 4 && all_unique?
      true
    elsif over_straight? && all_unique?
      true
    else
      false
    end
  end

  def over_straight?
    over_straight_arrays = [
      [1, 2, 3, 4, 13],
      [1, 2, 3, 12, 13],
      [1, 2, 11, 12, 13],
      [1, 10, 11, 12, 13]
    ]
    over_straight_arrays.each do |array|
      return true if array.all? { |i| @nums_int.include?(i) }
    end
    false
  end

  def all_unique?
    true if @nums_int.uniq.count == 5
  end

  def flush?
    true if @suits.uniq.count == 1
  end

  def number_card?(number)
    numeric_list = count_card_number
    numeric_list.each_value do |v|
      return true if v == number
    end
    false
  end

  def two_pair?
    numeric_list = count_card_number
    pair_count = 0
    numeric_list.each_value do |v|
      next unless v == 2

      pair_count += 1
      return true if pair_count == 2
    end
    false
  end

  def count_card_number
    numeric_list = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0, 9 => 0, 10 => 0, 11 => 0, 12 => 0,
                     13 => 0 }
    @nums_int.each do |num|
      numeric_list[num] += 1
    end
    numeric_list
  end

  module_function :search_hands, :decide_hands, :straight?, :over_straight?, :all_unique?, :flush?, :number_card?,
                  :two_pair?, :count_card_number
end
