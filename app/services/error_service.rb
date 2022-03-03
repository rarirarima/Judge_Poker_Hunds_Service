module ErrorService

  def process_errors(cards)
      if cards.blank?
          message = "カードが入力されていません。"
      else
          cards_array = cards.split(' ')
          if cards.split(' ').size != 5
              message = "5つのカード指定文字を半角スペース区切りで入力してください。（例:S1 D1 H1 C13 H13）"
          elsif incorrect_card_error(cards_array)
              message = incorrect_card_error(cards_array)
          elsif repeat_error?(cards_array)
              message = "カードが重複しています。"
          else
              false
          end
      end
  end

  def incorrect_card_error(cards_array)
      incorrect_error_message = ""
      cards_array.each.with_index do |card, i|
          if incorrect_card?(card)
              incorrect_error_message = incorrect_error_message + "#{i + 1}番目のカード指定文字(#{cards_array[i]})が不正です。\n"
          end
      end
      if incorrect_error_message.blank?
          false
      else
          incorrect_error_message + "半角英字大文字のスート（C,D,H,S）と半角数字（1〜13）の組み合わせでカードを指定してください。"
      end
  end

  def incorrect_card?(str)
      if /^[CDHS]{1}([1-9]|1[0-3]){1}$/ !~ str
          true
      end
  end

  def repeat_error?(cards_array)
      if cards_array.uniq.count != 5
          return true
      end
  end

  module_function :process_errors, :incorrect_card_error, :incorrect_card?, :repeat_error?

end