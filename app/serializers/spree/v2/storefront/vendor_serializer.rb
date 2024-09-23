module Spree
  module V2
    module Storefront
      class VendorSerializer < BaseSerializer
        set_type :vendor

        attributes :name, :about_us, :slug, :contact_us, :state, :notification_email

        has_one :image, serializer: :vendor_image
        has_many :products do |vendor|
          vendor.products.where(status: 'active')
        end
      end
    end
  end
end
