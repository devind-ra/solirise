class User < ApplicationRecord
  enum role: { user: "user", admin: "admin" }

  validates :first_name, presence: true, length: { maximum: 50 }, format: { with: /\A[a-zA-Z\s'-]+\z/, message: "only allows letters, spaces, hyphens, and apostrophes" }
  validates :last_name, presence: true, length: { maximum: 50 }, format: { with: /\A[a-zA-Z\s'-]+\z/, message: "only allows letters, spaces, hyphens, and apostrophes" }
  validates :email, presence: true, uniqueness: true
  has_many :appraisals, dependent: :destroy
  has_many :entries, through: :appraisals
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    role == "admin"
  end

  def standard_user?
    true
  end
end
