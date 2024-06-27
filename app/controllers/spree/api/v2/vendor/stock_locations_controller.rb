module Spree
  module Api
    module V2
      module Vendor
        class StockLocationsController < VendorBaseController
          before_action :load_vendor
          before_action :require_vendor_access

          # GET /api/v2/vendor/vendors/:vendor_id/stock_locations
          def index
            render_serialized_payload { serialize_collection(paginated_collection) }
          end

          # GET /api/v2/vendor/vendors/:vendor_id/stock_locations/:id
          def show
            stock_location = Spree::StockLocation.find(params[:id])

            if stock_location
              render_serialized_payload { serialize_resource(stock_location) }
            else
              render_error_payload(stock_location.errors)
            end
          end

          # POST /api/v2/vendor/vendors/:vendor_id/stock_locations
          def create
            stock_location = @vendor.stock_locations.new(stock_location_params)

            if stock_location.save
              render_serialized_payload { serialize_resource(stock_location) }
            else
              render_error_payload(stock_location.errors)
            end
          end

          # PUT/PATCH /api/v2/vendor/vendors/:vendor_id/stock_locations/:id
          def update
            stock_location = Spree::StockLocation.find(params[:id])

            if stock_location.update(stock_location_params)
              render_serialized_payload { serialize_resource(stock_location) }
            else
              render_error_payload(stock_location.errors)
            end
          end

          # DELETE /api/v2/vendor/vendors/:vendor_id/stock_locations/:id
          def destroy
            stock_location = Spree::StockLocation.find(params[:id])

            if stock_location.destroy
              render_serialized_payload { serialize_resource(stock_location) }
            else
              render_error_payload(stock_location.errors)
            end
          end

          private

          def serialize_collection(collection)
            collection_serializer.new(collection, include: %i[vendor country]).serializable_hash
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
