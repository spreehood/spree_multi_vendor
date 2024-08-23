# frozen_string_literal: true

module Spree
  module V2
    module Vendor
      class OrderSerializer < Spree::Api::V2::BaseSerializer
        set_type :order

        attributes :id, :number, :item_total, :total, :state, :adjustment_total, :user_id,
                   :completed_at, :bill_address_id, :ship_address_id, :payment_total,
                   :shipment_state, :payment_state, :email, :special_instructions, :created_at,
                   :updated_at, :currency, :last_ip_address, :created_by_id, :shipment_total,
                   :additional_tax_total, :promo_total, :channel, :included_tax_total,
                   :item_count, :approver_id, :approved_at, :confirmation_delivered,
                   :considered_risky, :token, :canceled_at, :canceler_id, :store_id,
                   :state_lock_version, :taxable_adjustment_total, :non_taxable_adjustment_total,
                   :store_owner_notification_delivered, :public_metadata, :private_metadata,
                   :internal_note, :preferences, :state_machine_resumed

        attribute :has_other_vendor_products do |order, params|
          order.products.where.not(vendor_id: params[:vendor_id]).exists?
        end

        has_many :line_items, serializer: Spree::V2::Storefront::LineItemSerializer do |order, params|
          order.line_items.joins(variant: :product).where(spree_products: { vendor_id: params[:vendor_id] })
        end
      end
    end
  end
end
