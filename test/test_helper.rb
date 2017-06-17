ENV['RACK_ENV'] = 'test'
$VERBOSE=nil

require 'minitest/autorun'
require 'rack/test'
require 'minitest/reporters'
require_relative '../dependencies'

Minitest::Reporters.use! [ Minitest::Reporters::DefaultReporter.new ]

require_relative '../app'

class RackTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Cuba
  end

  def clean_data
    Mongoid::Config.purge!
  end
end
