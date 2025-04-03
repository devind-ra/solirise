class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  has_many :appraisals, dependent: :destroy
  has_many :entries, through: :appraisals
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
