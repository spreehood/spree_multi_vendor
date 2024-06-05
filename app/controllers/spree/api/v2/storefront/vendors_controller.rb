module Spree
  module Api
    module V2
      module Storefront
        class VendorsController < ::Spree::Api::V2::ResourceController
          before_action :require_spree_current_user, only: %i[create update destroy]
          before_action :load_vendor, only: %i[update destroy]

          def create
            vendor = Spree::Vendor.new(vendor_params)
            vendor.state = 'pending'
            if vendor.save
              create_vendor_user(vendor)
              render_serialized_payload { serialize_resource(vendor) }
            else
              render_error_payload(vendor.errors)
            end
          end

          def update
            if @vendor.users.include?(spree_current_user) && @vendor.update(vendor_params)
              render_serialized_payload { serialize_resource(@vendor) }
            else
              render_error_payload(@vendor.errors)
            end
          end

          def destroy
            if @vendor.users.include?(spree_current_user) && @vendor.destroy
              render_serialized_payload { serialize_resource(@vendor) }
            else
              render_error_payload(@vendor.errors)
            end
          end

          private

          def model_class
            ::Spree::Vendor
          end

          def scope
            ::Spree::Vendor.active
          end

          def resource
            scope.find_by(slug: params[:id]) || scope.find(params[:id])
          end

          def resource_serializer
            Spree::V2::Storefront::VendorSerializer
          end

          def collection_serializer
            Spree::V2::Storefront::VendorSerializer
          end

          def vendor_params
            params.require(:vendor).permit(Spree::PermittedAttributes.vendor_attributes)
          end

          def load_vendor
            @vendor = Spree::Vendor.find(params[:id])
          end

          def create_vendor_user(vendor)
            Spree::VendorUser.create(vendor_id: vendor.id, user_id: spree_current_user.id)
          end
        end
      end
    end
  end
end