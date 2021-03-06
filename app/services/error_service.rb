module ErrorService
  FIVE_CARDS = /^(\w+\s+){4}\w+$/
  CORRECT_CARD = /^([CDHS])([1-9]|1[0-3])$/

  def search_error(cards)
    if card_blank_error?(cards)
      ['カードが入力されていません。']
    elsif card_class_error?(cards) || not_five_cards_error?(cards)
      ['5つのカード指定文字を半角スペース区切りで入力してください。']
    else
      card_array = cards.split(' ')
      incorrect_card_error(card_array) || repeat_error(card_array)
    end
  end

  # カードが未入力or空文字列の場合
  def card_blank_error?(cards)
    cards.blank?
  end

  # カードリクエストがStringではない場合
  def card_class_error?(cards)
    !cards.is_a?(String)
  end

  # カードが5枚ではない場合(全角スペース, 先頭・末尾のスペースはエラー)
  def not_five_cards_error?(cards)
    cards !~ FIVE_CARDS
  end

  # カード指定文字不正のエラーの場合
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

  # カードが重複している場合
  def repeat_error(card_array)
    ['カードが重複しています。'] if card_array.uniq.count != 5
  end

  module_function :search_error, :card_blank_error?, :card_class_error?, :not_five_cards_error?,
                  :incorrect_card_error, :incorrect_card?, :repeat_error
end
