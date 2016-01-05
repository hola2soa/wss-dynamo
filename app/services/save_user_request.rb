class SaveUserRequest
  def call(email_address, record)
    user = User.find_by_email_address(email_address)
    user_request = nil
    if !user.nil?
      user_request = UserRequest.new(record)
      user_request.user = user
      user_request.save
    end
    user_request
  end
end
