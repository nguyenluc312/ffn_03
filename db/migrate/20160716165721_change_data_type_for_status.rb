class ChangeDataTypeForStatus < ActiveRecord::Migration
  def change
    change_column :match_events, :time, :integer
  end
end
