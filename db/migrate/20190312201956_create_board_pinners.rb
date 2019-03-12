class CreateBoardPinners < ActiveRecord::Migration
  def change
    create_table :board_pinners do |t|
      t.references :user, index: true, foreign_key: true
      t.references :board, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
