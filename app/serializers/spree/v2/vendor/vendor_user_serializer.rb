module Spree
  module V2
    module Vendor
      class VendorUserSerializer < Spree::Api::V2::BaseSerializer
        set_type :vendor_user

        attributes :id, :vendor_id, :user_id, :preferences

        belongs_to :user, serializer: Spree::V2::Storefront::UserSerializer
        belongs_to :vendor, serializer: Spree::V2::Storefront::VendorSerializer
      end
    end
  end
end
