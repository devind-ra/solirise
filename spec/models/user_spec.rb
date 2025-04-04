require 'rails_helper'

RSpec.describe User, type: :model do
    subject(:user) { build(:user) }

    describe 'validations' do
        it 'validates presence of first name' do
            user.first_name = nil
            expect(user).not_to be_valid
            expect(user.errors[:first_name]).to include("can't be blank")
        end

        it 'validates presence of last name' do
            user.last_name = nil
            expect(user).not_to be_valid
            expect(user.errors[:last_name]).to include("can't be blank")
        end

        it 'validates format of first name' do
            user.first_name = 'John123'
            expect(user).not_to be_valid
            expect(user.errors[:first_name]).to include("only allows letters, spaces, hyphens, and apostrophes")
        end

        it 'validates format of last name' do
            user.last_name = 'Doe123'
            expect(user).not_to be_valid
            expect(user.errors[:last_name]).to include("only allows letters, spaces, hyphens, and apostrophes")
        end

        it 'validates uniqueness of email' do
            create(:user, email:"test@example.com")
            user.email = 'test@example.com'
            expect(user).not_to be_valid
            expect(user.errors[:email]).to include('has already been taken')
        end
    end

    # describe 'admin-role' do
    #     it 'returns true if the user is an admin' do
    #         user.role = 'admin'
    #         expect(user.admin?).to be true
    #     end

    #     it 'returns false if the user is not an admin' do
    #         user.role = 'user'
    #         expect(user.admin?).to be false
    #     end
    # end
end
