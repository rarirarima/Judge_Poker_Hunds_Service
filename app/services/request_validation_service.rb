module RequestValidationService

  def process_errors(cards)
      if cards.blank?
          message = "カードが入力されていません。"
      elsif !cards.kind_of?(String)
        message = "5つのカード指定文字を半角スペース区切りで入力してください。（例:S1 D1 H1 C13 H13）"
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
              incorrect_error_message = "#{i + 1}番目のカード指定文字が不正です。(#{cards_array[i]})"
          end
      end
      if incorrect_error_message.blank?
          false
      else
          incorrect_error_message
      end
  end


  def incorrect_card?(card)
      if /^[CDHS]{1}([1-9]|1[0-3]){1}$/ !~ card
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