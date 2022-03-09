module ErrorService
  WEB_APP = 'webapp'
  API = 'api'

  def process_errors(cards, service)
    if cards.blank?
      error_msg = 'カードが入力されていません。'
    elsif !cards.is_a?(String)
      error_msg = '5つのカード指定文字を半角スペース区切りで入力してください。'
    else
      card_array = cards.split(' ')
      error_msg = if card_array.size != 5
                    '5つのカード指定文字を半角スペース区切りで入力してください。'
                  elsif incorrect_card_error(card_array, service)
                    incorrect_card_error(card_array, service)
                  elsif repeat_error?(card_array)
                    'カードが重複しています。'
                  end
    end
    error_msg
  end

  def incorrect_card_error(card_array, service)
    service == WEB_APP ? incorrect_card_error_webapp(card_array) : incorrect_card_error_api(card_array)
  end

  # WebAPPはエラーメッセージを文字列で返す
  def incorrect_card_error_webapp(card_array)
    incorrect_error_msg = ''
    card_array.each.with_index do |card, i|
      incorrect_error_msg += "#{i + 1}番目のカード指定文字(#{card})が不正です。\n" if incorrect_card?(card)
    end
    incorrect_error_msg.blank? ? false : "#{incorrect_error_msg}半角英字大文字のスート（C,D,H,S）と半角数字（1〜13）の組み合わせでカードを指定してください。"
  end

  # APIはエラーメッセージを配列にして返す=>不正カード1枚ごとに1Hashでエラーを表示
  def incorrect_card_error_api(card_array)
    incorrrect_card_array = []
    card_array.each.with_index do |card, i|
      incorrrect_card_array.push("#{i + 1}番目のカード指定文字(#{card})が不正です。") if incorrect_card?(card)
    end
    incorrrect_card_array.blank? ? false : incorrrect_card_array
  end

  def incorrect_card?(card)
    true if /^[CDHS]{1}([1-9]|1[0-3]){1}$/ !~ card
  end

  def repeat_error?(cards_array)
    true if cards_array.uniq.count != 5
  end

  module_function :process_errors, :incorrect_card_error, :incorrect_card_error_webapp, :incorrect_card_error_api,
                  :incorrect_card?, :repeat_error?
end
