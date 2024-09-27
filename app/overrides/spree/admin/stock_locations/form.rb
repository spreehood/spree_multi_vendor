module Spree
  module Admin
    module StockLocations
      class Form
        Deface::Override.new(
          virtual_path: 'spree/admin/stock_locations/_form',
          name: 'Add vendor field in stock locations form',
          insert_bottom: 'div[data-hook="admin_stock_locations_form_fields"]',
          text: <<-HTML
            <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
              <div data-hook="admin_shipping_method_form_vendor">
                <%= f.field_container :vendor, class: ['form-group'] do %>
                  <%= f.label :vendor_id, Spree.t(:vendor) %>
                  <%= f.collection_select(:vendor_id, Spree::Vendor.all, :id, :name, { include_blank: Spree.t('match_choices.none') }, { class: 'select2' }) %>
                  <%= f.error_message_on :vendor %>
                <% end %>
              </div>
            <% end %>
          HTML
        )
      end
    end
  end
end