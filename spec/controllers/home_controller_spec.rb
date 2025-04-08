require 'rails_helper'

RSpec.describe HomeController, type: :controller do
    let(:user) { User.create!(email: 'user@example.com', password: 'password', first_name: 'Test', last_name: 'User') }
    let(:appraisal_with_no_entries) { Appraisal.create!(title: 'No Entries Appraisal', user: user) }
    let(:appraisal_with_blank_answers) do
      appraisal = Appraisal.create!(title: 'Blank Answers Appraisal', user: user)
      Entry.create!(appraisal: appraisal, answers: { '1' => '', '2' => 'Answer 2' })
      appraisal
    end
    let(:completed_appraisal) do
      appraisal = Appraisal.create!(title: 'Completed Appraisal', user: user)
      Entry.create!(appraisal: appraisal, answers: { '1' => 'Answer 1', '2' => 'Answer 2' })
      appraisal
    end
  
    before do
      sign_in user
    end
  
    describe 'GET #index' do
      it 'assigns @appraisals for the current user' do
        appraisal_with_no_entries
        appraisal_with_blank_answers
        completed_appraisal
  
        get :index
        expect(assigns(:appraisals)).to match_array([appraisal_with_no_entries, appraisal_with_blank_answers, completed_appraisal])
      end
  
      it 'assigns @pending_appraisals with appraisals that have no entries or blank answers' do
        appraisal_with_no_entries
        appraisal_with_blank_answers
        completed_appraisal
  
        get :index
        expect(assigns(:pending_appraisals)).to match_array([appraisal_with_no_entries, appraisal_with_blank_answers])
      end
    end 
end