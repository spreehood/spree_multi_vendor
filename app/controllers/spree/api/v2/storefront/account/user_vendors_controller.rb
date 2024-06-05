module Spree
  module Api
    module V2
      module Storefront
        module Account
          class UserVendorsController < Spree::Api::V2::ResourceController
            before_action :require_spree_current_user

            def index
              render_serialized_payload { serialize_collection(paginated_collection) }
            end

            private

            def resource
              resource_finder.user_vendors(spree_current_user)
            end

            def collection_serializer
              Spree::V2::Storefront::VendorSerializer
            end

            def paginated_collection
              collection_paginator.new(resource, params).call
            end

            def resource_finder
              Spree::Vendor
            end
          end
        end
      end
    end
  end
end
