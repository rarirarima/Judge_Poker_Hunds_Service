module JudgeService

  def search_hands(cards) #@card = "H3 H4 H5 H6 H7"
      @suits = cards.scan(/[CDHS]/) #["H", "H", "H", "H", "H"]
      nums_str = cards.scan(/1[0-3]|[1-9]/)
      @nums_int = nums_str.map(&:to_i)
      decide_hands
  end

  def decide_hands #case文
      if straight? && flash?
          $hand_strength = 8
          message = "ストレートフラッシュ"
      elsif num_card?(4)
          $hand_strength = 7
          message = "フォー・オブ・ア・カインド"
      elsif num_card?(3) && num_card?(2)
          $hand_strength = 6
          message = "フルハウス"
      elsif flash?
          $hand_strength = 5
          message = "フラッシュ"
      elsif straight?
          $hand_strength = 4
          message = "ストレート"
      elsif num_card?(3)
          $hand_strength = 3
          message = "スリー・オブ・ア・カインド"
      elsif two_pair?
          $hand_strength = 2
          message = "ツーペア"
      elsif num_card?(2)
          $hand_strength = 1
          message = "ワンペア"
      else
          $hand_strength = 0
          message = "ハイカード"
      end
  end

  def straight?
      if (@nums_int.sort[4] - @nums_int.sort[0]) == 4 && all_unique?
          true
      elsif over_straight? && all_unique?
          true
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
          if array.all?{|i| @nums_int.include?(i)}
              return true
          end
      end
      false
  end

  def all_unique?
      if @nums_int.uniq.count == 5
          true
      end
  end

  def flash?
      if @suits.uniq.count == 1
          true
      end
  end

  def num_card?(i)
      num_count = count_nums
      num_count.each_value do |v|
          if v == i
              return true
          end
      end
      false
  end

  def two_pair?
      num_count = count_nums
      pair_count = 0
      num_count.each_value do |v|
          if v == 2
              pair_count += 1
              if pair_count == 2
                  return true
              end
          end
      end
      return false
  end

  def count_nums
      num_count = {1=>0, 2=>0, 3=>0, 4=>0, 5=>0, 6=>0, 7=>0, 8=>0, 9=>0, 10=>0, 11=>0, 12=>0, 13=>0}
      @nums_int.each do |num|
          num_count[num] += 1
      end
      num_count
  end

  module_function :search_hands, :decide_hands, :straight?, :over_straight?, :all_unique?, :flash?, :num_card?, :two_pair?, :count_nums
end