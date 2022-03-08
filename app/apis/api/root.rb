module API
  class Root < Grape::API
    prefix 'api'

    content_type :json, 'application/json'
    content_type :txt, 'text/plain'
    content_type :xml, 'application/xml'

    default_format :json

    rescue_from Grape::Exceptions::ValidationErrors do |_e|
      error!({ error: [{ msg: 'カード情報が不正です。' }] }, 400)
    end

    mount API::Ver1::Poker
  end
end
