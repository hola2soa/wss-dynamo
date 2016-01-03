require 'dynamoid'

class User
  include Dynamoid::Document
  field     :email_address, :email
  has_many  :preferences,   :class_name => :store
  has_many  :pinned_items,  :class_name => :item

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
