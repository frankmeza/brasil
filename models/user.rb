class User
  include Shield::Model
  include Mongoid::Document

  field :email, type: String
  field :username, type: String
  field :crypted_password, type: String

  def self.fetch(identifier)
    where(email: identifier).first || where(username: identifier).first
  end

  def self.[] (id)
    find(id)
  end

  # def email
  #   email
  # end
end
