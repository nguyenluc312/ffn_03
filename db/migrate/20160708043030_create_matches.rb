class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :league_season, index: true, foreign_key: true
      t.integer :team1_id
      t.integer :team2_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :team1_goal
      t.integer :team2_goal
      t.float :team1_odds
      t.float :team2_odds
      t.float :draw_odds

      t.timestamps null: false
    end
  end
end
