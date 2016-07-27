class AddColumnToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :founded_at, :date
    add_column :leagues, :introduction, :text
  end
end
