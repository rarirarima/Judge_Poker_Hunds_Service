class HomeController < ApplicationController
  include BaseService

  def top; end

  def show
    cards = params[:cards]
    flash[:cards] = cards
    summarize_class = BaseService::Summarize.new
    message = summarize_class.api_or_webapp(cards)
    flash[:message] = message
    redirect_to 'http://localhost:3000'
  end
end
