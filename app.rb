require './dependencies'

ENV['RACK_ENV'] ||= "development"
Mongoid.load!("#{Dir.pwd}/config/mongoid.yml")

Brasil.use Rack::Session::Cookie, secret: "foo"
Brasil.plugin Brasil::Safe

Brasil.use Shield::Middleware
Brasil.plugin Shield::Helpers

Brasil.define do
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
