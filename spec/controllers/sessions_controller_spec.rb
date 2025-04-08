require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
    before do
        request.env['devise.mapping'] = Devise.mappings[:user]
    end

    describe 'GET #new' do
    it 'assigns @disable_nav to true' do
      get :new
      expect(assigns(:disable_nav)).to be true
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'returns a successful response' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
end