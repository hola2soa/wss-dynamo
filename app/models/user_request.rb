require 'dynamoid'

class UserRequest
  include Dynamoid::Document
  field   :keywords,   :string
  field   :prices,  :string
  # has_one :user,    :class_name => :user

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
