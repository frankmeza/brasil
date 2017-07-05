class User
  include Shield::Model
  include Mongoid::Document
  # include ActiveModel::Validations

  # attr_reader :username, :email

  # validates_each :username, :email do |model, attr, value|
  #   puts attr
  #   puts value
  #   if value == nil || value == ''
  #     model.errors.add(attr, 'cannot be blank.')
  #   end
  # end

  field :is_admin, type: Boolean, default: false
  field :email, type: String
  field :username, type: String
  field :crypted_password, type: String


  def self.fetch(identifier)
    where(email: identifier).first || where(username: identifier).first
  end

  def self.[](id)
    find(id)
  end

  def get_data
    { username: username, email: email }
  end
end
