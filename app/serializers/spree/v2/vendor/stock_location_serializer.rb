module Spree
  module V2
    module Vendor
      class StockLocationSerializer < Spree::Api::V2::BaseSerializer
        set_type :stock_location

        attributes :id, :name, :default, :address1, :address2, :city, :state_id, :state_name, :country_id,
                   :zipcode, :phone, :active, :backorderable_default, :propagate_all_variants, :admin_name,
                   :phone, :created_at

        belongs_to :vendor, serializer: Spree::V2::Storefront::VendorSerializer
        belongs_to :country, serializer: Spree::V2::Storefront::CountrySerializer
      end
    end
  end
end
