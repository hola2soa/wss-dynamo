require 'dynamoid'

class UserRequest
  include Dynamoid::Document
  field   :keywords,        :array
  field   :prices,          :array
  field   :categories,      :array
  has_one :user

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
