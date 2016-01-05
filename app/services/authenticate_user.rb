class AuthenticateUser
  def call(email_address)
    # in real world should auth token/password ...
    User.find_by_email_address(email_address)
  end
end
