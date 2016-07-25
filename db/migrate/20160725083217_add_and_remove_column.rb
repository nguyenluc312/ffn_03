class AddAndRemoveColumn < ActiveRecord::Migration
  def change
    remove_column :players, :jersey_number
    add_column :players, :squad_number, :integer
    add_column :players, :joined_at, :date
  end
end
