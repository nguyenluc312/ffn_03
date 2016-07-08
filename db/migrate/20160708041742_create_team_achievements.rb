class CreateTeamAchievements < ActiveRecord::Migration
  def change
    create_table :team_achievements do |t|
      t.string :name
      t.references :season_team, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
