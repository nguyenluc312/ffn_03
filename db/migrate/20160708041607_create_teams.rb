class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.references :country, index: true, foreign_key: true
      t.string :logo
      t.text :introduction

      t.timestamps null: false
    end
  end
end
