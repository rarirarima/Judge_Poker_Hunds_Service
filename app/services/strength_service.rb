module StrengthService
  # strengthの中で最も大きい数字を最強な役とする
  def search_best(strengths, result)
    bests = strengths.each_index.select { |i| strengths[i] == strengths.max }
    change_to_best(bests, result)
  end

  # 最強な役のresultのbestをfalseからtrueに変更
  def change_to_best(bests, result)
    bests.each do |best|
      result[best][:best] = true
    end
    result
  end

  module_function :search_best, :change_to_best
end
