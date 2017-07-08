# users_controller

require_relative './_ctrl_dependencies'

UsersCtrl = Brasil.new do
  on true do
    set_response_as_json

    on get, root do
      uu = User.all.map do |u|
        u.serialize(:id, :username, :email)
      end
      write_res_as_json({ users: uu })
    end

    on get, 'id/:id' do |id|
      u = User.[](id.to_s)
      user = u.serialize(:id, :username, :email)
      write_res_as_json({ user: u })
    end

    on put, 'id/:id/edit' do |id|
      body = parse_req_as_json
      u = User.find(id)
      begin
        u.update(body)
        set_response_status(204)
      rescue => exception
        set_response_status(422)
        res.write(exception)
      end
    end

    on get, '/username/:username' do |username|
      u = User.fetch_by_username(username)
      user = u.serialize(:id, :username, :email)
      write_res_as_json({ user: u })
    end
  end
end

Brasil.define do
  run UsersCtrl
end
