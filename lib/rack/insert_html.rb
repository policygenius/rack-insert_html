module Rack
  class InsertHtml
    VERSION = '0.0.1'

    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      response = @app.call(env)
      status, headers, body = response
      headers['Content-Length']= body.length.to_s
      [status, headers, body]
    end
  end
end
