require './dependencies'

ENV['RACK_ENV'] ||= "development"
Mongoid.load!("#{Dir.pwd}/config/mongoid.yml")

Cuba.plugin Cuba::Safe

Cuba.define do
  # no namespace, unauthenticated
  on get, root do
    lit = { lit: false }
    res.write lit.to_json
  end

  # users/
  on 'users' do
    run UsersCtrl
  end

  # unless authenticated?
  on 'login' do
    run AuthCtrl
  end
  # end
end
