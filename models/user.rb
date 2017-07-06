class User
  include Shield::Model
  include Mongoid::Document

  field :is_admin, type: Boolean, default: false
  field :email, type: String
  field :username, type: String
  field :crypted_password, type: String

  validates_each :username, :email do |model, attr, value|
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    if value == nil || value == ''
      model.errors.add(attr, 'cannot be blank.')
    end

    if attr == 'email'
      unless value =~ VALID_EMAIL_REGEX
        model.errors.add(attr, 'is not valid.')
      end
    end
  end

  def self.fetch(identifier)
    where(email: identifier).first || where(username: identifier).first
  end

  def self.fetch_by_username(username)
    where(username: username).first
  end

  def self.[](id)
    find(id)
  end

  def get_data
    { username: username, email: email }
  end
end
