class Category < ApplicationRecord
    has_many :entries
    has_many :questions

    # validates :name, uniqueness: { scope: :page }
end
