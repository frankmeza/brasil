ENV['RACK_ENV'] = 'test'
$VERBOSE=nil

require_relative '../app'
require_relative '../dependencies'
require 'minitest/reporters'
require 'minitest/autorun'
require 'factory_girl'
require 'rack/test'
require 'faker'

Minitest::Reporters.use! [ Minitest::Reporters::DefaultReporter.new ]
FactoryGirl.definition_file_paths = %w{ ./test/factories }
FactoryGirl.find_definitions

class RackTest < MiniTest::Test
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods

  def app
    Brasil
  end

  def clean_data
    Mongoid::Config.purge!
  end

  def login_this(user)
    credentials = { login: user.username, password: 'password' }
    post '/auth/login', credentials.to_json
  end

  def res
    last_response
  end

  def res_as_json
    JSON.parse res.body
  end
end
