class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title, null: false
      t.text :body
      t.integer :user_id, null: false
      t.integer :meetup_id, null: false
    end
  end
end
