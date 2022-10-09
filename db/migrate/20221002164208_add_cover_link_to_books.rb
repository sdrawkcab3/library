class AddCoverLinkToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :cover_link, :string
  end
end
