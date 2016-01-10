require 'dynamoid'

class Item
  include Dynamoid::Document
  field     :title,       :string,  presence: true
  field     :price,       :string,  presence: true
  field     :link,        :string,  presence: true
  field     :images,      :array,   presence: true
  has_one   :store
  belongs_to :users

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
