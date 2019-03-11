class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :follower_id, index: true

      t.timestamps null: false
    end
    add_foreign_key :followers, :users, {column: "follower_id"}
  end
end
