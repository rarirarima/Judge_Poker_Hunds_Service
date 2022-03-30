module ErrorService
  FIVE_CARDS = /^(\w+\s+){4}\w+$/
  CORRECT_CARD = /^([CDHS])([1-9]|1[0-3])$/

  def process_errors(cards)
    if card_blank_error?(cards)
      'カードが入力されていません。'
    elsif invalid_card_error?(cards)
      '5つのカード指定文字を半角スペース区切りで入力してください。'
    else
      card_array = cards.split(' ')
      incorrect_card_error(card_array) || repeat_error(card_array)
    end
  end

  # カードが未入力or空文字列
  def card_blank_error?(cards)
    cards.blank?
  end

  # カードリクエストがStringではない場合orカードが5枚ではない場合(全角スペース, 先頭と末尾の半角スペースはエラー)
  def invalid_card_error?(cards)
    true if !cards.is_a?(String) || cards !~ FIVE_CARDS
  end

  # カード指定文字不正のエラーメッセージを配列でを返す
  def incorrect_card_error(card_array)
    incorrect_error_msgs = []
    card_array.each.with_index do |card, i|
      incorrect_error_msgs.push("#{i + 1}番目のカード指定文字(#{card})が不正です。") if incorrect_card?(card)
    end
    incorrect_error_msgs.blank? ? nil : incorrect_error_msgs
  end

  def incorrect_card?(card)
    true if card !~ CORRECT_CARD
  end

  def repeat_error(cards_array)
    'カードが重複しています。' if cards_array.uniq.count != 5
  end

  module_function :process_errors, :card_blank_error?, :invalid_card_error?, :incorrect_card_error,
                  :incorrect_card?, :repeat_error
end
