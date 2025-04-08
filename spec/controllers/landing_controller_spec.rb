require 'rails_helper'

RSpec.describe LandingController, type: :controller do
    describe 'GET #index' do
    it 'assigns @disable_nav to true' do
      get :index
      expect(assigns(:disable_nav)).to be true
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end