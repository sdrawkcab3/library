class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.integer :ISBN
      t.text :cover_text
      t.text :short_description
      t.float :cost
      t.string :collection
      t.string :case
      t.integer :shelf

      t.timestamps
    end
  end
end
