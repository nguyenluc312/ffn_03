class AddMissingColumnToTable < ActiveRecord::Migration
  def change
    add_column :teams, :full_name, :string
    add_column :countries, :flag, :string
  end
end
