class CreateLeagueSeasons < ActiveRecord::Migration
  def change
    create_table :league_seasons do |t|
      t.integer :year
      t.references :league, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
