class CreateUserBets < ActiveRecord::Migration
  def change
    create_table :user_bets do |t|
      t.references :match, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :coin
      t.integer :chosen

      t.timestamps null: false
    end
  end
end
