class Question < ApplicationRecord
  belongs_to :category
  has_many :entries

  validates :content, presence: true
end
