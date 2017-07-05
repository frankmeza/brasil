class User
  include Shield::Model
  include Mongoid::Document
  include ActiveModel::Validations

  attr_accessor :username, :email

  validates_each :username, :email do |model, attr, value|
    if value == nil || value == ''
      model.errors.add(attr, 'cannot be blank.')
    end
  end

  field :is_admin, type: Boolean, default: false
  field :email, type: String
  field :username, type: String
  field :crypted_password, type: String


  def self.fetch(identifier)
    find(email: identifier) || find(username: identifier)
  end

  def self.[](id)
    find(id)
  end

  def get_data
    { username: username, email: email }
  end
end
