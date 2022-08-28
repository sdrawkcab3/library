class AddReturnedAtToLoans < ActiveRecord::Migration[7.0]
  def change
    add_column :loans, :returned_at, :datetime
  end
end
