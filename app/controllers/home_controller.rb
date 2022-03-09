class HomeController < ApplicationController
  include BaseService

  def top; end

  def show
    cards = params[:cards]
    flash[:cards] = cards
    base_service = BaseService::Base.new(cards)
    message = base_service.api_or_webapp
    flash[:message] = message
    redirect_to 'http://localhost:3000'
  end
end
