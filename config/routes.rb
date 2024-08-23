Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :vendors do
      member do
        get :translations
        post :translations, to: 'vendors#edit_translations'
      end

      collection do
        post :update_positions
      end
    end
    get 'vendor_settings' => 'vendor_settings#edit'
    patch 'vendor_settings' => 'vendor_settings#update'
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v2 do
      namespace :storefront do
        resources :vendors, only: %i[show index create update destroy]

        namespace :account do
          resources :vendors, controller: :user_vendors, only: %i[index]
        end
      end

      namespace :vendor, only: [] do
        resources :vendors do
          resources :stock_locations, only: %i[index show create update destroy]
          resources :users, controller: :vendor_users, only: %i[index create destroy]
          resources :orders, only: %i[index]
        end
      end
    end
  end
end
