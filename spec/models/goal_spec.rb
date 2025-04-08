require 'rails_helper'

RSpec.describe Goal, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      user = User.create!(email: 'test@example.com', password: 'password', first_name: 'John', last_name: 'Doe')
      goal = Goal.create!(title: 'Sample Goal', user: user)
      expect(goal.user).to eq(user)
    end
  end

  describe 'validations' do
    it 'is invalid without a title' do
      goal = Goal.new(description: 'Sample Description', progress: 50)
      expect(goal).not_to be_valid
      expect(goal.errors[:title]).to include("can't be blank")
    end

    it 'is valid with a user' do
      user = User.create!(email: 'test@example.com', password: 'password', first_name: 'John', last_name: 'Doe')
      goal = Goal.new(title: 'Sample Goal', user: user)
      expect(goal).to be_valid
    end

    it 'is invalid without a user' do
      goal = Goal.new(user: nil)
      expect(goal).not_to be_valid
      expect(goal.errors[:user]).to include("must exist")
    end

    it 'defaults progress to 0' do
      user = User.create!(email: 'test@example.com', password: 'password', first_name: 'John', last_name: 'Doe')
      goal = Goal.create!(title: 'Sample Goal', description: 'Sample Description', user: user)
      expect(goal.progress).to eq(0)
    end
  end
end
