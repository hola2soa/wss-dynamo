require 'dynamoid'

class Item
  include Dynamoid::Document
  field     :title,       :string
  field     :price,       :string
  field     :link,        :string
  field     :image_link,  :array
  has_one   :store

  belongs_to  :item

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
