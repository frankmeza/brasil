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
  end
end