require './dependencies'
# require './config/mongoid.yml'
require 'mongoid'
require 'faker'

Mongoid.configure do
  env = ENV['RACK_ENV'] || 'development'
  Mongoid.load! './config/mongoid.yml', env
end

# empty the database
Mongoid::Config.purge!

# seed data
100.times do
  User.create!(
    username: Faker::Name.first_name,
    email: Faker::Internet.email,
    password: 'password'
  )
end
