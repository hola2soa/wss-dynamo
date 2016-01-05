class GetUserStores
  def call(email_address)
    user = User.find_by_email_address(email_address)
    user.stores.flat_map { |s| s.name }
  end
end
