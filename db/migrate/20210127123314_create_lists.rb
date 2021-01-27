class CreateLists < ActiveRecord::Migration[6.0]
  def change
    create_table :lists do |t|
      t.string :label
      t.text :content

      t.timestamps
    end
  end
end
