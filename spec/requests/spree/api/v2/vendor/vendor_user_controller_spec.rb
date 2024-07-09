require 'spec_helper'

describe Spree::Api::V2::Vendor::VendorUsersController, type: :request do
  let!(:vendor) { create(:active_vendor) }
  let!(:user) { create(:user) }
  let!(:vendor_user) { create(:vendor_user, vendor: vendor, user: user) }

  before do
    allow_any_instance_of(described_class).to receive(:require_vendor_access).and_return(true)
  end

  describe '#index' do
    it 'returns the list of users associated with the vendor' do
      get "/api/v2/vendor/vendors/#{vendor.id}/users"
      json_response = JSON.parse(response.body)

      expect(json_response['data'].count).to eq(1)
      expect(json_response['data'].first['id']).to eq(vendor_user.id.to_s)
    end
  end

  describe '#create' do
    let(:new_user) { create(:user) }

    it 'creates a new vendor user' do
      post "/api/v2/vendor/vendors/#{vendor.id}/users", params: { vendor_user: { email: new_user.email } }
      json_response = JSON.parse(response.body)

      expect(json_response['data']['attributes']['user_id']).to eq(new_user.id)
      expect(json_response['data']['attributes']['vendor_id']).to eq(vendor.id)
    end
  end

  describe '#destroy' do
    let(:new_vendor_user) { create(:vendor_user, vendor: vendor, user: create(:user)) }

    it 'deletes the vendor user' do
      delete "/api/v2/vendor/vendors/#{vendor.id}/users/#{new_vendor_user.id}"
      json_response = JSON.parse(response.body)

      expect(json_response['data']['id']).to eq(new_vendor_user.id.to_s)
    end
  end
end
