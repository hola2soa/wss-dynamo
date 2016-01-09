require 'dynamoid'

class Store
  include Dynamoid::Document
  field   :name,   :string
  # field   :url,    :string

  belongs_to :item

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
