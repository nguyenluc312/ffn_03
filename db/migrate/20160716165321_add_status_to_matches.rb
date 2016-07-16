class AddStatusToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :status, :integer
  end
end
