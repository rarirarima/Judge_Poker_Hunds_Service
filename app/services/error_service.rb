module ErrorService
  WEB_APP = 'webapp'
  API = 'api'

  def process_errors(cards, service)
    if cards.blank?
      error_msg = 'カードが入力されていません。'
    elsif !cards.is_a?(String) || cards !~ /^(\w+\s){4}\w+$/
      error_msg = '5つのカード指定文字を半角スペース区切りで入力してください。'
    else
      card_array = cards.split(' ')
      error_msg = if incorrect_card_error(card_array, service)
                    incorrect_card_error(card_array, service)
                  elsif repeat_error?(card_array)
                    'カードが重複しています。'
                  end
    end
    error_msg
  end

  # カード指定文字不正のエラーメッセージをWebAPPは文字列、APIは配列(不正カード1枚につき1ハッシュを用意するため)を返す
  def incorrect_card_error(card_array, service)
    incorrect_error_msg_ar = []
    card_array.each.with_index do |card, i|
      incorrect_error_msg_ar.push("#{i + 1}番目のカード指定文字(#{card})が不正です。") if incorrect_card?(card)
    end
    if incorrect_error_msg_ar.blank?
      false
    elsif service == WEB_APP
      incorrect_error_msg_str = "#{incorrect_error_msg_ar.join("\n")}\n半角英字大文字のスート（C,D,H,S）と半角数字（1〜13）の組み合わせでカードを指定してください。"
    else
      incorrect_error_msg_ar
    end
  end

  def incorrect_card?(card)
    true if /^[CDHS]{1}([1-9]|1[0-3]){1}$/ !~ card
  end

  def repeat_error?(cards_array)
    true if cards_array.uniq.count != 5
  end

  module_function :process_errors, :incorrect_card_error, :incorrect_card?, :repeat_error?
end
