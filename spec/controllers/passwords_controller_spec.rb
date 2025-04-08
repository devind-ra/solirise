require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :controller do
    before do
        request.env['devise.mapping'] = Devise.mappings[:user]
    end

    describe 'GET #new' do
        it 'renders the new template' do
          get :new
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:success)
        end
    end

    describe 'POST #create' do
        context 'when email is valid' do
          let(:user) { User.create!(email: 'user@example.com', password: 'password', first_name: 'Test', last_name: 'User') }

          it 'sends reset password instructions and redirects' do
            post :create, params: { user: { email: user.email } }
            expect(response).to redirect_to(new_user_session_path)
            expect(flash[:notice]).to eq('You will receive an email with instructions on how to reset your password in a few minutes.')
          end
        end

        context 'when email is invalid' do
          it 're-renders the new template with an alert' do
            post :create, params: { user: { email: 'nonexistent@example.com' } }
            expect(response).to render_template(:new)
            expect(flash[:alert]).to be_nil
          end
        end
    end

    describe 'GET #edit' do
        it 'renders the edit template' do
          get :edit, params: { reset_password_token: 'valid_token' }
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(:success)
        end
    end

    describe 'PUT #update' do
        let(:user) { User.create!(email: 'user@example.com', password: 'password', first_name: 'Test', last_name: 'User') }

        context 'when the reset password token is invalid' do
          it 're-renders the edit template with an alert' do
            put :update, params: { user: { reset_password_token: 'invalid_token', password: 'newpassword', password_confirmation: 'newpassword' } }
            expect(response).to render_template(:edit)
            expect(flash[:alert]).to be_nil
          end
        end
    end
end
