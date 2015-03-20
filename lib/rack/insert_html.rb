module Rack
  class InsertHtml
    VERSION = '0.0.1'
    DEFAULT_INSERTION_POINT = '</body>'

    def initialize(app, options = {})
      @app, @options = app, options
      @options[:insertion_point] ||= DEFAULT_INSERTION_POINT 
    end

    def call(env)
      response = @app.call(env)
      status, headers, body = response

      # find the last matching insertion point in the body and insert the content
      pre, match, post = body.first.rpartition(@options[:insertion_point])
      body = "#{pre}#{@options[:content]}#{match}#{post}"

      # Update the content-length
      headers['Content-Length'] = body.bytesize.to_s

      [status, headers, [body]]
    end
  end
end
