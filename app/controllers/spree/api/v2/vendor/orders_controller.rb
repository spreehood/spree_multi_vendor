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
            params[:q] ||= {}
            params[:q][:completed_at_not_null] ||= '1' if Spree::Backend::Config[:show_only_complete_orders_by_default]
            @show_only_completed = params[:q][:completed_at_not_null] == '1'
            params[:q][:s] ||= @show_only_completed ? 'completed_at desc' : 'created_at desc'
            params[:q][:completed_at_not_null] = '' unless @show_only_completed
            params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == '0'
            if params[:q][:created_at_gt].present?
              params[:q][:created_at_gt] = begin
                Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day
              rescue StandardError
                ''
              end
            end

            if params[:q][:created_at_lt].present?
              params[:q][:created_at_lt] = begin
                Time.zone.parse(params[:q][:created_at_lt]).end_of_day
              rescue StandardError
                ''
              end
            end

            if @show_only_completed
              params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
              params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
            end

            @search = scope.ransack(params[:q])
            @orders = @search.result(distinct: true)

            render_serialized_payload { serialize_collection(paginated_collection) }
          end

          private

          def serialize_collection(collection)
            collection_serializer.new(collection, { params: { vendor_id: @vendor.id }, include: resource_includes, fields: sparse_fields }).serializable_hash
          end

          def paginated_collection
            collection_paginator.new(@orders, params).call
          end

          def collection_serializer
            Spree::V2::Vendor::OrderSerializer
          end

          def resource_serializer
            Spree::V2::Vendor::OrderSerializer
          end

          def scope
            @scope ||= Spree::Order.for_vendor(@vendor)
          end
        end
      end
    end
  end
end
