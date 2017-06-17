require './dependencies'

ENV['RACK_ENV'] ||= "development"
Mongoid.load!("#{Dir.pwd}/config/mongoid.yml")

Cuba.define do
  on get, root do
    lit = { lit: true }
    res.write lit.to_json
  end

  on get, 'users' do
    run UsersCtrl
  end
end
