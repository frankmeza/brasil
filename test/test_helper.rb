ENV['RACK_ENV'] = 'test'
$VERBOSE=nil

require 'minitest/autorun'
require 'rack/test'
require 'minitest/reporters'
Minitest::Reporters.use! [ Minitest::Reporters::DefaultReporter.new ]

require_relative '../app'

class RackTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Cuba
  end
end
