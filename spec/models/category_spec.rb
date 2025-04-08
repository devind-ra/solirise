require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it 'has many questions' do
      category = Category.create!(name: 'Consultant behaviour', page: 1)
      question1 = Question.create!(content: 'Question 1', category: category)
      question2 = Question.create!(content: 'Question 2', category: category)

      expect(category.questions).to include(question1, question2)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      category = Category.new(name: 'Consultant behaviour', page: 1)
      expect(category).to be_valid
    end

    it 'is valid without a page' do
      category = Category.new(name: 'Consultant behaviour', page: nil)
      expect(category).to be_valid
    end
  end

  describe 'seeded data' do
    before(:all) do
      Rails.application.load_seed
    end

    it 'creates categories with associated questions' do
      category = Category.find_by(name: 'Consultant behaviour')
      expect(category).not_to be_nil
      expect(category.questions.count).to eq(8)
      expect(category.questions.pluck(:content)).to include(
        '1) Has demonstrated analytical thinking, attention to detail, and critical/creative thinking skills for problem solving. (Problem-solving)',
        '2) Has showcased a high degree of readiness and is responsible for taking action points to completion. (Meetings/workshops)'
      )
    end

    it 'creates categories without questions' do
      category = Category.find_by(name: 'General Feedback')
      expect(category).not_to be_nil
      expect(category.questions).to be_empty
    end
  end
end
