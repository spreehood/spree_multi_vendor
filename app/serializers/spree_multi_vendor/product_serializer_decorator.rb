module SpreeMultiVendor
  module ProductSerializerDecorator
    def self.prepended(base)
      base.has_many :videos,
                    serializer: ::Spree::Api::V2::VideoSerializer,
                    record_type: :video
    end
  end
end

# Prepend the decorator to the ProductSerializer
Spree::V2::Storefront::ProductSerializer.prepend(SpreeMultiVendor::ProductSerializerDecorator)