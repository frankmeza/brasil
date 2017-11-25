# expenses_controller

ExpensesCtrl = Brasil.new do
  on true do
    set_response_as_json

    on get, root do
      expenses = Expense.all.map do |e|
        e.serialize(:id, :vendor, :amount, :date)
      end
      write_res_as_json(expenses: expenses)
    end

    on post, root do
      expense = parse_req_as_json
      Expense.create(expense)
      set_response_status(201)
      write_res_as_json(created: true)
    end
  end
end