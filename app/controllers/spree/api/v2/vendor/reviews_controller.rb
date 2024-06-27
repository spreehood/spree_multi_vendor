module Spree
  module Api
    module V2
      module Vendor
        class ReviewsController < VendorBaseController
          before_action :load_vendor
          before_action :require_vendor_access

          # GET /api/v2/vendor/vendors/:vendor_id/reviews
          def index
            render_serialized_payload { serialize_collection(paginated_collection) }
          end

          # GET /api/v2/vendor/vendors/:vendor_id/reviews/:id
          def show
            review = Spree::Review.find(params[:id])

            if review
              render_serialized_payload { serialize_resource(review) }
            else
              render_error_payload(review.errors)
            end
          end

          # PUT/PATCH /api/v2/vendor/vendors/:vendor_id/reviews/:id
          def update
            review = Spree::Review.find(params[:id])

            if review.update(review_params)
              render_serialized_payload { serialize_resource(review) }
            else
              render_error_payload(review.errors)
            end
          end

          # DELETE /api/v2/vendor/vendors/:vendor_id/reviews/:id
          def destroy
            review = Spree::Review.find(params[:id])

            if review.destroy
              render_serialized_payload { serialize_resource(review) }
            else
              render_error_payload(review.errors)
            end
          end

          private

          def collection_options(resource = nil)
            { include: params[:include] }
          end

          def paginated_collection
            collection_paginator.new(@vendor.reviews, params).call
          end

          def collection_serializer
            Spree::V2::Storefront::ReviewSerializer
          end

          def resource_serializer
            Spree::V2::Storefront::ReviewSerializer
          end

          def review_params
            params.require(:review).permit(:approved)
          end
        end
      end
    end
  end
end
