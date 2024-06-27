require 'spec_helper'

describe Spree::Api::V2::Storefront::Account::UserVendorsController, type: :request do
  let!(:vendor) { create(:active_vendor) }
  let!(:user) { create(:user) }
  let!(:vendor_user) { create(:vendor_user, vendor: vendor, user: user) }

  before do
    create(:vendor_user, vendor: create(:active_vendor, name: 'Test Vendor'), user: user)

    allow_any_instance_of(described_class).to receive(:require_spree_current_user).and_return(true)
    allow_any_instance_of(described_class).to receive(:spree_current_user).and_return(user)
  end

  describe '#index' do
    it 'returns the list of vendors associated with the user' do
      get "/api/v2/storefront/account/vendors"
      json_response = JSON.parse(response.body)

      expect(json_response['data'].count).to eq(2)
    end
  end
end
