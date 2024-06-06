module Spree
  module Api
    module V2
      module Vendor
        class StockLocationsController < Spree::Api::V2::ResourceController
          before_action :require_spree_current_user
          before_action :load_vendor

          # GET /api/v2/vendor/vendors/:vendor_id/stock_locations
          def index
            if check_vendor_access
              render_serialized_payload { serialize_collection(paginated_collection) }
            else
              render_error_payload(paginated_collection.errors)
            end
          end

          # GET /api/v2/vendor/vendors/:vendor_id/stock_locations/:id
          def show
            stock_location = Spree::StockLocation.find(params[:id])
            if stock_location && check_vendor_access
              render_serialized_payload { serialize_resource(stock_location) }
            else
              render_error_payload(stock_location.errors)
            end
          end

          # PUT/PATCH /api/v2/vendor/vendors/:vendor_id/stock_locations/:id
          def update
            stock_location = Spree::StockLocation.find(params[:id])
            if check_vendor_access && stock_location.update(stock_location_params)
              render_serialized_payload { serialize_resource(stock_location) }
            else
              render_error_payload(stock_location.errors)
            end
          end

          private

          def load_vendor
            @vendor = Spree::Vendor.find(params[:vendor_id])
          end

          def check_vendor_access
            @vendor.users.include?(spree_current_user)
          end

          def paginated_collection
            collection_paginator.new(@vendor.stock_locations, params).call
          end

          def collection_serializer
            Spree::V2::Vendor::StockLocationSerializer
          end

          def resource_serializer
            Spree::V2::Vendor::StockLocationSerializer
          end

          def stock_location_params
            params.require(:stock_location).permit(Spree::PermittedAttributes.stock_location_attributes)
          end
        end
      end
    end
  end
end
