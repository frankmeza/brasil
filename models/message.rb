class Message
  def self.get_msg(key)
    self.messages[key.to_sym]
  end

  def self.error(key)
    { errors: self.get_msg(key) }
  end

  def self.success(key)
    { success: self.get_msg(key) }

  def self.messages
    {
      invalid_credentials: 'Your login credentials are not correct.'
      jwt_missing: 'Your request header is missing the "JWT_TOKEN" header.'
    }
  end
end
