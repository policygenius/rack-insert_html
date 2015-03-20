require 'spec_helper'
require 'rack'
require 'rack/lint'
require 'rack/mock'

describe Rack::InsertHtml do
  let(:example_html) { "<html><head></head><body><h1>Example Page</h1></body></html>" }
  let(:inner_app) do
    proc { |env| 
      [
        200, 
        { 
          'Content-Type' => 'text/html', 
          'Content-Length' => example_html.bytesize 
        }, 
        [example_html]
      ]
    }
  end
  let(:request)  { Rack::MockRequest.new(Rack::Lint.new(stack)) }

  it 'has a version number' do
    expect(Rack::InsertHtml::VERSION).not_to be nil
  end

  context 'without any custom configuration' do
    let(:stack) { Rack::InsertHtml.new(inner_app) }

    it 'is a valid rack app' do
      request.get '/'
    end

    it 'does not append anything' do
      response = request.get '/'
      expect(response.body).to eq example_html
    end
  end

  context 'with configuration for content' do
    let(:content) { '<script>var insertedContent = 123;</script>' }
    let(:options) { { content: content } }
    let(:stack) { Rack::InsertHtml.new(inner_app, options) }

    it 'appends the content to the <body> of the response' do
      response = request.get '/'
      expect(response.body).to include "#{content}</body>"
    end

    context 'and configuration for the insertion point' do
      let(:insertion_point) { '</head>' }
      let(:options) { { content: content, insertion_point: insertion_point } }

      it 'appends the content before the custom insertion point' do
        response = request.get '/'
        expect(response.body).to include "#{content}#{insertion_point}"
      end
    end
  end

  context 'when it is not an html response' do
    let(:inner_app) do
      proc { |env| [ 200, { 'Content-Type' => 'text/plain', 'Content-Length' => '11' }, ["Hello world"] ] }
    end
    let(:stack) { Rack::InsertHtml.new(inner_app, { content: 'insert_this_content', insertion_point: 'world' }) }

    it 'does not insert the content' do
      response = request.get '/'
      expect(response.body).to eq 'Hello world'
    end
  end
end

