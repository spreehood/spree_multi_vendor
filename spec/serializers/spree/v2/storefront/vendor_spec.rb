require 'spec_helper'

describe 'API V2 Storefront Vendor Spec', type: :request do

  describe 'products#show' do
    context 'without specified params' do
      before { get '/api/v2/storefront/vendors/talking_store'}

      it_behaves_like 'returns 404 HTTP status'
    end

    context 'with specified params' do
      let!(:vendor){create(:active_vendor, name: 'talking_store')}

      before { get '/api/v2/storefront/vendors/talking_store'}

      it_behaves_like 'returns 200 HTTP status'

      it 'returns one vendor' do
        json_response = JSON.parse(response.body)
        expect(json_response.count).to eq 1
        expect(json_response['data']['type']).to eq('vendor')
      end

      it 'does not return included' do
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to contain_exactly('data')
      end
    end

    context 'with products and images included' do
      let!(:vendor){create(:active_vendor, name: 'talking_store')}
      let!(:product){create(:product, vendor: vendor)}

      before { get '/api/v2/storefront/vendors/talking_store?include=products,image'}

      it_behaves_like 'returns 200 HTTP status'

      it 'returns product information' do
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to contain_exactly('data', 'included')
        expect(json_response['included'].first['id']).to eq(product.id.to_s)
      end
    end
  end
end