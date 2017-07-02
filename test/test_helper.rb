ENV['RACK_ENV'] = 'test'
$VERBOSE=nil

require_relative '../app'
require 'minitest/autorun'
require 'rack/test'
require 'minitest/reporters'
require 'factory_girl'
require_relative '../dependencies'
require 'faker'

Minitest::Reporters.use! [ Minitest::Reporters::DefaultReporter.new ]
FactoryGirl.definition_file_paths = %w{ ./test/factories }
FactoryGirl.find_definitions

class RackTest < MiniTest::Test
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods

  def app
    Cuba
  end

  def clean_data
    Mongoid::Config.purge!
  end
end
