class ChangeCoinDefaultValueOfUser < ActiveRecord::Migration
  def change
    change_column_default :users, :coin, 1000
  end
end
