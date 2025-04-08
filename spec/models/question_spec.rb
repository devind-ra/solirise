require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it 'belongs to a category' do
      category = Category.create(name: 'Sample Category')
      question = Question.create(content: 'Sample Question', category: category)
      expect(question.category).to eq(category)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      category = Category.create(name: 'Sample Category')
      question = Question.new(content: 'Sample Question', category: category)
      expect(question).to be_valid
    end

    it 'is invalid without content' do
      category = Category.create(name: 'Sample Category')
      question = Question.new(content: nil, category: category)
      expect(question).not_to be_valid
      expect(question.errors[:content]).to include("can't be blank")
    end

    it 'is invalid without a category' do
      question = Question.new(content: 'Sample Question', category: nil)
      expect(question).not_to be_valid
      expect(question.errors[:category]).to include('must exist')
    end

    it 'is invalid with blank content' do
      category = Category.create!(name: 'Sample Category')
      question = Question.new(content: '', category: category)
      expect(question).not_to be_valid
      expect(question.errors[:content]).to include("can't be blank")
    end

    it 'is invalid with only whitespace content' do
      category = Category.create!(name: 'Sample Category')
      question = Question.new(content: '   ', category: category)
      expect(question).not_to be_valid
      expect(question.errors[:content]).to include("can't be blank")
    end
  end
end
