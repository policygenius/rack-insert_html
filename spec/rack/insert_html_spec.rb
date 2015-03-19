require 'spec_helper'
require 'rack'
require 'rack/lint'
require 'rack/mock'

describe Rack::InsertHtml do
  let(:app) { proc { |env| [200, {'Content-Type' => 'text/plain'}, ['Hello']] } }
  let(:stack) { Rack::InsertHtml.new(app) }
  let(:request)  { Rack::MockRequest.new(Rack::Lint.new(stack)) }

  it 'has a version number' do
    expect(Rack::InsertHtml::VERSION).not_to be nil
  end

  it 'is a valid rack app' do
    linted_app = Rack::Lint.new(stack)
    env = Rack::MockRequest.env_for('/')
    linted_app.call(env)
  end
end

