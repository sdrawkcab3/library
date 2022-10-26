class Loan < ApplicationRecord
    validates :book_id, presence: true
    validates :user_id, presence: true
    validates :created_at, presence: true
    belongs_to :user
end
