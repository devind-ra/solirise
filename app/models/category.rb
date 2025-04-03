class Category < ApplicationRecord
    has_many :entries
    has_many :questions

    validates :name, presence: true, uniqueness: true
end
