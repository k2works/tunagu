require_relative "spec_helper"
require_relative "../aiiiiiin.rb"

def app
  Aiiiiiin
end

describe Aiiiiiin do
  it "responds with a welcome message" do
    get '/'

    last_response.body.must_include 'Welcome to the Sinatra Template!'
  end
end
