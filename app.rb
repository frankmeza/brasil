require './dependencies'

ENV['RACK_ENV'] ||= "development"
Mongoid.load!("#{Dir.pwd}/config/mongoid.yml")

Brasil.use Rack::Session::Cookie, secret: "foo"
Brasil.plugin Brasil::Safe

Brasil.use Shield::Middleware
Brasil.plugin Shield::Helpers

Brasil.define do
  # no namespace # no auth needed
  on get, root do
    set_response_as_json
    root_message = { root_path: true }
    res.write root_message.to_json
  end

  # auth/ # no auth needed
  on 'auth' do
    run AuthCtrl
  end

  # YOU SHALL NOT PASS WITHOUT JWT
  halt respond_with(401, 'jwt_missing') unless has_jwt?

  # users/ # auth needed
  on 'users' do
    unless is_valid_admin_token?(env['HTTP_JWT_TOKEN'])
      halt respond_with(403, 'admin_invalid')
    end
    run UsersCtrl
  end
end
