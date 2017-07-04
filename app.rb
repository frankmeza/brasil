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

  # users/ # auth needed
  on 'users' do
    halt respond_with(401, 'jwt_missing') unless has_jwt?
    begin is_valid_token?(env['JWT_TOKEN'])
      run UsersCtrl
    rescue
      res.write Message.error('jwt_invalid').to_json
    end
  end
end
