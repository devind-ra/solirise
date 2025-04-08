require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
    let(:user) { User.create!(email: 'user@example.com', password: 'password', first_name: 'Test', last_name: 'User') }
    let(:goal) { Goal.create!(title: 'Sample Goal', description: 'Sample Description', progress: 50, user: user) }

    before do
      sign_in user
    end

    describe 'GET #index' do
      it 'assigns all goals to @goals' do
        goal1 = Goal.create!(title: 'Goal 1', description: 'Description 1', progress: 10, user: user)
        goal2 = Goal.create!(title: 'Goal 2', description: 'Description 2', progress: 20, user: user)

        get :index
        expect(assigns(:goals)).to match_array([ goal1, goal2 ])
      end
    end

    describe 'GET #new' do
      it 'assigns a new goal to @goal' do
        get :new
        expect(assigns(:goal)).to be_a_new(Goal)
      end
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        it 'creates a new goal and redirects to the goals index' do
            expect {
                post :create, params: { goal: { title: 'New Goal', description: 'New Description', progress: 30 } }
            }.to change(Goal, :count).by(1)

            expect(response).to redirect_to(goals_path)
            expect(flash[:notice]).to eq('Goal was successfully created.')
        end
      end

      context 'with invalid parameters' do
        it 'renders the new template' do
            post :create, params: { goal: { title: '', description: 'New Description', progress: 30 } }
            expect(response).to render_template(:new)
            expect(flash[:alert]).to eq('Failed to create goal.')
        end
      end
    end

    describe 'GET #edit' do
        context 'when the user is not the owner or an admin' do
            let(:other_user) { User.create!(email: 'other@example.com', password: 'password', first_name: 'Other', last_name: 'User') }
            let(:other_goal) { Goal.create!(title: 'Other Goal', description: 'Other Description', progress: 20, user: other_user) }

            before do
                sign_in user
            end

            it 'redirects to the goals index with an alert' do
                get :edit, params: { id: other_goal.id }
                expect(response).to redirect_to(goals_path)
                expect(flash[:alert]).to eq('You are not authorised to perform this action.')
            end
        end
    end

    describe 'PATCH #update' do
      context 'with valid parameters' do
        it 'updates the goal and redirects to the goals index' do
            patch :update, params: { id: goal.id, goal: { title: 'Updated Goal' } }
            goal.reload
            expect(goal.title).to eq('Updated Goal')
            expect(response).to redirect_to(goals_path)
            expect(flash[:notice]).to eq('Goal updated!')
        end
      end

      context 'with invalid parameters' do
        it 'renders the edit template' do
            patch :update, params: { id: goal.id, goal: { title: '' } }
            expect(response).to render_template(:edit)
            expect(flash[:alert]).to eq('Failed to update goal.')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes the goal and redirects to the goals index' do
        goal_to_delete = Goal.create!(title: 'Goal to Delete', description: 'Description', progress: 10, user: user)

        expect {
          delete :destroy, params: { id: goal_to_delete.id }
        }.to change(Goal, :count).by(-1)

        expect(response).to redirect_to(goals_path)
        expect(flash[:notice]).to eq('Goal was successfully removed.')
      end
    end
end
