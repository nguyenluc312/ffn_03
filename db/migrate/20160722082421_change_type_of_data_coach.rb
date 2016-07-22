class ChangeTypeOfDataCoach < ActiveRecord::Migration
  def change
    change_column :teams, :coach, :string
  end
end
