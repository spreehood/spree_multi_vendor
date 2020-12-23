module SpreeMultiVendor
  module V2
    module Storefront
      module ProductSerializerDecorator
        def self.prepended(base)
          base.belongs_to :vendor, serializer: ::Spree::V2::Storefront::VendorSerializer
        end
      end
    end
  end
end

Spree::V2::Storefront::ProductSerializer.prepend(SpreeMultiVendor::V2::Storefront::ProductSerializerDecorator)
