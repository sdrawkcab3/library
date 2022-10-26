class Book < ApplicationRecord
  validates :ISBN, presence: true
  validates :author, presence: true
  validates :title, presence: true
  has_many :loans
  has_many :reviews
end
