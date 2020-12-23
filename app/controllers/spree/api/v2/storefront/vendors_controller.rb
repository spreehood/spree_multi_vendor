module Spree
  module Api
    module V2
      module Storefront
        class VendorsController < ::Spree::Api::V2::BaseController
          def show
            render_serialized_payload { serialize_resource(resource) }
          end

          private

          def scope
            Spree::Vendor
          end

          def resource
            scope.find_by(slug: params[:id]) || scope.find(params[:id])
          end

          def resource_serializer
            Spree::V2::Storefront::VendorSerializer
          end
        end
      end
    end
  end
end
