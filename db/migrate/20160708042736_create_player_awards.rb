class CreatePlayerAwards < ActiveRecord::Migration
  def change
    create_table :player_awards do |t|
      t.references :player, index: true, foreign_key: true
      t.string :nameLstring
      t.references :league_season, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
