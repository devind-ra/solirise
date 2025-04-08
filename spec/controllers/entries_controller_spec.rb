require 'rails_helper'

RSpec.describe EntriesController, type: :controller do
    let(:user) { User.create!(email: 'user@example.com', password: 'password', first_name: 'Test', last_name: 'User') }
    let(:admin) { User.create!(email: 'admin@example.com', password: 'password', first_name: 'Admin', last_name: 'User', role: 'admin') }
    let(:appraisal) { Appraisal.create!(title: 'Sample Appraisal', user: user) }
    let(:entry) { Entry.create!(appraisal: appraisal, answers: { '1' => 'Answer 1', '2' => '' }) }

    before do
      sign_in user
    end

    describe 'GET #new' do
        it 'assigns a new entry and categories' do
            get :new, params: { appraisal_id: appraisal.id }
            expect(assigns(:entry)).to be_a_new(Entry)
            expect(assigns(:categories)).to eq(Category.includes(:questions))
        end
    end

    describe 'POST #create' do
        context 'when answers are incomplete' do
            it 'saves the entry as a draft and redirects to home' do
                post :create, params: { appraisal_id: appraisal.id, entry: { answers: { '1' => '', '2' => 'Answer 2' } } }
                expect(Entry.last.answers).to eq({ '1' => '', '2' => 'Answer 2' })
                expect(response).to redirect_to(home_path)
                expect(flash[:notice]).to eq('Entry saved as draft. You can continue filling out the answers.')
            end
        end

        context 'when answers are complete' do
            it 'saves the entry and redirects to home' do
                post :create, params: { appraisal_id: appraisal.id, entry: { answers: { '1' => 'Answer 1', '2' => 'Answer 2' } } }
                expect(Entry.last.answers).to eq({ '1' => 'Answer 1', '2' => 'Answer 2' })
                expect(response).to redirect_to(home_path)
                expect(flash[:notice]).to eq('Entry submitted successfully!')
            end
        end

        context 'when save fails' do
            it 'renders the new template' do
                allow_any_instance_of(Entry).to receive(:save).and_return(false)
                post :create, params: { appraisal_id: appraisal.id, entry: { answers: { '1' => 'Answer 1', '2' => 'Answer 2' } } }
                expect(response).to render_template(:new)
            end
        end
    end

    describe 'GET #view' do
        context 'when appraisal_id is provided' do
            it 'assigns the last entry of the appraisal and categories' do
                get :view, params: { appraisal_id: appraisal.id, id: entry.id }
                expect(assigns(:entry)).to eq(appraisal.entries.last)
                expect(assigns(:categories)).to eq(Category.includes(:questions))
            end
        end

        context 'when appraisal_id is not provided' do
            it 'assigns the entry, appraisal, and categories' do
                get :view, params: { appraisal_id: appraisal.id, id: entry.id }
                expect(assigns(:entry)).to eq(entry)
                expect(assigns(:appraisal)).to eq(entry.appraisal)
                expect(assigns(:categories)).to eq(Category.includes(:questions))
            end
        end
    end

    describe 'GET #edit' do
        it 'assigns categories' do
            get :edit, params: { appraisal_id: appraisal.id, id: entry.id }
            expect(assigns(:categories)).to eq(Category.includes(:questions))
        end
    end

    describe 'PATCH #update' do
        context 'when answers are incomplete' do
            it 'saves the entry as a draft and redirects to home' do
                patch :update, params: { id: entry.id, appraisal_id: appraisal.id, entry: { answers: { '1' => '', '2' => 'Answer 2' } } }
                entry.reload
                expect(entry.answers).to eq({ '1' => '', '2' => 'Answer 2' })
                expect(response).to redirect_to(home_path)
                expect(flash[:notice]).to eq('Entry saved as draft. You can continue later.')
            end
        end

        context 'when answers are complete' do
            it 'saves the entry and redirects to home' do
                patch :update, params: { id: entry.id, appraisal_id: appraisal.id, entry: { answers: { '1' => 'Answer 1', '2' => 'Answer 2' } } }
                entry.reload
                expect(entry.answers).to eq({ '1' => 'Answer 1', '2' => 'Answer 2' })
                expect(response).to redirect_to(home_path)
                expect(flash[:notice]).to eq('Entry submitted successfully!')
            end
        end

        context 'when update fails' do
            it 'renders the edit template' do
                allow_any_instance_of(Entry).to receive(:update).and_return(false)
                patch :update, params: { id: entry.id, appraisal_id: appraisal.id, entry: { answers: { '1' => 'Answer 1', '2' => 'Answer 2' } } }
                expect(response).to render_template(:edit)
            end
        end
    end

    describe 'DELETE #destroy' do
        it 'deletes the entry and redirects to home' do
            entry_to_delete = Entry.create!(appraisal: appraisal, answers: { '1' => 'Answer 1' })
            expect {
                delete :destroy, params: { appraisal_id: appraisal.id, id: entry_to_delete.id }
            }.to change(Entry, :count).by(-1)
            expect(response).to redirect_to(home_path)
        end
    end

    describe 'GET #download' do
        it 'responds with a PDF file' do
            get :download, params: { appraisal_id: appraisal.id, id: entry.id, format: :pdf }
            expect(response.content_type).to eq('application/pdf')
            expect(response.headers['Content-Disposition']).to include('attachment')
        end
    end

    describe 'Authorisation (authorise_user!)' do
        context 'when the user is an admin' do
          before do
            sign_in admin
          end

          it 'allows access to the action' do
            get :edit, params: { appraisal_id: appraisal.id, id: entry.id }
            expect(response).to have_http_status(:success)
          end
        end

        context 'when the user is the owner of the appraisal' do
          before do
            sign_in user
          end

          it 'allows access to the action' do
            get :edit, params: { appraisal_id: appraisal.id, id: entry.id }
            expect(response).to have_http_status(:success)
          end
        end

        context 'when the user is neither an admin nor the owner' do
          let(:other_user) { User.create!(email: 'other@example.com', password: 'password', first_name: 'Other', last_name: 'User') }

          before do
            sign_in other_user
          end

          it 'redirects to home_path with an alert' do
            get :edit, params: { appraisal_id: appraisal.id, id: entry.id }
            expect(response).to redirect_to(home_path)
            expect(flash[:alert]).to eq('You are not authorised to access this page.')
          end
        end
    end
end
