require 'rails_helper'

RSpec.describe Appraisal, type: :model do
  describe 'associations' do
    it 'belongs to a user' do
      user = User.create!(email: 'test@example.com', password: 'password', first_name: 'John', last_name: 'Doe')
      appraisal = Appraisal.create!(title: 'Sample Appraisal', user: user)
      expect(appraisal.user).to eq(user)
    end

    it 'has many entries' do
      user = User.create!(email: 'test@example.com', password: 'password', first_name: 'John', last_name: 'Doe')
      appraisal = Appraisal.create!(title: 'Sample Appraisal', user: user)
      entry1 = Entry.create!(appraisal: appraisal, answers: {}, name: 'Entry 1')
      entry2 = Entry.create!(appraisal: appraisal, answers: {}, name: 'Entry 2')

      expect(appraisal.entries).to include(entry1, entry2)
    end

    it 'destroys associated entries when deleted' do
      user = User.create!(email: 'test@example.com', password: 'password', first_name: 'John', last_name: 'Doe')
      appraisal = Appraisal.create!(title: 'Sample Appraisal', user: user)
      Entry.create!(appraisal: appraisal, answers: {}, name: 'Entry 1')

      expect { appraisal.destroy }.to change { Entry.count }.by(-1)
    end
  end

  describe 'validations' do
    it 'is valid with a user' do
      user = User.create!(email: 'test@example.com', password: 'password', first_name: 'John', last_name: 'Doe')
      appraisal = Appraisal.new(title: 'Sample Appraisal', user: user)
      expect(appraisal).to be_valid
    end

    it 'is invalid without a user' do
      appraisal = Appraisal.new(title: 'Sample Appraisal', user: nil)
      expect(appraisal).not_to be_valid
      expect(appraisal.errors[:user]).to include('must exist')
    end
  end
end
