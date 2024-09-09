# frozen_string_literal: true

require 'spec_helper'

describe Spree::Api::V2::Vendor::OrdersController, type: :request do
  let!(:vendor) { create(:active_vendor) }
  let!(:completed_order) { create(:order, completed_at: 2.days.ago) }
  let!(:incomplete_order) { create(:order, completed_at: nil) }
  let!(:other_order) { create(:order, completed_at: 2.days.ago) }
  let!(:product) { create(:product_in_stock, vendor: vendor) }
  let!(:other_product) { create(:product_in_stock) }
  let!(:line_item) { create(:line_item, order: completed_order, product: product, variant: product.master) }
  let!(:other_line_item) do
    create(:line_item, order: other_order, product: other_product, variant: other_product.master)
  end

  before do
    allow_any_instance_of(described_class).to receive(:require_vendor_access).and_return(true)
  end

  describe '#index' do
    let(:base_url) { "/api/v2/vendor/vendors/#{vendor.id}/orders" }
    let(:params) { { q: {} } }

    context 'with no parameters' do
      it 'returns all completed orders for the vendor' do
        get base_url, params: params
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(1)
        expect(json_response['data'].first['id']).to eq(completed_order.id.to_s)
      end
    end

    context 'with search parameters' do
      it 'filters by order number' do
        params[:q][:number_cont] = completed_order.number
        get base_url, params: params
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(1)
        expect(json_response['data'].first['id']).to eq(completed_order.id.to_s)

        params[:q][:number_cont] = "#{completed_order.number}1"
        get base_url, params: params
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(0)
      end

      it 'filters by date range' do
        params[:q][:created_at_gt] = 3.days.ago.strftime('%Y-%m-%d %H:%M:%S')
        params[:q][:created_at_lt] = 1.day.ago.strftime('%Y-%m-%d %H:%M:%S')
        get base_url, params: params
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(1)
        expect(json_response['data'].first['id']).to eq(completed_order.id.to_s)

        params[:q][:created_at_gt] = 4.days.ago.strftime('%Y-%m-%d %H:%M:%S')
        params[:q][:created_at_lt] = 3.day.ago.strftime('%Y-%m-%d %H:%M:%S')
        get base_url, params: params
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(0)
      end

      it 'filters by state' do
        completed_order.update(state: 'complete')
        params[:q][:state_eq] = 'complete'
        get base_url, params: params
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(1)
        expect(json_response['data'].first['id']).to eq(completed_order.id.to_s)

        params[:q][:state_eq] = 'cancelled'
        get base_url, params: params
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(0)
      end

      it 'filters by email' do
        params[:q][:email_cont] = completed_order.email
        get base_url, params: params
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(1)
        expect(json_response['data'].first['id']).to eq(completed_order.id.to_s)

        params[:q][:email_cont] = 'random@mail.com'
        get base_url, params: params
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(0)
      end

      it 'filters by product SKU' do
        params[:q][:line_items_variant_sku_eq] = product.master.sku
        get base_url, params: params
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(1)
        expect(json_response['data'].first['id']).to eq(completed_order.id.to_s)

        params[:q][:line_items_variant_sku_eq] = "#{product.master.sku}1"
        get base_url, params: params
        json_response = JSON.parse(response.body)
        expect(json_response['data'].count).to eq(0)
      end
    end
  end
end
