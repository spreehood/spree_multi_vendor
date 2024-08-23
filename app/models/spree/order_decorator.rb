# frozen_string_literal: true

Spree::Order.class_eval do
  def self.for_vendor(vendor)
    joins(:products)
      .where(products: { vendor_id: vendor.id })
      .distinct
  end
end
