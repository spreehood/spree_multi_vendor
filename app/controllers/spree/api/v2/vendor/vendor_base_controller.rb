module Spree
  module Api
    module V2
      module Vendor
        class VendorBaseController < ::Spree::Api::V2::BaseController
          protected

          def load_vendor
            @vendor = Spree::Vendor.friendly.find(params[:vendor_id])
          end

          def require_vendor_access
            require_spree_current_user

            raise CanCan::AccessDenied unless @vendor.users.include?(spree_current_user)
          end
        end
      end
    end
  end
end
