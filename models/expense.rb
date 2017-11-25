require_relative '../lib/serializer'

class Expense
  include Mongoid::Document
  include ::Serializer

  field :vendor, type: String
  field :amount, type: Integer
  field :date, type: DateTime
  field :description, type: String
  field :photo, type: String

  validates_each :vendor, :amount, :date do |model, attr, value|
    if value == nil || value == ''
      model.errors.add(attr, 'cannot be blank.')
    end
  end

  def self.summary
    Expense.all.map { |expense| expense.amount }.reduce(:+)
  end

  def self.summary_for_date_range(begin_date, end_date)
  end
end