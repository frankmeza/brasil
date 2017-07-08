# users_controller

require_relative './_ctrl_dependencies'

UsersCtrl = Brasil.new do
  on true do
    set_response_as_json

    on get, root do
      # set_response_as_json

      uu = User.all.map do |u|
        u.serialize(:id, :username, :email)
      end

      write_res_as_json({ users: uu })
    end

    on get, 'id/:id' do |id|
      set_response_as_json
      u = User.[](id.to_s)
      user = u.serialize(:id, :username, :email)
      res.write user.to_json
    end

    on put, 'id/:id/edit' do |id|
      puts parse_req_as_json
      body = parse_req_as_json
      u = User.find(id)

      begin
        u.update(body)
        set_response_status(204)
      rescue => exception
        set_response_status(422)
        res.write exception
      end
    end

    on get, ':username' do |username|
      set_response_as_json
      u = User.fetch_by_username(username)
      user = u.serialize(:id, :username, :email)
      res.write user.to_json
    end
  end
end

Brasil.define do
  run UsersCtrl
end
