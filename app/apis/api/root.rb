module API
  class Root < Grape::API
    prefix 'api'

    mount API::Ver1::Poker
  end
end