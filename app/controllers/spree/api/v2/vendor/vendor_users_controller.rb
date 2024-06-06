module Spree
  module Api
    module V2
      module Vendor
        class VendorUsersController < VendorBaseController
          before_action :load_vendor
          before_action :require_vendor_access

          # GET /api/v2/vendor/vendors/:vendor_id/users
          def index
            render_serialized_payload { serialize_collection(paginated_collection) }
          end

          # POST /api/v2/vendor/vendors/:vendor_id/users
          def create
            user = Spree::User.find_by(email: vendor_user_params[:email])

            if user
              create_vendor_user(user)
            else
              render_error_payload('Please ')
            end
          end

          # DELETE /api/v2/vendor/vendors/:vendor_id/users/:id
          def destroy
            vendor_user = Spree::VendorUser.find(params[:id])
            if vendor_user&.destroy
              render_serialized_payload { serialize_resource(vendor_user) }
            else
              render_error_payload(vendor_user.errors)
            end
          end

          private

          def serialize_collection(collection)
            collection_serializer.new(collection, include: %i[user vendor]).serializable_hash
          end

          def paginated_collection
            collection_paginator.new(@vendor.vendor_users, params).call
          end

          def collection_serializer
            Spree::V2::Vendor::VendorUserSerializer
          end

          def resource_serializer
            Spree::V2::Vendor::VendorUserSerializer
          end

          def vendor_user_params
            params.require(:vendor_user).permit(:email)
          end

          def create_vendor_user(user)
            vendor_user = Spree::VendorUser.new(vendor: @vendor, user: user)

            if vendor_user.save
              render_serialized_payload { serialize_resource(vendor_user) }
            else
              render_error_payload(vendor_user.errors)
            end
          end
        end
      end
    end
  end
end
