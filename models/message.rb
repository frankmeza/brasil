class Message
  def self.get_msg(key)
    self.messages[key.to_sym]
  end

  def self.messages
    {
      admin_invalid: 'Your token is not an admin token.',
      credentials_invalid: 'Your login credentials are not correct.',
      jwt_missing: 'Your request header is missing the "JWT_TOKEN" header.',
      bad_request: 'There was an error saving, try again.'
    }
  end
end
