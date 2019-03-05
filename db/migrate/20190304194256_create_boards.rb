class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_reference :pinnings, :board, index: true

    User.all.each do |user|
      board = user.boards.create(name: "My Pins!")
      Pinning.all.each do |pinning|
        board.pinnings << pinning
      end
    end
  end
end
