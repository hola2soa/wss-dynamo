require 'dynamoid'

class Item
  include Dynamoid::Document
  field :items, :string
  field :prices, :datetime
  field :pages, :string

  def self.destroy(id)
    find(id).destroy
  end

  def self.delete_all
    all.each(&:delete)
  end
end
