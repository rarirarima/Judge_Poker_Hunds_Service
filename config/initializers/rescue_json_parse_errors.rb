class RescueJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ActionDispatch::ParamsParser::ParseError => _e
    [
      400, { 'Content-Type' => 'application/json' },
      [{ error: [{ msg: 'JSONの形式が不正です。' }] }.to_json]
    ]
  end
end
