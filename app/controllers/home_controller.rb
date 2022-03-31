class HomeController < ApplicationController
  include ErrorService
  include JudgeService

  def top; end

  def show
    cards = params[:cards]
    flash[:cards] = cards
    message = ErrorService.search_error(cards) || JudgeService.search_hand(cards)[:name]
    flash[:message] = message.is_a?(Array) ? message.join("\n") : message
    redirect_to '/'
  end
end
