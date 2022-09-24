class Loan < ApplicationRecord
    validates :book_id, presence: true
    validates :user_id, presence: true
    belongs_to :user
end
