class AddImageAndProfileToLists < ActiveRecord::Migration[6.0]
  def change
    add_column :lists, :image, :string
    add_column :lists, :profile, :text
  end
end
