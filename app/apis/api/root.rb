module API
  class Root < Grape::API
    prefix 'api'

    format :json
    content_type :json, 'application/json'
    content_type :xml, 'application/xml'
    content_type :javascript, 'application/javascript'
    content_type :txt, 'text/plain'
    content_type :html, 'text/html'
    default_format :json

    rescue_from Grape::Exceptions::ValidationErrors do |_e|
      error!({ error: [{ msg: 'カード情報が不正です。' }] }, 400)
    end

    rescue_from :all do |_e|
      error!({ error: [{ msg: 'カード情報が不正です。' }] }, 400)
    end

    mount API::Ver1::Poker
  end
end
