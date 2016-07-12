class AddRepresentImageToNews < ActiveRecord::Migration
  def change
    add_column :news, :represent_image, :string
  end
end
