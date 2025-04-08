require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
      controller do
        def dummy_action
          render plain: "OK"
        end
      end
    
      before do
        routes.draw { get 'dummy_action' => 'anonymous#dummy_action' }
      end
    
      describe '#after_sign_in_path_for' do
        it 'redirects to the home path after sign in' do
          expect(subject.after_sign_in_path_for(:user)).to eq(home_path)
        end
      end
    
      describe '#after_sign_up_path_for' do
        it 'redirects to the home path after sign up' do
          expect(subject.after_sign_up_path_for(:user)).to eq(home_path)
        end
      end
    
      describe '#after_sign_out_path_for' do
        it 'redirects to the root path after sign out' do
          expect(subject.after_sign_out_path_for(:user)).to eq(root_path)
        end
      end
    
      describe '#configure_permitted_parameters' do
        it 'permits additional parameters for sign up' do
          allow(controller).to receive(:devise_parameter_sanitizer).and_return(double('Sanitizer', permit: true))
          controller.send(:configure_permitted_parameters)
        end
    
        it 'permits additional parameters for account update' do
          allow(controller).to receive(:devise_parameter_sanitizer).and_return(double('Sanitizer', permit: true))
          controller.send(:configure_permitted_parameters)
        end
      end
end