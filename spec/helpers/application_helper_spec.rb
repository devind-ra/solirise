require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#soli_brand_link_path' do
    let(:user) { instance_double(User) }

    context 'when the user is an admin and admin_mode is enabled' do
      it 'returns the admin home index path' do
        allow(helper).to receive(:current_user).and_return(user)
        allow(user).to receive(:admin?).and_return(true)
        allow(helper).to receive(:session).and_return({ admin_mode: true })

        expect(helper.soli_brand_link_path).to eq(admin_home_index_path)
      end
    end

    context 'when the user is an admin but admin_mode is disabled' do
      it 'returns the home path' do
        allow(helper).to receive(:current_user).and_return(user)
        allow(user).to receive(:admin?).and_return(true)
        allow(helper).to receive(:session).and_return({ admin_mode: false })

        expect(helper.soli_brand_link_path).to eq(home_path)
      end
    end

    context 'when the user is not an admin' do
      it 'returns the home path' do
        allow(helper).to receive(:current_user).and_return(user)
        allow(user).to receive(:admin?).and_return(false)

        expect(helper.soli_brand_link_path).to eq(home_path)
      end
    end

    context 'when there is no current user' do
      it 'returns the home path' do
        allow(helper).to receive(:current_user).and_return(nil)

        expect(helper.soli_brand_link_path).to eq(home_path)
      end
    end
  end
end
