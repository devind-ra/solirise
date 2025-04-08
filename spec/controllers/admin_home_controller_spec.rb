require 'rails_helper'

RSpec.describe AdminHomeController, type: :controller do
    let(:admin_user) { User.create!(email: 'admin@example.com', password: 'password', first_name: 'Admin', last_name: 'User', role: 'admin') }
    let(:regular_user) { User.create!(email: 'user@example.com', password: 'password', first_name: 'Regular', last_name: 'User', role: 'user') }

    describe 'GET #index' do
        context 'when the user is an admin' do
            before do
                sign_in admin_user
            end

        it 'returns a successful response' do
            get :index
            expect(response).to have_http_status(:success)
        end

        it 'assigns @appraisals' do
            appraisal = Appraisal.create!(title: 'Sample Appraisal', user: admin_user)
            get :index
            expect(assigns(:appraisals)).to include(appraisal)
        end
    end

    context 'when the user is not an admin' do
      before do
        sign_in regular_user
      end

      it 'redirects to the home page with an alert' do
        get :index
        expect(response).to redirect_to(home_path)
        expect(flash[:alert]).to eq('You are not authorised to view the admin page')
      end
    end
  end

  describe 'POST #switch_to_admin' do
    before do
      sign_in admin_user
    end

    it 'sets admin_mode to true in the session' do
      post :switch_to_admin
      expect(session[:admin_mode]).to be true
    end

    it 'redirects to the admin home index path' do
      post :switch_to_admin
      expect(response).to redirect_to(admin_home_index_path)
    end
  end

  describe 'POST #switch_to_user' do
    before do
      sign_in admin_user
    end

    it 'sets admin_mode to false in the session' do
      post :switch_to_user
      expect(session[:admin_mode]).to be false
    end

    it 'redirects to the home path' do
      post :switch_to_user
      expect(response).to redirect_to(home_path)
    end
  end
end
