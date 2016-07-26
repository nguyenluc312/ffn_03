class AddDelayedJobIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :delayed_job_id, :integer
  end
end
