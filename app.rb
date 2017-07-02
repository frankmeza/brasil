require './dependencies'

ENV['RACK_ENV'] ||= "development"
Mongoid.load!("#{Dir.pwd}/config/mongoid.yml")

Cuba.use Rack::Session::Cookie, secret: "foo"
Cuba.plugin Cuba::Safe

Cuba.use Shield::Middleware
Cuba.plugin Shield::Helpers

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
  on 'auth' do
    run AuthCtrl
  end
  # end
end
