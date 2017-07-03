class Message
  def self.get_msg(key)
    self.messages[key.to_sym]
  end

  def self.messages
    {
      invalid_credentials: 'Your login credentials are not correct.'
    }
  end
end
