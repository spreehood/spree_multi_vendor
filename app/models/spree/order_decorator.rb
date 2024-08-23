# frozen_string_literal: true

module Spree
  module OrderDecorator
    def self.prepended(base)
      base.class_eval do
        def self.for_vendor(vendor)
          joins(:products)
            .where(products: { vendor_id: vendor.id })
            .distinct
        end
      end
    end
  end
end

Spree::Order.prepend Spree::OrderDecorator
