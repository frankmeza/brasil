# expenses_controller

ExpensesCtrl = Brasil.new do
  on true do
    set_response_as_json

    on get, root do
      res.write(mensagem: 'hella lit')
    end
  end
end