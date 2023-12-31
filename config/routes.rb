Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'static_pages#top'

  get 'terms', to: 'static_pages#terms'
  get 'privacy_policy', to: 'static_pages#privacy_policy'

  get 'home', to: 'maps#home'
  get 'brands/search', to:'brands#search'

  devise_for :users
  resource :my_page, only: %i[show edit update]

  resources :shops, only: %i[show] do 
    resources :list_shops, only: %i[create destroy]
    resources :reviews, only: %i[new create destroy edit update destroy], shallow: true do
      collection do
        get :more
      end
    end
  end
  resources :shop_saved_lists
end
