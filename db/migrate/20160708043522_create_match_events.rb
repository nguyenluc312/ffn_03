class CreateMatchEvents < ActiveRecord::Migration
  def change
    create_table :match_events do |t|
      t.references :match, index: true, foreign_key: true
      t.text :content
      t.datetime :time

      t.timestamps null: false
    end
  end
end
