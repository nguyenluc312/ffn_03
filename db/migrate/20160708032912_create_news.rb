class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.text :brief_description
      t.text :content
      t.string :author
      t.references :news_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
