class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.text :items
      t.text :prices
      t.text :pages
      t.timestamps null: false
    end
  end
end
