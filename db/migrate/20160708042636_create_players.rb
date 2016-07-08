class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.text :introduction
      t.integer :position
      t.references :team, index: true, foreign_key: true
      t.datetime :data_of_birth
      t.string :avatar
      t.references :country, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
