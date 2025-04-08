require 'rails_helper'

RSpec.describe Entry, type: :model do
    describe 'associations' do
        it 'belongs to an appraisal' do
            user = User.create!(email: 'test@example.com', password: 'password', first_name: 'Test', last_name: 'User')
            appraisal = Appraisal.create!(title: 'Sample Appraisal', user: user)
            entry = Entry.create!(appraisal: appraisal)
            expect(entry.appraisal).to eq(appraisal)
        end

    describe 'validations' do
        it 'is invalid without an appraisal' do
            entry = Entry.new(appraisal: nil)
            expect(entry).not_to be_valid
            expect(entry.errors[:appraisal]).to include("must exist")
        end
    end

    describe 'callbacks' do
        let(:user) { User.create!(email: 'test@example.com', password: 'password', first_name: 'Test', last_name: 'User') }
        let(:appraisal) { Appraisal.create!(title: 'Test Appraisal', user: user) }

        context 'after_create' do
          it 'updates the appraisal timestamp' do
            entry = Entry.create!(appraisal: appraisal)
            expect(appraisal.reload.updated_at).to be_within(1.second).of(entry.created_at)
          end
        end

        context 'after_update' do
          it 'updates the appraisal timestamp' do
            entry = Entry.create!(appraisal: appraisal)
            original_timestamp = appraisal.updated_at
            entry.update!(updated_at: Time.current + 1.hour)
            expect(appraisal.reload.updated_at).not_to eq(original_timestamp)
          end
        end
      end
    end
end
