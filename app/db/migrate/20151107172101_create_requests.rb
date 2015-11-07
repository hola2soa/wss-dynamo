class CreateUserRequests < ActiveRecord::Migration
  def change
    create_table :user_requests do |t|
      # t.string :description
      t.text :items
      t.text :prices
      t.text :pages
      t.timestamps null: false
    end
  end
end
