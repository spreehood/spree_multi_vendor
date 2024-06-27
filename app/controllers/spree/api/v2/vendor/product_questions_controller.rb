module Spree
  module Api
    module V2
      module Vendor
        class ProductQuestionsController < VendorBaseController
          before_action :load_vendor
          before_action :require_vendor_access

          # GET /api/v2/vendor/vendors/:vendor_id/questions
          def index
            render_serialized_payload { serialize_collection(paginated_collection) }
          end

          # GET /api/v2/vendor/vendors/:vendor_id/questions/:id
          def show
            question = @vendor.product_questions.find(params[:id])

            if question
              render_serialized_payload { serialize_resource(question) }
            else
              render_error_payload(question.errors)
            end
          end

          # PUT/PATCH /api/v2/vendor/vendors/:vendor_id/questions/:id
          def update
            question = @vendor.product_questions.find(params[:id])

            if question.update(product_question_params)
              render_serialized_payload { serialize_resource(question) }
            else
              render_error_payload(question.errors)
            end
          end

          # DELETE /api/v2/vendor/vendors/:vendor_id/questions/:id
          def destroy
            question = @vendor.product_questions.find(params[:id])

            if question.destroy
              render_serialized_payload { serialize_resource(question) }
            else
              render_error_payload(question.errors)
            end
          end

          private

          def paginated_collection
            collection_paginator.new(@vendor.product_questions, params).call
          end

          def collection_serializer
            Spree::V2::Storefront::ProductQuestionSerializer
          end

          def resource_serializer
            Spree::V2::Storefront::ProductQuestionSerializer
          end

          def product_question_params
            params.require(:product_question).permit(:is_visible, product_answer_attributes: [:content, ])
          end

          def collection_options(resource = nil)
            { include: params[:include] }
          end
        end
      end
    end
  end
end
