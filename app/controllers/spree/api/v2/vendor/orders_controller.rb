# frozen_string_literal: true

module Spree
  module Api
    module V2
      module Vendor
        class OrdersController < VendorBaseController
          before_action :load_vendor
          before_action :require_vendor_access

          # GET /api/v2/vendor/vendors/:vendor_id/orders
          def index
            render_serialized_payload { serialize_collection(paginated_collection) }
          end

          private

          def serialize_collection(collection)
            collection_serializer.new(collection).serializable_hash
          end

          def paginated_collection
            collection_paginator.new(Spree::Order.for_vendor(@vendor), params).call
          end

          def collection_serializer
            Spree::V2::Vendor::OrderSerializer
          end

          def resource_serializer
            Spree::V2::Vendor::OrderSerializer
          end
        end
      end
    end
  end
end
