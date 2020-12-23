module Spree
  module V2
    module Storefront
      class VendorSerializer < BaseSerializer
        set_type :vendor

        attributes :name, :about_us, :slug, :state, :contact_us

        has_one :image
        has_many :products
      end
    end
  end
end
