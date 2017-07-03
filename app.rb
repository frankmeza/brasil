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
    set_response_as_json
    if authenticated User
      auth_status = { authenticated: true }
    else
      auth_status = { authenticated: false }
    end
    res.write auth_status.to_json
  end

  unless has_jwt?
    set_response_status 401
    res.write Message.error('jwt_missing').to_json
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
