module Rack
  class InsertHtml
    VERSION = '0.0.2'.freeze
    DEFAULT_INSERTION_POINT = '</body>'.freeze
    HTML_CONTENT_TYPE = 'text/html'.freeze

    def initialize(app, options = {})
      @app, @options = app, options
      @options[:insertion_point] ||= DEFAULT_INSERTION_POINT 
    end

    def call(env)
      status, headers, response = @app.call(env) 

      if headers['Content-Type'].to_s.include? HTML_CONTENT_TYPE 
        new_response = []
        response.each do |body|
          # find the last matching insertion point in the body and insert the content
          partition = body.rpartition(@options[:insertion_point])
          partition[0] += @options[:content].to_s
          new_response << partition.join 
        end

        # Update the content-length
        headers['Content-Length'] = new_response.inject(0) do |len, body|
          len += body.bytesize
        end.to_s

        [status, headers, new_response]
      else
        [status, headers, response]
      end
    end
  end
end
