class HomeController < ApplicationController
  include ErrorService
  include JudgeService

  def top; end

  def show
    cards = params[:cards]
    flash[:cards] = cards
    message = ErrorService.process_errors(cards) || JudgeService.search_hands(cards)[:name]
    flash[:message] = message.is_a?(Array) ? message.join("\n") : message
    redirect_to '/'
  end
end
