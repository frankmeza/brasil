require './dependencies'
require 'mongoid'
require 'faker'

Mongoid.configure do
  env = ENV['RACK_ENV'] || 'development'
  Mongoid.load!('./config/mongoid.yml', env)
end

# empty the database
Mongoid::Config.purge!

# # # # # # # #
#  seed data  #
# # # # # # # #

admin = User.create!(
  username: 'ADMIN',
  email: 'admin@email.com',
  password: 'password',
  is_admin: true
)

# {:username=>"ADMIN", :email=>"admin@email.com"}
# JWT_TOKEN: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6IkFETUlOIiwiZW1haWwiOiJhZG1pbkBlbWFpbC5jb20ifQ.4XSL_eFP5X2odvYn4zKJa7oMxWSOgLVgs4bQUTZKkOU

alpha = User.create!(
  username: 'alpha',
  email: 'alpha@email.com',
  password: 'password'
)

# {:username=>"alpha", :email=>"alpha@email.com"}
# JWT_TOKEN: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6ImFscGhhIiwiZW1haWwiOiJhbHBoYUBlbWFpbC5jb20ifQ.rqbMh-9KihAuLJmKAyHWptmy2DJMnLA-nhH9u4DRW9A

# Users
98.times do
  User.create!(
    username: Faker::Name.first_name,
    email: Faker::Internet.email,
    password: 'password',
    is_admin: false
  )
end

puts 'Seeding is complete.'
puts 'Admin data: #=>'
puts admin.get_data
puts "JWT_TOKEN: #{AuthCtrl.encode_data(admin.get_data)}"

puts '##########'

puts 'Alpha User data: #=>'
puts alpha.get_data
puts "JWT_TOKEN: #{AuthCtrl.encode_data(alpha.get_data)}"
