class AddReferencesToLoans < ActiveRecord::Migration[7.0]
  def change
    add_reference :loans, :user, null: false, foreign_key: true
    add_reference :loans, :book, null: false, foreign_key: true
  end
end
