require 'spec_helper'

describe Spree::Api::V2::Vendor::StockLocationsController, type: :request do
  let!(:vendor) { create(:active_vendor) }

  before do
    allow_any_instance_of(described_class).to receive(:require_vendor_access).and_return(true)
  end

  describe '#index' do
    it 'returns the list of stock locations associated with the vendor' do
      get "/api/v2/vendor/vendors/#{vendor.id}/stock_locations"
      json_response = JSON.parse(response.body)

      expect(json_response['data'].count).to eq(1)
      expect(json_response['data'].first['attributes']['name']).to eq(vendor.name)
    end
  end

  describe '#update' do
    it 'updates the stock location' do
      stock_location = vendor.stock_locations.first
      stock_location_params = { stock_location: { name: 'New name' } }

      put "/api/v2/vendor/vendors/#{vendor.id}/stock_locations/#{stock_location.id}", params: stock_location_params
      json_response = JSON.parse(response.body)

      expect(json_response['data']['attributes']['name']).to eq('New name')
    end
  end
end
