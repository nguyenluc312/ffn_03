class AddAndChangeColumns < ActiveRecord::Migration
  def change
    add_column :teams, :coach, :integer
    add_column :teams, :nickname, :string
    add_column :teams, :short_name, :string
    remove_column :players, :data_of_birth
    add_column :players, :date_of_birth, :date
    add_column :players, :jersey_number, :integer
    add_column :players, :height, :float
    add_column :players, :weight, :float
  end
end
