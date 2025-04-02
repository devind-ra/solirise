class Appraisal < ApplicationRecord
  belongs_to :user

  has_many :entries, dependent: :destroy

  validates :user_id, presence: true
end
