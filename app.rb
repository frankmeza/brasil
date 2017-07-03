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
    halt respond_with_401 unless has_jwt?

    begin is_valid_token? env['HTTP_JWT_TOKEN']
      auth_status = { authenticated: true }
      res.write auth_status.to_json
    rescue
      res.write Message.error('jwt_invalid').to_json
    end
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
