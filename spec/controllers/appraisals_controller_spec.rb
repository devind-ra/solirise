require 'rails_helper'

RSpec.describe AppraisalsController, type: :controller do
    let(:admin_user) { User.create!(email: 'admin@example.com', password: 'password', first_name: 'Admin', last_name: 'User', role: 'admin') }
    let(:regular_user) { User.create!(email: 'user@example.com', password: 'password', first_name: 'Regular', last_name: 'User', role: 'user') }
    let(:appraisal) { Appraisal.create!(title: 'Sample Appraisal', user: admin_user) }

    before do
        sign_in admin_user
    end

    describe 'GET #new' do
        context 'when the user is an admin' do
            it 'assigns a new appraisal' do
                get :new
                expect(assigns(:appraisal)).to be_a_new(Appraisal)
            end
        end

        context 'when the user is not an admin' do
            before do
                sign_out admin_user
                sign_in regular_user
            end

            it 'redirects to the home page with an alert' do
                get :new
                expect(response).to redirect_to(home_path)
                expect(flash[:alert]).to eq('You are not authorised to perform this action')
            end
        end
    end

    describe 'POST #create' do
        context 'with valid parameters' do
            it 'creates a new appraisal and redirects to admin home index' do
                expect {
                    post :create, params: { appraisal: { title: 'New Appraisal' }, user_id: admin_user.id }
                }.to change(Appraisal, :count).by(1)

                expect(response).to redirect_to(admin_home_index_path)
                expect(flash[:notice]).to eq("Appraisal created for Admin User.")
            end
        end

        context 'with invalid parameters' do
            it 'renders the new template with an alert' do
                post :create, params: { appraisal: { title: '' } }
                expect(response).to render_template(:new)
                expect(flash[:alert]).to eq('Failed to create appraisal.')
            end
        end
    end

    describe 'GET #view' do
        it 'assigns the current user’s appraisals' do
        appraisal1 = Appraisal.create!(title: 'Appraisal 1', user: admin_user)
        appraisal2 = Appraisal.create!(title: 'Appraisal 2', user: admin_user)

        get :view
        expect(assigns(:appraisals)).to match_array([ appraisal1, appraisal2 ])
        end
    end

    describe 'DELETE #destroy' do
        context 'when the appraisal is successfully deleted' do
            it 'deletes the appraisal and redirects to admin home index' do
                appraisal_to_delete = Appraisal.create!(title: 'Appraisal to Delete', user: admin_user)

                expect {
                    delete :destroy, params: { id: appraisal_to_delete.id }
                }.to change(Appraisal, :count).by(-1)

                expect(response).to redirect_to(admin_home_index_path)
                expect(flash[:notice]).to eq('Appraisal successfully deleted.')
            end
        end

        context 'when the appraisal cannot be deleted' do
            it 'redirects to admin home index with an alert' do
                allow_any_instance_of(Appraisal).to receive(:destroy).and_return(false)

                delete :destroy, params: { id: appraisal.id }
                expect(response).to redirect_to(admin_home_index_path)
                expect(flash[:alert]).to eq('Failed to delete appraisal.')
            end
        end
    end
end
