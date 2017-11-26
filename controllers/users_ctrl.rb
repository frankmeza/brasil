UsersCtrl = Brasil.new do
  on true do
    set_response_as_json

    on get, root do
      users = User.all.map do |u|
        u.serialize(:id, :username, :email, :is_admin)
      end
      write_res_as_json(users: users)
    end

    on get, 'username/:username' do |username|
      u = User.fetch_by_username(username)
      user = u.serialize(:id, :username, :email, :is_admin)
      write_res_as_json(user: user)
    end

    on get, 'id/:id' do |id|
      u = User.[](id)
      user = u.serialize(:id, :username, :email, :is_admin)
      write_res_as_json(user: user)
    end

    on patch, 'id/:id' do |id|
      body = parse_req_as_json
      begin
        user = User.[](id)
        user.save if user.update(body)
      rescue => exception
        set_response_status(422)
        res.write(exception)
      end
      remove_content_type_headers
      set_response_status(204)
    end

    on post, root do
      body = parse_req_as_json
      user = User.new(body)
      if user.valid?
        set_response_status(201)
      else
        set_response_status(422)
        write_res_as_json(errors: Message.get_msg('bad_request'))
      end
    end

    on delete, 'id/:id' do |id|
      user = User.[](id)
      user.destroy
      remove_content_type_headers
      set_response_status(204)
    end
  end
end

Brasil.define do
  run UsersCtrl
end
