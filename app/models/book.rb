class Book < ApplicationRecord
  has_many :loans
  has_many :reviews
end
