class Review < ApplicationRecord
    validates :stars, presence: true, numericality: { in: 0..5 }
    validates :title, presence: true
    validates :book, presence: true
    validates :user, presence: true
    belongs_to :user
end
