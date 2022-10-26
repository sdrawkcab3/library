class Review < ApplicationRecord
    validates :stars, presence: true, numericality: { in: 0..5 }
    validates :user_id, presence: true
    validates :book_id, presence: true
    validates :title, presence: true
    belongs_to :user
    belongs_to :book
end
