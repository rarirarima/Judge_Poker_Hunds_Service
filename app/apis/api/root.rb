module API
  class Root < Grape::API
    prefix 'api'

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error!({errors: [{message: 'カード情報が不正です。',}]},400)
    end
    mount API::Ver1::Poker
  end
end